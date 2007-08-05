package CPU::Emulator::6502::Op::PLP;

use strict;

use constant ADDRESSING => {
	implied => 0x28,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp }++;
    $self->{ status } = $self->memory->[ $reg->{ sp } + 0x100 ] | CPU::Emulator::6502::SET_UNUSED;
    $reg->{ pc }++;
    $self->cycle_counter( $self->cycle_counter + 2 );
}

1;
