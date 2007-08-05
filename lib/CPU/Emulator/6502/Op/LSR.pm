package CPU::Emulator::6502::Op::LSR;

use strict;
use warnings;

use constant ADDRESSING => {
    accumulator => 0x4A,
    zero_page   => 0x46,
    zero_page_x => 0x56,
    absolute    => 0x4E,
    absolute_x  => 0x5E
};

=head1 NAME

CPU::Emulator::6502::Op::LSR - Shift right

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

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;

    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $reg->{ acc } & 1;

    $reg->{ acc } = $reg->{ acc } >> 1;


    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ acc } == 0;

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

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_CARRY;

    $self->temp( $self->memory->[ $self->temp2 ] );
    $self->RAM_write( $self->temp2 => $self->temp );

    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp & 1;

    $self->temp( $self->temp >> 1 );

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $self->temp == 0;
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
