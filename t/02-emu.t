use Test::More tests => 4;

use_ok( 'Games::NES::Emulator' );

my $emu = Games::NES::Emulator->new;
isa_ok( $emu, 'Games::NES::Emulator' );
isa_ok( $emu->cpu, 'Games::NES::Emulator::CPU' );

SKIP: {
    my $rom = $ENV{ TEST_ROM };
    skip 'No ROM specified in $ENV{ TEST_ROM }', 1 unless $rom;

    $emu->load_rom( $rom );
    isa_ok( $emu->rom, 'Games::NES::ROM' );
};


