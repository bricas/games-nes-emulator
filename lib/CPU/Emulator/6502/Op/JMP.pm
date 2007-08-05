package CPU::Emulator::6502::Op::JMP;

use strict;
use warnings;

use constant ADDRESSING => {
    absolute => 0x4C,
    indirect => 0x6C
};

=head1 NAME

CPU::Emulator::6502::Op::JMP - Jump

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 absolute( )

=cut

sub absolute {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 1 );
    $self->registers->{ pc } = $self->temp2;
}

=head2 indirect( )

=cut

sub indirect {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 3 );
    $self->registers->{ pc } = $self->memory->[ $self->temp2 ] + ( $self->memory->[ $self->temp2 + 1 ] << 8 )
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
