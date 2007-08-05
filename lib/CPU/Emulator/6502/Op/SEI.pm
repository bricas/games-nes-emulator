package CPU::Emulator::6502::Op::SEI;

use strict;

use constant ADDRESSING => {
	implied => 0x78,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_INTERRUPT;
    $reg->{ status } += CPU::Emulator::6502::SET_INTERRUPT;
    $reg->{ pc }++;
}

1;
