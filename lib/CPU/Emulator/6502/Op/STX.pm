package CPU::Emulator::6502::Op::STX;

use strict;

use constant ADDRESSING => {
	zero_page   => 0x86,
	zero_page_y => 0x96,
	absolute    => 0x8E,
};

*zero_page = \&do_op;
*zero_page_y = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
#    $self->RAM_write( $self->temp2, $self->registers->{ x } );
}

1;
