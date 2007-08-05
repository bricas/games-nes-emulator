package CPU::Emulator::6502::Op::TYA;

use strict;

use constant ADDRESSING => {
    implied => 0x98,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ acc } = $reg->{ y };
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;

    $reg->{ pc }++;
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
