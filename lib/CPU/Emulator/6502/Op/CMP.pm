package CPU::Emulator::6502::Op::CMP;

use strict;

use constant ADDRESSING => {
    immediate   => 0xC9,
    zero_page   => 0xC5,
    zero_page_x => 0xD5,
    absolute    => 0xCD,
    absolute_x  => 0xDD,
    absolute_y  => 0xD9,
    indirect_x  => 0xC1,
    indirect_y  => 0xD1
};

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
    my $reg = $self->registers;

    $self->temp( $reg->{ acc } - $self->memory->[ $self->temp2 ] );
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SZC;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !($self->temp & 0xff);
    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp < 0x100;
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