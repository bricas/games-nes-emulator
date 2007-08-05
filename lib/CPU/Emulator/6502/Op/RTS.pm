package CPU::Emulator::6502::Op::RTS;

use strict;

use constant ADDRESSING => {
    implied => 0x60,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp } += 2;
    $reg->{ pc } = $self->memory->[ $reg->{ sp } - 1 + 0x100 ];
    $reg->{ pc } = $reg->{ pc } + ($self->memory->[$reg->{ pc } + 0x100] << 8);

    $reg->{ pc }++;
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
