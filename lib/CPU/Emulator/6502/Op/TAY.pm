package CPU::Emulator::6502::Op::TAY;

use strict;

use constant ADDRESSING => {
	implied => 0xA8,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ y } = $reg->{ acc };
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ y } & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ y } == 0;

    $reg->{ pc }++;
}

1;
