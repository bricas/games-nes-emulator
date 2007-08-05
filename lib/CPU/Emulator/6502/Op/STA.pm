package CPU::Emulator::6502::Op::STA;

use strict;
use warnings;

use constant ADDRESSING => {
    zero_page   => 0x85,
    zero_page_x => 0x95,
    absolute    => 0x8D,
    absolute_x  => 0x9D,
    absolute_y  => 0x99,
    indirect_x  => 0x81,
    indirect_y  => 0x91
};

=head1 NAME

CPU::Emulator::6502::Op::STA - Store accumulator in memory

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

*absolute_x = \&indirect_y;
*absolute_y = \&indirect_y;

sub indirect_y {
    my( $self ) = @_;
    $self->cycle_counter( $self->cycle_counter + 1 );
}

*zero_page = \&indirect_x;
*zero_page_x = \&indirect_x;
*absolute = \&indirect_x;

sub indirect_x {
    my( $self ) = @_;
    $self->RAM_write( $self->temp2, $self->registers->{ acc } );
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
