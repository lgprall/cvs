#!/usr/bin/perl 

# rnaparse.pl - parse the output of Andy's 'reader' command, which is run on rna.bin.* files
# @(#) $Id$
#

use strict;
use warnings;
use Getopt::Long;

my ($quiet, $help);
( my $cmd=$0) =~ s@.*/@@;

GetOptions ("quiet" => \$quiet,
	"help|?" => \$help );

die qq(
$cmd [-q] [input file]
   input file defaults to "output.txt"
   -q suppresses detailed output
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
foreach my $ip ( sort keys %ips ) {
	# If we find more than one unknown OS update, print the IP and all data
	if ( 1 <  scalar grep /cafe/, @{$ips{$ip}} ) {
		print "$ip:\n@{$ips{$ip}}\n\n" unless $quiet;
		$bad{$ip}++;
	}
	
}


print "Scanned ";
print scalar keys %ips;
print " IP addresses.\n";
print "Found ";
print scalar keys %bad;
print " hosts with multiple unknown OS updates.\n";

