package CPU::Emulator::6502::Op::PHA;

use strict;

use constant ADDRESSING => {
	implied => 0x48,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $self->memory->[ $reg->{ sp } + 0x100 ] = $reg->{ acc };
    $reg->{ sp }--;
    $reg->{ pc }++;
    $self->cycle_counter( $self->cycle_counter + 1 );
}

1;
