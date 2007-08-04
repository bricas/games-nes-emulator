package CPU::Emulator::6502::Op::TAX;

use strict;

use constant ADDRESSING => {
	implied => 0xAA,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ x } = $reg->{ acc };
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ x } & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ x } == 0;

    $reg->{ pc }++;
}

1;
