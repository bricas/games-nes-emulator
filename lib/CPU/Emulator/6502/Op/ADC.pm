package CPU::Emulator::6502::Op::ADC;

use strict;
use warnings;

use constant ADDRESSING => {
    immediate   => 0x69,
    zero_page   => 0x65,
    zero_page_x => 0x75,
    absolute    => 0x6D,
    absolute_x  => 0x7D,
    absolute_y  => 0x79,
    indirect_x  => 0x61,
    indirect_y  => 0x71
};

=head1 NAME

CPU::Emulator::6502::Op::ADC - Add memory to accumulator with carry

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 absolute_x( )

=head2 absolute_y( )

=head2 indirect_x( )

=head2 indirect_y( )

=head2 do_op( )

=cut

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
    my $mem  = $self->memory;
    my $reg  = $self->registers;

    $self->temp( $reg->{ acc } + $mem->[ $self->temp2 ] );

    $self->temp( $self->temp + 1 ) if $reg->status & CPU::Emulator::6502::SET_CARRY;

    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZOCS;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO unless $self->temp & 0xFF;
    $reg->{ status } |= CPU::Emulator::6502::SET_CARRY if $self->temp > 0xFF;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;

    if( !( ( $reg->{ acc } ^ $mem->[ $self->temp2 ] ) & 0x80 ) && ( ( $reg->{ acc } ^ $self->temp ) & 0x80 ) ) {
        $reg->{ status } |= CPU::Emulator::6502::SET_OVERFLOW;
    }

    $reg->{ acc } = $self->temp & 0xFF;
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
