package CPU::Emulator::6502::Op::CLC;

use strict;

use constant ADDRESSING => {
	implied => 0x18,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ pc }++;
}

1;
