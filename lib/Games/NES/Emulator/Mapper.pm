package Games::NES::Emulator::Mapper;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Scalar::Util ();

__PACKAGE__->mk_accessors( qw( context chr_map prg_map ) );

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
    Scalar::Util::weaken( $emu );

    $self->context( $emu );

    $self->_init_maps;
    $self->_init_memory;
}

sub _init_maps {
    my $self = shift;
    $self->prg_map( {
        8  => undef,
        16 => undef,
        32 => undef,
    } );
    $self->chr_map( {
        1 => undef,
        2 => undef,
        4 => undef,
        8 => undef,
    } );
}

sub _init_memory {
    my $self = shift;
    my $rom  = $self->context->rom;

    my $prgs = $rom->PRG_count;
	if( $prgs > 0 ) {				
		if( $prgs == 1 ) {
            $self->swap_prg_16k( 0x8000, 0 );
            $self->swap_prg_16k( 0xC000, 0 );
        }
        else {
            $self->swap_prg_32k( 0 );
        }
	}
		
	if( $rom->CHR_count > 0 ) {			
        $self->swap_chr_8k( 0 );
	}	    
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

=head2 swap_prg_8k

=cut

sub swap_prg_8k {
}

=head2 swap_prg_16k

=cut

sub swap_prg_16k {
}

=head2 swap_prg_32k

=cut

sub swap_prg_32k {
}

=head2 swap_chr_1k

=cut

sub swap_chr_1k {
}

=head2 swap_chr_2k

=cut

sub swap_chr_2k {
}

=head2 swap_chr_4k

=cut

sub swap_chr_4k {
}

=head2 swap_chr_8k

=cut

sub swap_chr_8k {
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
