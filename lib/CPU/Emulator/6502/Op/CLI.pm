package CPU::Emulator::6502::Op::CLI;

use strict;

use constant ADDRESSING => {
	implied => 0x58,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_INTERRUPT;
    $reg->{ pc }++;
}

1;
