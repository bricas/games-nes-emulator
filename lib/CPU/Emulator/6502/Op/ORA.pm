package CPU::Emulator::6502::Op::ORA;

use strict;
use warnings;

use constant ADDRESSING => {
    immediate   => 0x09,
    zero_page   => 0x05,
    zero_page_x => 0x15,
    absolute    => 0x0D,
    absolute_x  => 0x1D,
    absolute_y  => 0x19,
    indirect_x  => 0x01,
    indirect_y  => 0x11
};

=head1 NAME

CPU::Emulator::6502::Op::ORA - Logical OR memory with accumulator

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 absolute_x( )

=head2 absolute_y( )

=head2 indirect_x( )

=head2 indirect_y( )

=head2 do_op( )

=cut

*immediate = \&do_op;
*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;
*absolute_x = \&do_op;
*absolute_y = \&do_op;
*indirect_x = \&do_op;
*indirect_y = \&do_op;

sub do_op {
    my $self = shift;
    my $reg  = $self->registers;

    $reg->{ acc } |= $self->memory->[ $self->temp2 ];
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } == 0x80;
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
