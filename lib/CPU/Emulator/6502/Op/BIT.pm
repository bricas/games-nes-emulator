package CPU::Emulator::6502::Op::BIT;

use strict;
use warnings;

use constant ADDRESSING => {
    zero_page => 0x24,
    absolute  => 0x2C,
};

=head1 NAME

CPU::Emulator::6502::Op::BIT - Bit test

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 zero_page( )

=head2 absolute( )

=head2 do_op( )

=cut

*zero_page = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $self->temp( $self->RAM_read( $self->temp2 ) );

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if ( $reg->{ acc } & $self->temp ) == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_OVERFLOW if $self->temp & 0x40;
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
