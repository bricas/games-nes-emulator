package CPU::Emulator::6502::Op::LDX;

use strict;
use warnings;

use constant ADDRESSING => {
    immediate   => 0xA2,
    zero_page   => 0xA6,
    zero_page_y => 0xB6,
    absolute    => 0xAE,
    absolute_y  => 0xBE,
};

=head1 NAME

CPU::Emulator::6502::Op::LDX - Load X register from memory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=head2 zero_page( )

=head2 zero_page_y( )

=head2 absolute( )

=head2 absolute_y( )

=head2 do_op( )

=cut

*immediate = \&do_op;
*zero_page = \&do_op;
*zero_page_y = \&do_op;
*absolute = \&do_op;
*absolute_y = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ x } = $self->RAM_read( $self->temp2 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ x } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ x } & 0x80;
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
