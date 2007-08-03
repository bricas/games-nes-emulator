package Games::NES::Emulator::PPU;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

__PACKAGE__->mk_accessors( qw( registers SPRRAM ) );

my @registers = qw( control1 control2 status SPRRAM_addr VRAM_IO VRAM_addr VRAM_temp_addr );

=head1 NAME

Games::NES::Emulator::PPU - NES Picture Processing Unit

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 init( )

=cut

sub init {
    my $self = shift;
    $self->SPRRAM( [ ( 0 ) x ( 0xFF + 1 ) ] );

    $self->registers( { map { $_ => 0 } @registers } );
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<Games::NES::Emulator>

=back

=cut

1;
