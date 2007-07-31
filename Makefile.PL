use inc::Module::Install 0.65;

name 'Games-NES-Emulator';
all_from 'lib/Games/NES/Emulator.pm';

requires 'Games::NES::ROM';
requires 'Test::More';

auto_install;
WriteAll;
