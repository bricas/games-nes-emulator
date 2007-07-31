use Test::More tests => 1;

BEGIN { 
    use_ok( 'Games::NES::Emulator' );
    use_ok( 'Games::NES::CPU' );
    use_ok( 'Games::NES::APU' );
    use_ok( 'Games::NES::PPU' );
    use_ok( 'CPU::Emulator::6502' );
}
