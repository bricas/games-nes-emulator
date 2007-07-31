packages Games::NES::Emulator;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Games::NES::ROM; # the game
use Games::NES::Emulator::CPU; # NES specific 6502 CPU
use Games::NES::Emulator::PPU; # graphics
use Games::NES::Emulator::APU; # audio

our $VERSION = '0.01';

__PACKAGE__->mk_accessors( qw( rom cpu ) );

sub new {
    my $class = shift;
    my $self  = $class::SUPER->new( @_ );

    $self->cpu( Games::NES::Emulator::CPU->new )->init;

    return $self;
}

sub load_rom {
    my $self     = shift;
    my $filename = shift;

    $self->rom( Games::NES::ROM->new( $filename ) );
}

sub run {
    my $self = shift;
    die "not implemented"
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<Games::NES::ROM>

=item * L<Games::NES::Emulator::CPU>

=item * L<Games::NES::Emulator::APU>

=item * L<Games::NES::Emulator::PPU>

=back

=cut

1;
