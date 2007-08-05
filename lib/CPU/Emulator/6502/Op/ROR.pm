package CPU::Emulator::6502::Op::ROR;

use strict;

use constant ADDRESSING => {
	accumulator => 0x6A,
	zero_page   => 0x66,
	zero_page_x => 0x76,
	absolute    => 0x6E,
	absolute_x  => 0x7E,
};

sub accumulator {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ acc } |= 0x100 if $reg->{ status } & CPU::Emulator::6502::SET_CARRY;

    if( $reg->{ acc } & 1 ) {
        $reg->{ status } |= CPU::Emulator::6502::SET_CARRY;
    }
    else {
        $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    }

    $reg->{ acc } = $reg->{ acc } >> 1;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;

    $reg->{ pc }++;
}

sub absolute_x {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 3 );
    do_op( $self );
}

*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&dop;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $self->temp( $self->memory->[ $self->temp2 ] );
    $self->RAM_write( $self->temp2 => $self->temp );

    $self->temp( $self->temp | 0x100 ) if $reg->{ status } & CPU::Emulator::6502::SET_CARRY;

    if( $self->temp & 1 ) {
        $reg->{ status } |= CPU::Emulator::6502::SET_CARRY;
    }
    else {
        $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    }

    $self->temp( $self->temp >> 1 );

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } += CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
    $reg->{ status } += CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $self->RAM_write( $self->temp2 => $self->temp );
}

1;
