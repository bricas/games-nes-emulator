package CPU::Emulator::6502::Op::PHP;

use strict;

use constant ADDRESSING => {
    implied => 0x08,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $self->memory->[ $reg->{ sp } + 0x100 ] = ( $reg->{ status } | CPU::Emulator::6502::SET_BRK );
    $reg->{ sp }--;
    $reg->{ pc }++;
    $self->cycle_counter( $self->cycle_counter + 1 );
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
