package CPU::Emulator::6502;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Text::SimpleTable;
use CPU::Emulator::6502::Addressing;
use Module::Pluggable::Object;

# status constants
use constant SET_CARRY     => 0x01;
use constant SET_ZERO      => 0x02;
use constant SET_INTERRUPT => 0x04;
use constant SET_DECIMAL   => 0x08;
use constant SET_BRK       => 0x10;
use constant SET_UNUSED    => 0x20;
use constant SET_OVERFLOW  => 0x40;
use constant SET_SIGN      => 0x80;

use constant CLEAR_CARRY     => 0xFE;
use constant CLEAR_ZERO      => 0xFD;
use constant CLEAR_INTERRUPT => 0xFB;
use constant CLEAR_DECIMAL   => 0xF7;
use constant CLEAR_BRK       => 0xEF;
use constant CLEAR_UNUSED    => 0xDF;
use constant CLEAR_OVERFLOW  => 0xBF;
use constant CLEAR_SIGN      => 0x7F;

use constant CLEAR_SZC  => CLEAR_SIGN & CLEAR_ZERO & CLEAR_CARRY;
use constant CLEAR_SOZ  => CLEAR_SIGN & CLEAR_OVERFLOW & CLEAR_ZERO;
use constant CLEAR_ZS   => CLEAR_ZERO & CLEAR_SIGN;
use constant CLEAR_ZOCS => CLEAR_ZERO & CLEAR_OVERFLOW & CLEAR_CARRY & CLEAR_SIGN;

# interrupt constants
use constant BRK    => 0x01;
use constant IRQ    => 0x02;
use constant NMI    => 0x04;
use constant RESET  => 0x08;
use constant APUIRQ => 0x10;

__PACKAGE__->mk_accessors(
    qw( registers memory interrupt_line toggle
    frame_counter cycle_counter current_op
    temp temp2 instruction_table )
);

my @registers = qw( acc x y pc sp status );

=head1 NAME

CPU::Emulator::6502 - Class representing a 6502 CPU

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 REGISTERS

=over 4

=item * acc - Accumulator

=item * x

=item * y

=item * pc - Program Counter

=item * sp - Stack Pointer

=item * status

=back

=head1 METHODS

=head2 new( )

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( @_ );

    $self->registers( {
        map { $_ => undef } @registers
    } );
    $self->interrupt_line( 0 );
    $self->cycle_counter( 0 );

    return $self;
}

=head2 init( )

=cut

sub init {
    my $self = shift;
    my $reg = $self->registers;

    $self->memory( [ ( undef ) x 0xFF ] );
    $reg->{ status } = SET_UNUSED;

    for( @registers ) {
        $reg->{ $_ } =  0;
    }

    $self->create_instruction_table;
}

=head2 create_instruction_table

Dynamically loads all instructions from the CPU::Emulator::6502::Op
namespace and creates a table.

=cut

sub create_instruction_table {
    my $self  = shift;
    my $table = { };

    my $locator = Module::Pluggable::Object->new(
        search_path => __PACKAGE__ . '::Op',
        require     => 1
    );
    
    for my $instruction ( $locator->plugins ) {
        for my $name ( keys %{ $instruction->ADDRESSING } ) {
            $table->{ $instruction->ADDRESSING->{ $name } } = {
                mode => $name,
                sub  => $instruction . "::$name"
            }
        }
    }

    $self->instruction_table( $table );
}

=head2 RAM_read( $address )

Reads data from C<$address> in memory.

=cut

sub RAM_read {
    my $self = shift;
    return $self->memory->[ shift ];
}

=head2 RAM_write( $address => $data )

Writes C<$data> to C<$address> in memory.

=cut

sub RAM_write {
    my $self = shift;
    $self->memory->[ shift ] = shift;
}

=head2 interrupt_request()

=cut

