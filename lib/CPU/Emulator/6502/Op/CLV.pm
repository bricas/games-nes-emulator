package CPU::Emulator::6502::Op::CLV;

use strict;

use constant ADDRESSING => {
	implied => 0xB8,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_OVERFLOW;
    $reg->{ pc }++;
}

1;
