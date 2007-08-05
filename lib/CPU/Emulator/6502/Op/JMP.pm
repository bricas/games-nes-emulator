package CPU::Emulator::6502::Op::JMP;

use strict;

use constant ADDRESSING => {
	absolute => 0x4C,
	indirect => 0x6C
};

sub absolute {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 1 );
    $self->registers->{ pc } = $self->temp2;
}

sub indirect {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 3 );
    $self->registers->{ pc } = $self->memory->[ $self->temp2 ] + ( $self->memory->[ $self->temp2 + 1 ] << 8 )
}

1;
