package CPU::Emulator::6502::Addressing;

use strict;
use warnings;

=head1 NAME

CPU::Emulator::6502::Addressing - Handle different addressing rules

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=cut

sub immediate {
    my $self = shift;
    my $reg  = $self->registers;

    $self->temp2( $reg->{ pc } + 1 );

    $reg->{ pc } += 2;
}

=head2 zero_page( )

=cut

sub zero_page {
    my $self = shift;
    my $reg  = $self->registers;

    $self->temp2( $self->memory->[ $reg->{ pc } + 1 ] );
    $reg->{ pc } += 2;
    $self->cycle_counter( $self->cycle_counter + 1 );
}

=head2 zero_page_x( )

=cut

sub zero_page_x {
    my $self = shift;
    my $reg  = $self->registers;

    $self->temp2( ( $self->memory->[ $reg->{ pc } + 1 ] + $reg->{ x } ) & 0xff );
    $reg->{ pc } += 2;
    $self->cycle_counter( $self->cycle_counter + 2 );
}

=head2 zero_page_y( )

=cut

sub zero_page_y {
    my $self = shift;
    my $reg  = $self->registers;

    $self->temp2( ( $self->memory->[ $reg->{ pc } + 1 ] + $reg->{ y } ) & 0xff );
    $reg->{ pc } += 2;
    $self->cycle_counter( $self->cycle_counter + 2 );
}

*indirect = \&absolute;

=head2 indirect( )

=head2 absolute( )

=cut

sub absolute {
    my $self = shift;
    my $reg  = $self->registers;
    my $mem  = $self->memory;

    $self->temp2( $mem->[ $reg->{ pc } + 1 ] + ( $mem->[ $reg->{ pc } + 2 ] << 8 ) );

    $reg->{ pc } += 3;
    $self->cycle_counter( $self->cycle_counter + 2 );
}

=head2 absolute_x( )

=cut

sub absolute_x {
    my $self = shift;
    my $op   = shift;
    my $reg  = $self->registers;
    my $mem  = $self->memory;

    $self->temp2( $mem->[ $reg->{ pc } + 1 ] + ( $mem->[ $reg->{ pc } + 2 ] << 8) + $reg->{ x } );

    $reg->{ pc } += 3;
    $self->cycle_counter( $self->cycle_counter + 2 );

    unless( grep { $op == $_ } ( 0x1E, 0xDE, 0xFE, 0x5E, 0x3E, 0x7E ) ) {
        if( ( ( $self->temp2 - $reg->{x} ) & 0xFF00 ) != ( $self->temp2 & 0xFF00 ) ) {
            $self->cycle_counter( $self->cycle_counter + 1 );
        }
    }
}

=head2 absolute_y( )

=cut

sub absolute_y {
    my $self = shift;
    my $mem  = $self->memory;
    my $reg  = $self->registers;

    $self->temp2( $mem->[ $reg->{ pc } + 1 ] + ( $mem->[ $reg->{ pc } + 2 ] << 8) + $reg->{ y } );

    $reg-> { pc } += 3;
    $self->cycle_counter( $self->cycle_counter + 2 );

    if( ( ( $self->temp2 - $reg->{ y } ) & 0xFF00 ) != ( $self->temp2 & 0xFF00 ) ) {
        $self->cycle_counter( $self->cycle_counter + 1 );
    }
}

=head2 indirect_x( )

=cut

sub indirect_x {
    my $self = shift;
    my $mem  = $self->memory;
    my $reg  = $self->registers;

    $self->temp2( $mem->[ ( $mem->[ $reg->{ pc } + 1 ] + $reg->{ x } ) & 0xFF ] + $mem->[ ( ( $mem->[ $reg->{ pc } + 1 ] + $reg->{ x } ) & 0xFF ) + 1] << 8 );

    $reg->{ pc } += 2;
    $self->cycle_counter( $self->cycle_counter + 4 );
}

=head2 indirect_y( )

=cut

sub indirect_y {
    my $self = shift;
    my $op   = shift;
    my $mem  = $self->memory;
    my $reg  = $self->registers;

    $self->temp2( $mem->[ $mem->[ $reg->{ pc } + 1 ] ] + ( $mem->[ $mem->[ $reg->{ pc } + 2 ] + 1 ] << 8 ) + $reg->{ y } );

    $reg->{ pc } += 2;
    $self->cycle_counter( $self->cycle_counter + 3 );

    unless( $op == 0x91 ) {
        if( ( ( $self->temp2 - $reg->{ y } ) & 0xFF00 ) != ( $self->temp2 & 0xFF00 ) ) {
            $self->cycle_counter( $self->cycle_counter + 1 );
        }
    }
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<CPU::Emulator::6502>

=back

=cut

1;
