package CPU::Emulator::6502::Op::ORA;

use strict;

use constant ADDRESSING => {
	immediate   => 0x09,
	zero_page   => 0x05,
	zero_page_x => 0x15,
	absolute    => 0x0D,
	absolute_x  => 0x1D,
	absolute_y  => 0x19,
	indirect_x  => 0x01,
	indirect_y  => 0x11
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
    my $reg  = $self->registers;

    $reg->{ acc } |= $self->memory->[ $self->temp2 ];
	$reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
	$reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
	$reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
	$reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } == 0x80;
}

1;
