package CPU::Emulator::6502::Op::RTI;

use strict;
use warnings;

use constant ADDRESSING => {
    implied => 0x40,
};

=head1 NAME

CPU::Emulator::6502::Op::RTI - Return from BRK/IRQ/NMI

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 implied( )

=cut

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp }++;
    $reg->{ status } = $self->memory->[ $reg->{ sp } + 0x100 ];
    $reg->{ sp }++;
    $reg->{ pc } = $self->memory->[ $reg->{ sp } + 0x100 ];
    $reg->{ sp }++;
    $reg->{ pc } = $reg->{ pc } + ($self->memory->[ $reg->{ sp } + 0x100 ] << 8);

    $self->cycle_counter( $self->cycle_counter + 4 );
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
