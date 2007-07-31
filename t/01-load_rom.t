use Test::More;

my $rom;

BEGIN {
    $rom = $ENV{ TEST_ROM };
    plan skip_all => 'No ROM specified in $ENV{ TEST_ROM}' unless $rom;
    plan tests => 3;
}

use_ok( 'Games::NES::Emulator' );

my $emu = Games::NES::Emulator->new;

isa_ok( $emu, 'Games::NES::Emulator' );
$emu->load_rom( $rom );

isa_ok( $emu->rom, 'Games::NES::ROM' );
