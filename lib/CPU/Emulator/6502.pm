package CPU::Emulator::6502;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

__PACKAGE__->mk_accessors(
    qw(
        registers memory interrupt_line
        toggle frame_counter cycle_counter
    )
);

1;
