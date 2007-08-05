package CPU::Emulator::6502::Op::STY;

use strict;

use constant ADDRESSING => {
	zero_page   => 0x84,
	zero_page_x => 0x94,
	absolute    => 0x8C,
};

*zero_page = \&do_op;
*zero_page_y = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    $self->RAM_write( $self->temp2, $self->registers->{ y } );
}

1;
