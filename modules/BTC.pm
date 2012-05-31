# Module: BTC. See below for documentation.
# Copyright (C) 2010-2012 Arinity Development Group, et al.
# This program is free software; rights to this code are stated in doc/LICENSE.
package M::BTC;
use strict;
use warnings;
use API::Std qw(cmd_add cmd_del trans);
use API::IRC qw(privmsg notice);
use JSON -support_by_pp;

# Initialization subroutine.
sub _init {
    # Create the BTC command.
    cmd_add('BTC', 0, 0, \%M::BTC::HELP_BTC, \&M::BTC::cmd_btc) or return;

    # Success.
    return 1;
}

# Void subroutine.
sub _void {
    # Delete the BTC command.
    cmd_del('BTC') or return;

    # Success.
    return 1;
}

# Help hash.
our %FHELP_BTC = (
    en => "This command will get the current prices of BTC from BTCex. \2Syntax:\2 BTC",
);

# Callback for BTC command.
sub cmd_btc {
    my ($src, undef) = @_;

    # Create an instance of JSON.
    my $json = JSON->new();    
    
    # HTTP request.
    $Auto::http->request(
        url => 'https://btcex.com/ticker.json',
        on_response => sub {
            my $response = shift;
            if ($response->is_success) {
                # If successful, get the content.
                my $data = $json->allow_nonref->relaxed->escape_slash->loose->allow_singlequote->allow_barekey->decode($response->decoded_content);
                privmsg($src->{svr}, $src->{target}, "The current BTC to USD conversion rate is \2\$$data->[0]->{bid}/BTC\2.");
            }
            else {
                # Otherwise, send an error message.
                privmsg($src->{svr}, $src->{target}, 'An error occurred while sending your request to BTCex.');
            }
        },
        on_error => sub {
            my $error = shift;
            privmsg($src->{svr}, $src->{target}, "An error occurred while sending your request to BTCex: $error");
        }
    );

    return 1;
}

# Start initialization.
API::Std::mod_init('BTC', 'Arinity', '1.01', '3.0.0a11');
# build: cpan=JSON,JSON::PP perl=5.010000

__END__

=head1 NAME

BTC - Interface to BTCex

=head1 VERSION

 1.01

=head1 SYNOPSIS

 <starcoder> !btc
 <blue> The current BTC to USD conversion rate is $5.3000/BTC.

=head1 DESCRIPTION

This module creates the BTC command for retrieving the current BTC
rate from BTCex and returning it.

=head1 DEPENDENCIES

This module depends on the following CPAN modules:

=over

=item L<JSON>

This is used to parse the data returned by the BTCex API.

=back

=head1 AUTHOR

This module was written by Matthew Barksdale.

This module is maintained by Arinity Development Group.

=head1 LICENSE AND COPYRIGHT

This module is Copyright 2010-2012 Arinity Development Group.

Released under the same licensing terms as Auto itself.

=cut

# vim: set ai et sw=4 ts=4:
