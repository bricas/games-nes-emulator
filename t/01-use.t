use Test::More tests => 1;

BEGIN { 
    use_ok( 'Games::NES::Emulator' );
    use_ok( 'Games::NES::Emulator::CPU' );
    use_ok( 'Games::NES::Emulator::APU' );
    use_ok( 'Games::NES::Emulator::PPU' );
    use_ok( 'CPU::Emulator::6502' );
}
