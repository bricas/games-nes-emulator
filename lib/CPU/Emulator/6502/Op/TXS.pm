package CPU::Emulator::6502::Op::TXS;

use strict;

use constant ADDRESSING => {
	implied => 0x9A,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp } = $reg->{ x };
    $reg->{ pc }++;
}

1;
