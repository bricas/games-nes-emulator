use inc::Module::Install 0.65;

name 'Games-NES-Emulator';
all_from 'lib/Games/NES/Emulator.pm';

requires 'Games::NES::ROM';
requires 'Test::More';
requires 'Class::Accessor::Fast';

auto_install;
WriteAll;
