package CPU::Emulator::6502::Op::DEY;

use strict;

use constant ADDRESSING => {
	implied => 0x88,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ y } = ( $reg->{ y } - 1 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !$reg->{ y };
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ y } & 0x80;

    $reg->{ pc }++;			
}

1;
