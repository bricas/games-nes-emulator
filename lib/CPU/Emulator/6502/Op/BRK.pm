package CPU::Emulator::6502::Op::BRK;

use strict;

use constant ADDRESSING => {
	implied => 0x00,
};

sub implied {
    my $self = shift;
    my $reg = $self->registers;
    my $mem = $self->memory;

    $reg->{ pc } += 2;

    $mem->[ $reg->{ pc } + 0x100 ] = ( $reg->{ pc } & 0xff00 ) >> 8;

    $mem->[ $reg->{ sp } - 1 + 0x100 ] = $reg->{ pc } & 0xff;
    $mem->[ $reg->{ sp } - 2 + 0x100 ] = $reg->{ status } | CPU::Emulator::6502::SET_BRK;

    $reg->{ sp } -= 3;

    $reg->{ status } |= CPU::Emulator::6502::SET_INTERRUPT;
    $reg->{ pc } = $mem->[ 0xfffe ] + ( $mem->[ 0xffff ] << 8 );

    $self->cycle_counter( $self->cycle_counter + 5 );

}

1;
