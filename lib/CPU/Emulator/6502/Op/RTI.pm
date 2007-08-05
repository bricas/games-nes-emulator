package CPU::Emulator::6502::Op::RTI;

use strict;

use constant ADDRESSING => {
	implied => 0x40,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ sp }++;
    $reg->{ status } = $self->memory->[ $reg->{ sp } + 0x100 ];
    $reg->{ sp }++;
    $reg->{ pc } = $self->memory->[ $reg->{ sp } + 0x100 ];
    $reg->{ sp }++;
    $reg->{ pc } = $reg->{ pc } + ($self->memory->[ $reg->{ sp } + 0x100 ] << 8);

    $self->cycle_counter( $self->cycle_counter + 4 );
}

1;
