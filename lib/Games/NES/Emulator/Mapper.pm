package Games::NES::Emulator::Mapper;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Scalar::Util ();

__PACKAGE__->mk_accessors( 'context' );

=head1 NAME

Games::NES::Emulator::Mapper - Base class for mappers

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 init( )

=cut

sub init {
    my $self = shift;
    my $emu = shift;

    $self->context( Scalar::Util::weaken( $emu ) );
}

=head2 read( $address )

Reads $address from the CPU's memory.

=cut

sub read {
    my( $self, $addr ) = @_;
    return $self->context->cpu->memory->[ $addr ];
}

=head2 write( $address => $data )

The base mapper doesn't actually do any writes.

=cut

sub write {
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<Games::NES::Emulator>

=back

=cut

1;
