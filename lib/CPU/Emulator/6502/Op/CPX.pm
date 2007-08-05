package CPU::Emulator::6502::Op::CPX;

use strict;

use constant ADDRESSING => {
	immediate   => 0xE0,
	zero_page   => 0xE4,
	absolute    => 0xEC,
};

*immediate = \&do_op;
*zero_page = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;
    
    $self->temp( $reg->{ x } - $self->memory->[ $self->temp2 ] );
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SZC;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !($self->temp & 0xff);
    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp < 0x100;
}

1;
