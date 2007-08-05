package CPU::Emulator::6502::Op::SED;

use strict;

use constant ADDRESSING => {
	implied => 0xF8,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_DECIMAL;
    $reg->{ status } += CPU::Emulator::6502::SET_DECIMAL;
    $reg->{ pc }++;
}

1;
