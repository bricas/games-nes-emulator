package CPU::Emulator::6502::Op::CLD;

use strict;

use constant ADDRESSING => {
	implied => 0xD8,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_DECIMAL;
    $reg->{ pc }++;
}

1;
