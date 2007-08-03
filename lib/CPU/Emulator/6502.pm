package CPU::Emulator::6502;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Text::SimpleTable;

use constant SET_UNUSED => 0x20;
use constant RESET => 0x08;

__PACKAGE__->mk_accessors(
    qw( registers memory interrupt_line toggle
    frame_counter cycle_counter current_op )
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

=head2 handle_interrupt( )

=cut

sub handle_interrupt {
    my $self = shift;
}

=head2 execute_instruction( )

=cut

sub execute_instruction {
    my $self = shift;
    my $op = $self->get_instruction;
}

=head2 get_instruction( )

=cut

sub get_instruction {
    my $self = shift;
    my $reg  = $self->registers;
    my $op = $self->RAM_read( $reg->{ pc } );

    return $self->current_op( $op );
}

=head2 next_instruction( )

=cut

sub next_instruction {
    my $self = shift;
    my $reg  = $self->registers;
    $reg->{ pc } += 1;
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
