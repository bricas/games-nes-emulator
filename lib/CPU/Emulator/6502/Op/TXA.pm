package CPU::Emulator::6502::Op::TXA;

use strict;

use constant ADDRESSING => {
	implied => 0x8A,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ acc } = $reg->{ x };
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;

    $reg->{ pc }++;
}

1;
