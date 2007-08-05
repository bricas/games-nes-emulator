package CPU::Emulator::6502::Op::JSR;

use strict;
use warnings;

use constant ADDRESSING => {
    absolute => 0x20
};

=head1 NAME

CPU::Emulator::6502::Op::JSR - Jump and save the return address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 absolute( )

=cut

sub absolute {
    my $self = shift;
    my $reg = $self->registers;
    my $mem = $self->memory;

    $mem->[ $reg->{ sp } + 0x100 ] = (($reg->{pc} + 2) & 0xff00) >> 8;
    $mem->[ $reg->{ sp } - 1 + 0x100 ] = ($reg->{pc} + 2) & 0xff;
    $reg->{ sp } -= 2;
    $self->temp( $mem->[ $reg->{ pc } + 1 ] + ( $mem->[ $reg->{pc} + 2 ] << 8 ) );
    $reg->{ pc } = $self->temp;
    $self->cycle_counter( $self->cycle_counter + 2 );
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
