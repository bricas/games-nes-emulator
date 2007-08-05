package CPU::Emulator::6502::Op::BVS;

use strict;

use constant ADDRESSING => {
	relative => 0x70,
};

sub relative {
    my $self = shift;
    my $reg = $self->registers;

    $self->temp2( $reg->{ pc } );
    $reg->{ pc } += 2;

    if( ($reg->{status} & CPU::Emulator::6502::SET_OVERFLOW) ) {
        if( $self->memory->[ $reg->{ pc } - 1 ] & 0x80 ) {
            $reg->{ pc } -= (128 - ($self->memory->[ $reg->{pc} - 1 ] & 0x7f ));
        }
        else {
            $reg->{ pc } += $self->memory->[ $reg->{ pc } - 1 ];
        }

        if( ( $reg->{ pc } & 0xFF00 ) == ( $self->temp2 & 0xff00 ) ) {
            $self->cycle_counter( $self->cycle_counter + 1 );
        }
        else {
            $self->cycle_counter( $self->cycle_counter + 2 );
        }
    }
}

1;
