package CPU::Emulator::6502::Op::BMI;

use strict;
use warnings;

use constant ADDRESSING => {
    relative => 0x30,
};

=head1 NAME

CPU::Emulator::6502::Op::BMI - Branch on result minus

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 relative( )

=cut

sub relative {
    my $self = shift;
    my $reg = $self->registers;

    $self->temp2( $reg->{ pc } );
    $reg->{ pc } += 2;

    if( ($reg->{ status } & CPU::Emulator::6502::SET_SIGN ) ) {
        if( $self->memory->[ $reg->{ pc } - 1 ] & 0x80 ) {
            $reg->{ pc } -= (128 - ($self->memory->[ $reg->{pc} - 1 ] & 0x7f ));
        }
        else {
            $reg->{ pc } += $self->memory->[ $reg->{ pc } - 1 ];
        }

        if( ( $reg->{ pc } & 0xFF00 ) == ( $self->temp2 & 0xff00 ) ) {
            $self->cycle_counter( $self->cycle_counter + 1 );
        }
        else {
            $self->cycle_counter( $self->cycle_counter + 2 );
        }

    }
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
