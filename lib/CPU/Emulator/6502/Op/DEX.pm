package CPU::Emulator::6502::Op::DEX;

use strict;

use constant ADDRESSING => {
	implied => 0xCA,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ x } = ( $reg->{ x } - 1 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !$reg->{ x };
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ x } & 0x80;

    $reg->{ pc }++;			
}

1;
