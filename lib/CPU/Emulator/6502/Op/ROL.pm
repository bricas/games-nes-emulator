package CPU::Emulator::6502::Op::ROL;

use strict;
use warnings;

use constant ADDRESSING => {
    accumulator => 0x2A,
    zero_page   => 0x26,
    zero_page_x => 0x36,
    absolute    => 0x2E,
    absolute_x  => 0x3E,
};

=head1 NAME

CPU::Emulator::6502::Op::ROL - Rotate left through carry

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 accumulator( )

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 absolute_x( )

=head2 do_op( )

=cut

sub accumulator {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ acc } = $reg->{ acc } << 1;
    $reg->{ acc } |= 0x01 if $reg->{ status } & CPU::Emulator::6502::SET_CARRY;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $reg->{ acc } > 0xff;
    $reg->{ acc } &= 0xff;

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
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $self->temp( $self->memory->[ $self->temp2 ] );
    $self->RAM_write( $self->temp2 => $self->temp );

    $self->temp( $self->temp << 1 );
    $self->temp( $self->temp | 0x01 ) if $reg->{ status } & CPU::Emulator::6502::SET_CARRY;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp > 0xff;

    $self->temp( $self->temp & 0xff );

    $reg->{ status } += CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
    $reg->{ status } += CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    $self->RAM_write( $self->temp2 => $self->temp );
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<CPU::Emulator::6502>

=back

=cut

1;
