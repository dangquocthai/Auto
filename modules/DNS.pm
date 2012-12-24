# Module: DNS. See below for documentation.
# Copyright (C) 2010-2013 The Auto Project, et al.
# This program is free software; rights to this code are stated in doc/LICENSE.
package M::DNS;
use strict;
use warnings;
use API::Std qw(cmd_add cmd_del trans);
use API::IRC qw(privmsg notice);
use IO::Async::Resolver::DNS;

# Initialization subroutine.
sub _init {
    # Create the DNS command.
    cmd_add('DNS', 0, 0, \%M::DNS::HELP_DNS, \&M::DNS::cmd_dns) or return;

    # Success.
    return 1;
}

# Void subroutine.
sub _void {
    # Delete the DNS command.
    cmd_del('DNS') or return;

    # Success.
    return 1;
}

# Help hash.
our %HELP_DNS = (
    en => "This command will do a DNS lookup. \2Syntax:\2 DNS <host>",
);

# Callback for DNS command.
sub cmd_dns {
    my ($src, @argv) = @_;
     
    if (!defined $argv[0]) {
        notice($src->{svr}, $src->{nick}, trans('Not enough parameters').q{.});
        return;
    }
    $src->{target} = (exists $src->{chan} ? $src->{chan} : $src->{nick});
    $Auto::loop->resolver->res_search(
        dname       => $argv[0],
        type        => 'A',
        on_resolved => sub {
            my $pkt = shift;
            my @results;
            foreach my $a ($pkt->answer) {
                next unless $a->type eq 'A';
                push(@results, $a->address);
            }
            if (@results) {
                my $result = join ' ', @results;
                my $count = scalar @results;
                privmsg($src->{svr}, $src->{target}, "\2$argv[0] ($count)\2: $result");
            }
            else {
                privmsg($src->{svr}, $src->{target}, "No results found for \2$argv[0]\2.");
                return;
            }
            return 1;
        },
        on_error => sub {
            privmsg($src->{svr}, $src->{target}, "DNS Resolution failed: $_[-1]");
            return;
        }
    );
}

# Start initialization.
API::Std::mod_init('DNS', 'Auto Project', '1.02', '3.0.0a11');
# build: cpan=IO::Async::Resolver::DNS perl=5.010000

__END__

=head1 NAME

DNS - A simple DNS resolver.

=head1 VERSION

 1.02

=head1 SYNOPSIS

 <matthew> !dns ethrik.net
 <blue> ethrik.net (1): 217.114.62.164

=head1 DESCRIPTION

This module creates the DNS command for preforming DNS
lookups.

=head1 DEPENDENCIES

This module depends on the following CPAN modules:

=over

=item L<Net::Async::Resolver::DNS>

This is the DNS agent this module uses.

=back

=head1 AUTHOR

This module was written by Matthew Barksdale.

This module is maintained by The Auto Project.

=head1 LICENSE AND COPYRIGHT

This module is Copyright 2010-2013 The Auto Project.

Released under the same licensing terms as Auto itself.

=cut

# vim: set ai et sw=4 ts=4:
