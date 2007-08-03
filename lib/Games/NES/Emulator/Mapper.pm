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
        8  => [],
        16 => [],
        32 => [],
    } );
    $self->chr_map( {
        1 => [],
        2 => [],
        4 => [],
        8 => [],
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

=head2 swap_prg_8k( $offset, $bank )

Swap an 8K bank of PRGROM into the CPU's memory.

=cut

sub swap_prg_8k {
    my( $self, $offset, $bank ) = @_;
    my $slot = ($offset & 0x4000) >> 14;
    my $map_8k = $self->prg_map->{ 8 };

    if( !$map_8k->[ $slot ] || $map_8k->[ $slot ] != $bank ) {
        my $c = $self->context;
        my $bank_offset = 0;
        my $prg_bank = $bank >> 1;

        $bank_offset = 0x2000 if $bank == 1;
        splice( @{ $c->cpu->memory }, $bank_offset, 0x2000, unpack( 'C*', substr( $c->rom->PRG_banks->[ $prg_bank ], $bank_offset, 0x2000 ) ) );

        $map_8k->[ $slot ] = $bank;
    }

}

=head2 swap_prg_16k( $offset, $bank )

Swap a 16K bank of PRGROM into the CPU's memory.

=cut

sub swap_prg_16k {
    my( $self, $offset, $bank ) = @_;
    my $slot = ($offset & 0x4000) >> 14;
    my $map_16k = $self->prg_map->{ 16 };
    my $map_8k = $self->prg_map->{ 8 };

    if( $map_16k->[ $slot ] != $bank ) {
        my $c = $self->context;
        splice( @{ $c->cpu->memory }, $offset, 0x4000, unpack( 'C*', $c->rom->PRG_banks->[ $bank ] ) );
        $map_16k->[ $slot ] = $bank;
    }

    my $eb = $offset == 0x8000 ? 0 : 2;
    $map_8k->[ $eb ] = $bank << 1;
    $map_8k->[ $eb + 1 ] = ( $bank << 1 ) + 1;
}

=head2 swap_prg_32k( $bank )

Swap a 32K bank of PRGROM into the CPU's memory.

=cut

sub swap_prg_32k {
    my( $self, $bank ) = @_;
    my $map_8k = $self->prg_map->{ 8 };
    my $map_32k = $self->prg_map->{ 32 };

    if( !$map_32k->[ 0 ] || $map_32k->[ 0 ] != $bank ) {
        $map_32k->[ 0 ] = $bank;
        $bank <<= 1;
        my $c = $self->context;

        splice( @{ $c->cpu->memory }, 0x8000, 0x4000, unpack( 'C*', $c->rom->PRG_banks->[ $bank ] ) );
        splice( @{ $c->cpu->memory }, 0xC000, 0x4000, unpack( 'C*', $c->rom->PRG_banks->[ $bank + 1 ] ) );
    }

    my $b = $bank << 2;
    $map_8k = [ map { $b + $_ } (0..3) ];
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
