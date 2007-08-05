package CPU::Emulator::6502::Op::PHP;

use strict;

use constant ADDRESSING => {
	implied => 0x08,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $self->memory->[ $reg->{ sp } + 0x100 ] = ( $reg->{ status } | CPU::Emulator::6502::SET_BRK );
    $reg->{ sp }--;
    $reg->{ pc }++;
    $self->cycle_counter( $self->cycle_counter + 1 );
}

1;
