package CPU::Emulator::6502::Op::AND;

use strict;

use constant ADDRESSING => {
	immediate   => 0x29,
	zero_page   => 0x25,
	zero_page_x => 0x35,
	absolute    => 0x2D,
	absolute_x  => 0x3D,
	absolute_y  => 0x39,
	indirect_x  => 0x21,
	indirect_y  => 0x31
};

*immediate = \&do_op;
*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;
*absolute_x = \&do_op;
*absolute_y = \&do_op;
*indirect_x = \&do_op;
*indirect_y = \&do_op;

sub do_op {
	my $self = shift;
	my $mem  = $self->memory;
    my $reg  = $self->registers;

	$reg->{ acc } &= $mem->[ $self->temp2 ];
	$reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
	$reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
	$reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
	$reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } == 0x80;
}

1;
