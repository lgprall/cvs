#!/usr/bin/perl 

# rnaparse.pl - parse the output of Andy's 'reader' command, which is run on rna.bin.* files
# @(#) $Id: rnaparse.pl,v 1.1.1.1 2006/09/27 20:45:36 larry Exp $
#

use strict;
use warnings;
use Getopt::Long;

my ($quiet, $iponly, $help);
( my $cmd=$0) =~ s@.*/@@;

GetOptions ("quiet" => \$quiet,
	"iponly" => \$iponly,
	"help|?" => \$help );

die qq(
USAGE: $cmd [-quiet] [-iponly] [input file]
   Takes the output of the 'reader' command and checks it for multiple unknown OS updates
   on the same host.
   
   input file defaults to "output.txt"
   -q, -quiet suppresses detailed output
   -i, -iponly prints only the problem IP addresses
) if $help;

my $file = shift || "output.txt";
open IN, "<$file" or die "Couldn't open input file: $!";

my $events;
{ local $/; $events = <IN> }

# Add a couple of line feeds to the top of the file to make the split easier to handle
$events =~ s/^/\n\n/;

# Split the file into an array with one entry per element
my @events = split /\n\n(?:Host IP|MAC) Address: (\S+)/, $events;

# Get rid of the null event which we added at the beginning
shift @events;

my %ips;
while ( @events ) {
	# This is not very robust.  It assumes that we have a clean file
	my $ip = shift @events;
	my $msg = shift @events;
	# Make a hash keyed to the IP addrs
	if ( $ip =~ /\d+\.\d+\.\d+\.\d+/ ) {
		push @{$ips{$ip}}, $msg;
	}
}


my %bad;
foreach my $ip ( sort ipsort keys %ips ) {
	# If we find more than one unknown OS update, print the IP and all data
	if ( 1 <  scalar grep /cafe/, @{$ips{$ip}} ) {
		$bad{$ip}++;
	        if ( $iponly ) {
			print( "$ip\n"), next;
		} elsif ( not $quiet ) {
			print "$ip:@{$ips{$ip}}\n\n";
		}
	}
	
}


print "Scanned ";
print scalar keys %ips;
print " IP addresses.\n";
print "Found ";
print scalar keys %bad;
print " hosts with multiple unknown OS updates.\n";

sub ipsort {
    my ( @a, @b);
    @a = split /\./, $a;
    @b = split /\./, $b;
    for ( my $i = 0; $i < 4; $i++ ) {
        return $a[$i] <=> $b[$i] if $a[$i] <=> $b[$i];
    }
}
