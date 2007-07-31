packages Games::NES::Emulator;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Games::NES::ROM; # the game
use Games::NES::CPU; # NES specific 6502 CPU
use Games::NES::PPU; # graphics
use Games::NES::APU; # audio

our $VERSION = '0.01';

__PACKAGE__->mk_accessors( qw( rom cpu ) );

sub new {
    my $class = shift;
    my $self  = $class::SUPER->new( @_ );

    $self->cpu( Games::NES::CPU->new )->init;

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

1;
