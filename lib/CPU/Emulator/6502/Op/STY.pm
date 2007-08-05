package CPU::Emulator::6502::Op::STY;

use strict;
use warnings;

use constant ADDRESSING => {
    zero_page   => 0x84,
    zero_page_x => 0x94,
    absolute    => 0x8C,
};

=head1 NAME

CPU::Emulator::6502::Op::STY - Store the Y register in memory

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 zero_page( )

=head2 zero_page_x( )

=head2 absolute( )

=head2 do_op( )

=cut

*zero_page = \&do_op;
*zero_page_x = \&do_op;
*absolute = \&do_op;

sub do_op {
    my $self = shift;
    $self->RAM_write( $self->temp2, $self->registers->{ y } );
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
