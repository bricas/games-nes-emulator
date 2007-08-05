package CPU::Emulator::6502::Op::SBC;

use strict;

use constant ADDRESSING => {
	immediate   => 0xE9,
	zero_page   => 0xE5,
	zero_page_x => 0xF5,
	absolute    => 0xED,
	absolute_x  => 0xFD,
	absolute_y  => 0xF9,
	indirect_x  => 0xE1,
	indirect_y  => 0xF1
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

    $self->temp( $reg->{ acc } - $self->memory->[ $self->temp2 ] );
    $self->temp( $self->temp - 1 ) if !$reg->{ status } & CPU::Emulator::6502::SET_CARRY;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZOCS;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !($self->temp & 0xff);
								
    if( (( $reg->{ acc } ^ $self->memory->[ $self->temp2 ] ) & 0x80) and (($reg->{acc} ^ $self->temp ) & 0x80) ) {
        $reg->{ status } |= CPU::Emulator::6502::SET_OVERFLOW;
    }

    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp < 0x100;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $reg->{ acc } = $self->temp & 0xff;	
}

1;
