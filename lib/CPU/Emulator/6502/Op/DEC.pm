package CPU::Emulator::6502::Op::DEC;

use strict;

use constant ADDRESSING => {
	zero_page   => 0xC6,
	zero_page_x => 0xD6,
	absolute    => 0xCE,
	absolute_x  => 0xDE,
};

sub absolute_x {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 1 );
    do_op( $self );
}

*zero_page = \&do_op;
*zero_page_z = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg  = $self->registers;

    $self->cycle_counter( $self->cycle_counter + 2 );
    $self->temp( ( $self->memory->[ $self->temp2 ] - 1 ) & 0xff );

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $self->RAM_write( $self->temp2 => $self->temp + 1 );
    $self->RAM_write( $self->temp2 => $self->temp );
}

1;
