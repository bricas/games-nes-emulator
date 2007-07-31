package Games::NES::Emulator;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );

use Games::NES::ROM; # the game
use Games::NES::Emulator::CPU; # NES specific 6502 CPU
use Games::NES::Emulator::PPU; # graphics
use Games::NES::Emulator::APU; # audio

our $VERSION = '0.01';

__PACKAGE__->mk_accessors( qw( rom cpu ) );

=head1 NAME

Games::NES::Emulator - An object-oriented NES (6502) emulator

=head1 SYNOPSIS

    use Games::NES::Emulator;
    
    my $emu = Games::NES::Emulator->new;
    $emu->load_rom( 'mario.nes' );
    $emu->run;

=head1 WARNING

Don't get too excited -- this code doesn't really do anything yet. Don't
complain to me that "Blaster Master" isn't working. It's not ready yet.

=head1 DESCRIPTION

Games::Emulator::NES contains a set of modules to emulate a classic NES
gaming machine.

=head1 RATIONALE

I've always been interested in hardware emulation. I grew up playing the NES,
so I figured it would be a decent place to start. Over the last year I've
written some (non-functioning) code based on some freely available emulators
on the web. Hopefully by putting the skeleton of the code online, it will spur
me on to continue the development.

As for choosing Perl for the emulation language, Perl is what I'm most
comfortable with, and I don't particularly care about speed -- yet. Perhaps
some bits can be rewritten in XS, but I'll cross that bridge when i get to it.

=head1 METHODS

=head2 new( )

Create a new instance of the emulator. Initializes the CPU.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new( @_ );

    $self->cpu( Games::NES::Emulator::CPU->new )->init;

    return $self;
}

=head2 load_rom( $filename )

Loads the rom from C<$filename>.

=cut

sub load_rom {
    my $self     = shift;
    my $filename = shift;

    $self->rom( Games::NES::ROM->new( $filename ) );
}

=head2 run( )

Begins execution of the code found in the ROM.

=cut

sub run {
    my $self = shift;
    die 'No ROM loaded.' unless $self->rom;
    die 'Not implemented!'
}

=head1 AUTHOR

Brian Cassidy E<lt>bricas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Brian Cassidy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 SEE ALSO

=over 4 

=item * L<Games::NES::ROM>

=item * L<Games::NES::Emulator::CPU>

=item * L<Games::NES::Emulator::APU>

=item * L<Games::NES::Emulator::PPU>

=back

=cut

1;
