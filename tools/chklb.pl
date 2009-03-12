#!/usr/bin/perl

# $Id

use strict;
use warnings;

use Getopt::Long;

(my $Cmd = $0 ) =~ s@^.*/@@;
my $Usage = <<USAGE ;

Usage:
$Cmd [--proto tcp|UdP|<prt> ...] [--exclude TCp|udP|<prt> ...] <input_file_1>
	<input_file_2> [ output_file ]

$Cmd [-p tcp|UdP|<prt> ...] [-x TCp|udP|<prt> ...] <input_file_1> <input_file_2>
	[ output_file ]

You can provide multiple prototypes to use or exclude.
You cannot use both proto and exclude in the same command.

If no output file is specified, the detailed output will be written to
	$Cmd<PID>.

USAGE

my (@Proto, @Xclude);
die $Usage unless GetOptions (
	"proto=s"	=> \@Proto,
	"x|exclude=s"	=> \@Xclude,
);

die $Usage if @Proto and @Xclude;

my (%Proto, %Xclude);
foreach (@Proto) {
	$Proto{uc($_)}++;
}
foreach (@Xclude) {
	$Xclude{uc($_)}++;
}

my ($file1, $file2, $outfile) = @ARGV;
die $Usage unless $file1 and $file2;

$outfile ||= "chkconv$$";

if ( ! -r $file1 or ! -r $file2 ) {
	print "\nNeed readable files for args\n";
        die $Usage;
}

open IN1, "<$file1" or die "Couldn't open $file1\n";
open IN2, "<$file2" or die "Couldn't open $file2\n";

my ($con1, $con2);
{ local $/; $con1 = <IN1>; $con2 = <IN2>; }
my @con1 = split /\n\n/, $con1;
print scalar @con1, " connections in $file1\n";

my @con2 = split /\n\n/, $con2;
print scalar @con2, " connections in $file2\n";

print "\nChecking for strays....\n";

my (%con1, %con2);
foreach (@con1) {
	next unless $_ =~ /((\d{1,3}\.){3}(\d{1,3})(:\d+)? -> \S+)\s+(\S+)/;
        next if @Proto and not defined $Proto{$5};
	next if defined $Xclude{$5};
	$con1{$1}{COUNT}++;
	$con1{$1}{TYPE} = $5; 
        
}

foreach (@con2) {
	next unless $_ =~ /((\d{1,3}\.){3}(\d{1,3})(:\d+)? -> \S+)\s+(\S+)/;
	$con2{$1}{COUNT}++;
	$con2{$1}{TYPE} = $5; 
}

my ($srcIP, $srcPort, $NULL, $destIP, $destPort, $proto, $count1, $count2);
open OUT, ">$outfile";
format OUT =
@<<<<<<<<<<<<<< @<<<<   @<<<<<<<<<<<<<< @<<<<  @<<<  @####  @####
$srcIP, $srcPort, $destIP, $destPort, $proto, $count1, $count2
.

format OUT_TOP =
   Source IP    Port       Dest IP      Port  Proto  Inst1  Inst2
=============== =====   =============== ===== =====  =====  =====
.

my $fails;
foreach ( sort keys %con1 ) {
        if ( defined $con2{$_} && $con1{$_}{TYPE} eq $con2{$_}{TYPE} ) {
        ($srcIP, $srcPort, $NULL, $destIP, $destPort) =
		split /[ :]/, $_;
        if ($srcPort eq "->") {
		$srcPort = 0;
                $destIP = $NULL;
                $destPort = 0;
	}
	$proto = $con1{$_}{TYPE};
        ($count1, $count2) = ($con1{$_}{COUNT}, $con2{$_}{COUNT});
#	print OUT "FAILURE $_ ($con1{$_}{TYPE}) : $con1{$_}{COUNT} / $con2{$_}{COUNT}\n";
	write OUT;
	$fails++;
	}
}
close OUT;

if ( $fails ) {
	print "There were a total of $fails failures.  See $outfile for specifics\n";
}
else {
	print "No common conversations in both instances\n";
}
