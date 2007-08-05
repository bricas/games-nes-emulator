package CPU::Emulator::6502::Op::LDY;

use strict;

use constant ADDRESSING => {
	immediate   => 0xA0,
	zero_page   => 0xA4,
	zero_page_x => 0xB4,
	absolute    => 0xAC,
	absolute_x  => 0xBC
};

*immediate = \&do_op;
*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;


sub absolute_x {
    my $self = shift;
    my $reg = $self->registers;

    if( $self->temp2 - $reg->{ x } != ($self->temp2 & 0xff00) ) {
        $self->cycle_counter( $self->cycle_counter + 1 );
    }

    do_op( $self );
}

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ y } = $self->RAM_read( $self->temp2 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ y } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ y } & 0x80;
}

1;
