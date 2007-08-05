package CPU::Emulator::6502::Op::RTS;

use strict;

use constant ADDRESSING => {
	implied => 0x60,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp } += 2;
    $reg->{ pc } = $self->memory->[ $reg->{ sp } - 1 + 0x100 ];
    $reg->{ pc } = $reg->{ pc } + ($self->memory->[$reg->{ pc } + 0x100] << 8);

    $reg->{ pc }++;
    $self->cycle_counter( $self->cycle_counter + 4 );
}

1;
