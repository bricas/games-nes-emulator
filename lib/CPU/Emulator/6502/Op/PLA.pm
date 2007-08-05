package CPU::Emulator::6502::Op::PLA;

use strict;

use constant ADDRESSING => {
	implied => 0x68,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp }++;
    $self->{ acc } = $self->memory->[ $reg->{ sp } + 0x100 ];
    $reg->{ pc }++;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;

    $self->cycle_counter( $self->cycle_counter + 2 );
}

1;
