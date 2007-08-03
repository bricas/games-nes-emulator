package Games::NES::Emulator::CPU;

use strict;
use warnings;

use base qw( CPU::Emulator::6502 );

use Scalar::Util ();

__PACKAGE__->mk_accessors( 'context' );

=head1 NAME

Games::NES::Emulator::CPU - NES Central Processing Unit

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 init()

=cut

sub init {
    my $self = shift;
    my $emu = shift;
    Scalar::Util::weaken( $emu );

    $self->SUPER::init( @_ );
    $self->context( $emu );
    $self->interrupt_line( 0 );

    $self->memory( [ ( 0 ) x ( 0xFFFF + 1 ) ] );

    my $reg = $self->registers;
    $reg->{ pc } = 0x8000;
    $reg->{ sp } = 0xFF;

    $self->toggle( 1 );
    $self->cycle_counter( 0 );
    $self->frame_counter( 0 );
}

=head2 RAM_read( $addr )

=cut

sub RAM_read {
    my( $self, $addr ) = @_;
    my $c = $self->context;
    my $block = $addr >> 13;

    # TODO other cases
    if( $block == 0 ) {
        return $self->SUPER::RAM_read( $addr & 0x7FF );
    }
    elsif( $block == 3 ) {
        return $self->SUPER::RAM_read( $addr );
    }
    else {
        return $c->mapper->read( $addr );
    }
}

=head2 RAM_write( $addr => $data )

=cut

sub RAM_write {
    my( $self, $addr, $data ) = @_;
    my $c = $self->context;
    my $block = $addr >> 13;

    # TODO other cases
    if( $block == 0 ) {
        return $self->SUPER::RAM_write( ( $addr & 0x7FF ) => $data );
    }
    elsif( $block == 3 ) {
        return $self->SUPER::RAM_write( $addr => $addr );
    }
    else {
        return $c->mapper->write( $addr => $data );
    }

}

=head2 DMAT_transfer( $page )

=cut

sub DMAT_transfer {
    my( $self, $page ) = @_;
    my $addr = $page * 0x100;

    my $ram = $self->context->ppu->SPRRAM;

    @$ram = map { $self->RAM_read( $addr + $_ ) } 0..0xFF;

    $self->cycle_counter( $self->cycle_counter + 512 );
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

=item * L<Games::NES::Emulator>

=back

=cut

1;
