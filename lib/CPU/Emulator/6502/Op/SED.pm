package CPU::Emulator::6502::Op::SED;

use strict;

use constant ADDRESSING => {
    implied => 0xF8,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_DECIMAL;
    $reg->{ status } += CPU::Emulator::6502::SET_DECIMAL;
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
