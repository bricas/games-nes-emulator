package CPU::Emulator::6502::Op::JSR;

use strict;

use constant ADDRESSING => {
	absolute => 0x20
};

sub absolute {
    my $self = shift;
    my $reg = $self->registers;
    my $mem = $self->memory;

    $mem->[ $reg->{ sp } + 0x100 ] = (($reg->{pc} + 2) & 0xff00) >> 8;
    $mem->[ $reg->{ sp } - 1 + 0x100 ] = ($reg->{pc} + 2) & 0xff;
    $reg->{ sp } -= 2;
    $self->temp( $mem->[ $reg->{ pc } + 1 ] + ( $mem->[ $reg->{pc} + 2 ] << 8 ) );
    $reg->{ pc } = $self->temp;
    $self->cycle_counter( $self->cycle_counter + 2 );
}

1;
