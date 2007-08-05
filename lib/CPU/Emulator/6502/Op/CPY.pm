package CPU::Emulator::6502::Op::CPY;

use strict;
use warnings;

use constant ADDRESSING => {
    immediate   => 0xC0,
    zero_page   => 0xC4,
    absolute    => 0xCC,
};

=head1 NAME

CPU::Emulator::6502::Op::CPY - Compare the Y register

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 immediate( )

=head2 zero_page( )

=head2 absolute( )

=head2 do_op( )

=cut

*immediate = \&do_op;
*zero_page = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    my $reg = $self->registers;
    
    $self->temp( $reg->{ y } - $self->memory->[ $self->temp2 ] );
    $reg->{ status } &= CPU::Emulator::6502::CLEAR_SZC;

    $reg->{ status } |= CPU::Emulator::6502::SET_SIGN if $self->temp & 0x80;
    $reg->{ status } |= CPU::Emulator::6502::SET_ZERO if !($self->temp & 0xff);
    $reg->{ status } += CPU::Emulator::6502::SET_CARRY if $self->temp < 0x100;
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
