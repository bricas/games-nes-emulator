package CPU::Emulator::6502::Op::BRK;

use strict;
use warnings;

use constant ADDRESSING => {
    implied => 0x00,
};

=head1 NAME

CPU::Emulator::6502::Op::BRK - Force break

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 implied( )

=cut

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    my $mem = $self->memory;

    $reg->{ pc } += 2;

    $mem->[ $reg->{ pc } + 0x100 ] = ( $reg->{ pc } & 0xff00 ) >> 8;

    $mem->[ $reg->{ sp } - 1 + 0x100 ] = $reg->{ pc } & 0xff;
    $mem->[ $reg->{ sp } - 2 + 0x100 ] = $reg->{ status } | CPU::Emulator::6502::SET_BRK;

    $reg->{ sp } -= 3;

    $reg->{ status } |= CPU::Emulator::6502::SET_INTERRUPT;
    $reg->{ pc } = $mem->[ 0xfffe ] + ( $mem->[ 0xffff ] << 8 );

    $self->cycle_counter( $self->cycle_counter + 5 );
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
