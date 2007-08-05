package CPU::Emulator::6502::Op::NOP;

use strict;

use constant ADDRESSING => {
	implied => 0xEA,
};

sub implied {
    my $self = shift;
    $self->registers->{ pc }++;
}

1;