sub interrupt_request {
    my $self = shift;
    my $mem  = $self->memory;
    my $reg  = $self->registers;
    my $sp   = $reg->{ sp };
    my $pc   = $reg->{ pc };
    my $int  = $self->interrupt_line;

    $mem->[ $sp + 0x100 ]     = ( ( $pc + 2 ) & 0xFF00 ) >> 8;
    $mem->[ $sp - 1 + 0x100 ] = ( $pc + 2 ) & 0xFF;
    $mem->[ $sp - 2 + 0x100 ] = $reg->{ status };

    $reg->{ sp } -= 3;

    if( $int == IRQ ) {
        $reg->{ pc } = $mem->[ 0xFFFE ] + ( $mem->[ 0xFFFF ] << 8 );
    }
    elsif( $int == NMI ) {
        $reg->{ pc } = $mem->[ 0xFFFA ] + ( $mem->[ 0xFFFB ] << 8 );
    }

    $self->interrupt_line( 0 );
    $self->cycle_counter( $self->cycle_counter + 7 );
}

=head2 execute_instruction( )

=cut

sub execute_instruction {
    my $self = shift;
    my $reg = $self->registers;

    if ( $self->interrupt_line ) {
        if( $reg->{ status } & SET_INTERRUPT ) {
            if( $self->interrupt_line & NMI ) {
                $self->interrupt_line( NMI );
                $self->interrupt_request;
            }
        }
        else {
            $self->interrupt_request;
        }
    }

    my $op = $self->get_instruction;
    my $table = $self->instruction_table;
    my $mode;

    $mode = $table->{ $op }->{ mode } if $table->{ $op };

    $self->cycle_counter( $self->cycle_counter + 2 );
    $self->temp( undef );

    if( $mode and my $sub = CPU::Emulator::6502::Addressing->can( $mode ) ) {
        $sub->( $self, $op );
    }

    if( !$table->{ $op } ) {
        $reg->{ pc }++;
    }
    else {
        eval {
            no strict 'refs';
            $table->{ $op }->{ sub }->( $self );
        }
    }

}

=head2 get_instruction( )

=cut

sub get_instruction {
    my $self = shift;
    my $reg  = $self->registers;
    my $op = $self->RAM_read( $reg->{ pc } );

    return $self->current_op( $op );
}

=head2 debug( )

=cut

sub debug { 
    my $self = shift;
    my $reg = $self->registers;

    my $t = Text::SimpleTable->new(
        [ 4, 'PC' ], [ 4, 'SP' ], [ 2, 'A' ], [ 2, 'X' ], [ 2, 'Y' ], [ 8, 'Status' ], [ 4, 'OP' ],
    );

    my $status = $reg->{ status };
    my $a_status = '';
    $a_status .= vec( $status, 7, 1 ) ? 'S' : '.';
    $a_status .= vec( $status, 6, 1 ) ? 'V' : '.';
    $a_status .= vec( $status, 5, 1 ) ? '-' : '.';
    $a_status .= vec( $status, 4, 1 ) ? 'B' : '.';
    $a_status .= vec( $status, 3, 1 ) ? 'D' : '.';
    $a_status .= vec( $status, 2, 1 ) ? 'I' : '.';
    $a_status .= vec( $status, 1, 1 ) ? 'Z' : '.';
    $a_status .= vec( $status, 0, 1 ) ? 'C' : '.';

    $t->row(
        ( map { sprintf( '%x', $reg->{ $_ } ) } qw( pc sp acc x y ) ),
        $a_status,
        sprintf( '%x', $self->current_op || 0 ),
    );

    my $t_stack = Text::SimpleTable->new(
        [ 5,  'Stack' ]
    );

    my $t_code = Text::SimpleTable->new(
        [ 4, 'Addr' ], [ 27,  'Code' ]
    );

    for( 0..9 ) {
        $t_stack->row( sprintf( '%x', $self->memory->[ 0x1FF - $_ ] ) );
        my $line = $reg->{ pc } + $_;
        $t_code->row( sprintf( '%x', $line ), sprintf( '%x', $self->memory->[ $line ] ) );
    }

    my @s_rows = split( "\n", $t_stack->draw );
    my @c_rows = split( "\n", $t_code->draw );
    my $output = '';

    while( @s_rows ) {
        $output .= join( ' ', shift( @s_rows ), shift( @c_rows ) );
        $output .= "\n";
    }
    

    return $t->draw . $output;
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<Games::NES::Emulator>

=back

=cut

1;
