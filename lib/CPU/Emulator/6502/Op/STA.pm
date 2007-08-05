package CPU::Emulator::6502::Op::STA;

use strict;

use constant ADDRESSING => {
	zero_page   => 0x85,
	zero_page_x => 0x95,
	absolute    => 0x8D,
	absolute_x  => 0x9D,
	absolute_y  => 0x99,
	indirect_x  => 0x81,
	indirect_y  => 0x91
};

*absolute_x = \&indirect_y;
*absolute_y = \&indirect_y;

sub indirect_y {
    my( $self ) = @_;
    $self->cycle_counter( $self->cycle_counter + 1 );
}

*zero_page = \&indirect_x;
*zero_page_x = \&indirect_x;
*absolute = \&indirect_x;

sub indirect_x {
    my( $self ) = @_;
    $self->RAM_write( $self->temp2, $self->registers->{ acc } );
}

1;
