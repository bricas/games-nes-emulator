package CPU::Emulator::6502::Op::STX;

use strict;
use warnings;

use constant ADDRESSING => {
    zero_page   => 0x86,
    zero_page_y => 0x96,
    absolute    => 0x8E,
};

=head1 NAME

CPU::Emulator::6502::Op::STX - Store the X register in memory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 zero_page( )

=head2 zero_page_y( )

=head2 absolute( )

=head2 do_op( )

=cut

*zero_page = \&do_op;
*zero_page_y = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    $self->RAM_write( $self->temp2, $self->registers->{ x } );
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
