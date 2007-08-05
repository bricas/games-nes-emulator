package CPU::Emulator::6502::Op::LDY;

use strict;
use warnings;

use constant ADDRESSING => {
    immediate   => 0xA0,
    zero_page   => 0xA4,
    zero_page_x => 0xB4,
    absolute    => 0xAC,
    absolute_x  => 0xBC
};

=head1 NAME

CPU::Emulator::6502::Op::LDY - Load Y register from memory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 absolute_x( )

=head2 do_op( )

=cut

*immediate = \&do_op;
*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;

sub absolute_x {
    my $self = shift;
    my $reg = $self->registers;

    if( $self->temp2 - $reg->{ x } != ($self->temp2 & 0xff00) ) {
        $self->cycle_counter( $self->cycle_counter + 1 );
    }

    do_op( $self );
}

sub do_op {
    my $self = shift;
    my $reg = $self->registers;

    $reg->{ y } = $self->RAM_read( $self->temp2 ) & 0xff;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_ZERO;
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SIGN;

    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if $reg->{ y } == 0;
    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $reg->{ y } & 0x80;
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
