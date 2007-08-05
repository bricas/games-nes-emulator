package CPU::Emulator::6502::Op::INC;

use strict;
use warnings;

use constant ADDRESSING => {
    zero_page   => 0xE6,
    zero_page_x => 0xF6,
    absolute    => 0xEE,
    absolute_x  => 0xFE,
};

=head1 NAME

CPU::Emulator::6502::Op::INC - Increment by one

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 absolute_x( )

=head2 do_op( )

=cut

sub absolute_x {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 1 );
    do_op( $self );
}

*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg  = $self->registers;

    $self->cycle_counter( $self->cycle_counter + 2 );
    $self->temp( ( $self->memory->[ $self->temp2 ] + 1 ) & 0xff );

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $self->RAM_write( $self->temp2 => $self->temp - 1 );
    $self->RAM_write( $self->temp2 => $self->temp );
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
