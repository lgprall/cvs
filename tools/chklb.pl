#!/usr/bin/perl

# $Id: chklb.pl,v 1.3 2009/03/14 02:50:19 larry Exp $

use strict;
use warnings;

use Getopt::Long;

( my $Cmd  = $0 )   =~ s@^.*/@@;
( my $BCmd = $Cmd ) =~ s/.pl//;
my $Usage = <<USAGE ;

Usage:
$Cmd [--proto|--exclude tcp|UdP|<prt> ...] [--select regex] [--discard regex]
	[--output raw|full] input_file_1 input_file_2 [ output_file ]

-p|--proto    Check this protocol; may use multiple times
-x|--exclude  Exclude this procol; may use multiple times
You cannot use both proto and exclude in the same command.
-s|--selext   Examine only entries with this regex
-d|--discard  Ignore all entries with this regex

--output raw  Output the "IP:port -> IP:port Proto" string as seen.
--output full Output the entire snort entries
The default output is formatted.

If no output file is specified, the detailed output will be written to
	$BCmd<PID>.

USAGE

my ( @Proto, @Xclude, $Select, $Discard, $Output );
die $Usage
  unless GetOptions(
    "proto=s"     => \@Proto,
    "x|exclude=s" => \@Xclude,
    "select=s"    => \$Select,
    "discard=s"   => \$Discard,
    "output=s"    => \$Output,
  );

die $Usage if $Output && $Output ne "raw" && $Output ne "full";

die $Usage if @Proto and @Xclude;

my ( %Proto, %Xclude );
foreach (@Proto) {
    $Proto{ uc($_) }++;
}
foreach (@Xclude) {
    $Xclude{ uc($_) }++;
}

my ( $file1, $file2, $outfile ) = @ARGV;
die $Usage unless $file1 and $file2;

$outfile ||= "$BCmd$$";

if ( !-r $file1 or !-r $file2 ) {
    print "\nNeed readable files for args\n";
    die $Usage;
}

open IN1, "<$file1" or die "Couldn't open $file1\n";
open IN2, "<$file2" or die "Couldn't open $file2\n";

print "Loading...\n";

my ( $con1, $con2 );
{ local $/; $con1 = <IN1>; $con2 = <IN2>; }

close IN1;
close IN2;

my @con1 = split /\n\n/, $con1;
my $f1con = scalar @con1;

my @con2 = split /\n\n/, $con2;
my $f2con = scalar @con2;

print "\nChecking for strays....\n";

my ( $s1, $s2 );
$s1 = $s2 = 0;
my ( %con1, %con2 );
foreach (@con1) {
    next if $Select && $_ !~ /$Select/;
    next if $Discard && $_ =~ /$Discard/;
    next
      unless $_ =~
/(((\d{1,3}\.){3}(\d{1,3})|([[:xdigit:]]{4}:){7}([[:xdigit:]]{4}))(:\d+)? -> \S+)\s+(\S+)/;
    next if @Proto and not defined $Proto{$8};
    next if defined $Xclude{$8};
    $con1{$1}{FULL} = $_;
    $con1{$1}{COUNT}++;
    $con1{$1}{TYPE} = $8;
    $s1++;
}

foreach (@con2) {
    next if $Select  && $_ =~ /$Select/;
    next if $Discard && $_ =~ /$Discard/;
    next
      unless $_ =~
/(((\d{1,3}\.){3}(\d{1,3})|([[:xdigit:]]{4}:){7}([[:xdigit:]]{4}))(:\d+)? -> \S+)\s+(\S+)/;
    next if @Proto and not defined $Proto{$8};
    next if defined $Xclude{$8};
    $con2{$1}{FULL} = $_;
    $con2{$1}{COUNT}++;
    $con2{$1}{TYPE} = $8;
    $s2++;
}

print "Checking $s1 connections of $f1con in $file1\n";
print "Checking $s2 connections of $f2con in $file2\n";

my ( $srcIP, $srcPort, $NULL, $dstIP, $dstPort, $proto, $count1, $count2 );
open OUT, ">$outfile";
format OUT =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<  @<<<  @####  @####
$srcIP, $srcPort, $dstIP, $dstPort, $proto, $count1, $count2
.

format OUT_TOP =
              Source IP                 Port                       Dest IP              Port  Proto  Inst1  Inst2
======================================= =====   ======================================= ===== =====  =====  =====
.

my $fails;
foreach ( sort keys %con1 ) {
    if ( defined $con2{$_} && $con1{$_}{TYPE} eq $con2{$_}{TYPE} ) {
        my ( $src, $dst );
        ( $src, $NULL, $dst ) = split /\s+/, $_;
        unless ( $src =~ /(.*):(\d+)/ ) {
            $srcIP   = $src;
            $srcPort = 0;
        }
        else {
            ( $srcIP, $srcPort ) = ( $1, $2 );
        }

        #if ( !$srcPort || $srcPort eq "->" ) {
        #	$srcPort = 0;
        #	$dstIP = $NULL;
        #	$dstPort = 0;
        #}
        unless ( $dst =~ /(.*):(\d+)/ ) {
            $dstIP   = $dst;
            $dstPort = 0;
        }
        else {
            ( $dstIP, $dstPort ) = ( $1, $2 );
        }
        $proto = $con1{$_}{TYPE};
        ( $count1, $count2 ) = ( $con1{$_}{COUNT}, $con2{$_}{COUNT} );
        if ( $Output && $Output eq "raw" ) {
            print OUT
              "$_ ($con1{$_}{TYPE}) : $con1{$_}{COUNT} / $con2{$_}{COUNT}\n";
        }
        elsif ( $Output && $Output eq "full" ) {
            print OUT
"$con1{$_}{FULL}      ====> $con1{$_}{COUNT}\n$con2{$_}{FULL}      ====> $con2{$_}{COUNT}\n\n\n";
        }
        else {
            write OUT;
        }
        $fails++;
    }
}
close OUT;

if ($fails) {
    print "There ", $fails > 1 ? "were" : "was", " a total of $fails failure",
      $fails > 1 ? "s" : "", ".  See $outfile for specifics\n";
}
else {
    print "No common conversations in both instances\n";
}
