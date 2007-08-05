package CPU::Emulator::6502::Op::SEC;

use strict;

use constant ADDRESSING => {
	implied => 0x38,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ status } += CPU::Emulator::6502::SET_CARRY;
    $reg->{ pc }++;
}		

1;
