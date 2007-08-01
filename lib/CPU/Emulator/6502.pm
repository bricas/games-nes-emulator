package CPU::Emulator::6502;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use constant SET_UNUSED => 0x20;
use constant RESET => 0x08;

__PACKAGE__->mk_accessors(
    qw( registers memory interrupt_line toggle frame_counter cycle_counter )
);

=head1 NAME

CPU::Emulator::6502 - Class representing a 6502 CPU

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new( )

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( @_ );

    $self->registers( CPU::Emulator::6502::Registers->new );
    $self->interrupt_line( 0 );
    $self->cycle_counter( 0 );

    return $self;
}

=head2 init( )

=cut

sub init {
    my $self = shift;
    my $reg = $self->registers;

    $self->memory( [ ] );
    $reg->status( SET_UNUSED );

    for( qw( acc x y pc sp ) ) {
        $reg->$_( 0 );
    }
}

=head2 RAM_read

=cut

sub RAM_read {
    my $self = shift;
    return $self->memory->[ shift ];
}

=head2 RAM_write

=cut

sub RAM_write {
    my $self = shift;
    $self->memory->[ shift ] = shift;
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
