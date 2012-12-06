#!/usr/bin/env/perl
# evalserver.pl - Evaluation Server
# Copyright (C) 2010-2012 AlphaChat Development Group, et al.
# This program is free software; rights to this code are stated in doc/LICENSE.

use strict;
use warnings;
use App::EvalServer;

#####################################
#    BEGIN CONFIGURATION SECTION    #
#    evalHost - Host to bind to     #
#    evalPort - Port to bind to     #
#    user - user to evaluate code   #
#           as                      #
#    timeout - eval timeout (secs)  #
#    daemonize - Should we fork?    #
#    limit - resource limit in MB   #
#####################################

my $evalHost = '127.0.0.1';
my $evalPort = 14400;
my $user = 'nobody';
my $timeout = 10;
my $limit = 50;
my $daemonize = 1;


###################################
#    END CONFIGURATION SECTION    #
#    DO NOT EDIT BELOW THIS LINE  #
#    UNLESS YOU KNOW WHAT         #
#    YOU'RE DOING                 #
####################################

my $evalServer = App::EvalServer->new(
    host      => $evalHost,
    port      => $evalPort,
    user      => $user,
    timeout   => $timeout,
    limit     => $limit,
    daemonize => $daemonize
);

$evalServer->run();
# Since ^ isn't doing it, start POE::Kernel
POE::Kernel->run();
