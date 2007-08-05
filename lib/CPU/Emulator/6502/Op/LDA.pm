package CPU::Emulator::6502::Op::LDA;

use strict;

use constant ADDRESSING => {
    immediate   => 0xA9,
    zero_page   => 0xA5,
    zero_page_x => 0xB5,
    absolute    => 0xAD,
    absolute_x  => 0xBD,
    absolute_y  => 0xB9,
    indirect_x  => 0xA1,
    indirect_y  => 0xB1
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

    $reg->{ acc } = $self->RAM_read( $self->temp2 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SZC;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;
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
