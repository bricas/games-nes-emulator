package CPU::Emulator::6502::Op::CLC;

use strict;
use warnings;

use constant ADDRESSING => {
    implied => 0x18,
};

=head1 NAME

CPU::Emulator::6502::Op::CLC - Clear the carry flag

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 implied( )

=cut

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
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
