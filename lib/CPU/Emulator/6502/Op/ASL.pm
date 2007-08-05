package CPU::Emulator::6502::Op::ASL;

use strict;

use constant ADDRESSING => {
	accumulator => 0x0A,
	zero_page   => 0x06,
	zero_page_x => 0x16,
	absolute    => 0x0E,
	absolute_x  => 0x1E
};

sub accumulator {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $reg->{ acc } & 0x80;

    $reg->{ acc } = ( $reg->{ acc } << 1 ) & 0xff;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ acc } & 0x80;

    $reg->{ pc }++;
}

sub absolute_x {
    my $self = shift;
    $self->cycle_counter( $self->cycle_counter + 1 );
    do_op( $self );
}

*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $self->cycle_counter( $self->cycle_counter + 2 );
    $self->temp( $self->memory->[ $self->temp2 ] );

    $self->RAM_write( $self->temp2 => $self->temp );
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp & 0x80;

    $self->temp( ($self->temp << 1) & 0xff );

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $self->RAM_write( $self->temp2 => $self->temp );
}

1;
