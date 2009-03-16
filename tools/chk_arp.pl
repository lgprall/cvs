#!/usr/bin/perl

# $Id$

use strict;
use warnings;

use Getopt::Long;

( my $Cmd  = $0 )   =~ s@^.*/@@;
( my $BCmd = $Cmd ) =~ s/.pl//;
my $Usage = <<USAGE ;

Usage:
$Cmd [--rna] input_file_1 input_file_2 [ output_file ]

-r|--rna Check that all arp traffic appears in instances.
Default is to check that no arp traffic appears in more than
	one instance.

If no output file is specified, the detailed output will be written to
	$BCmd<PID>.

USAGE

my $RNA;
die $Usage unless GetOptions( "rna" => \$RNA, );

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

print "\nChecking for problems....\n";

my ( $s1, $s2 );
$s1 = $s2 = 0;
my ( %con1, %con2 );
foreach (@con1) {
    next unless ( $_ =~ /tell/ or $RNA );
    next unless $_ =~ /.*(\s+\S+\s+(tell|is-at)\s+\S+)/;
    $con1{$1}++;
    $s1++;
}
foreach (@con2) {
    next unless ( $_ =~ /tell/ or $RNA );
    next unless $_ =~ /.*(\s+\S+\s+(tell|is-at)\s+\S+)/;
    $con2{$1}++;
    $s2++;
}

print "Checking ", scalar keys %con1,
  " distinct ARPs of $f1con lines in $file1\n";
print "Checking ", scalar keys %con2,
  " distinct ARPs of $f2con lines in $file2\n";
if ($RNA) {
    print "We already know that there is a problem.\n" unless $s1 == $s2;
}

open OUT, ">$outfile";

my $fails;

my %err;
if ($RNA) {
    foreach ( sort keys %con1 ) {
        if ( exists $con2{$_} && $con1{$_} != $con2{$_} ) {
            printf OUT "%42s    %15s(%d)    %15s(%d)\n", $_, $file1, $con1{$_},
              $file2, $con2{$_};
            $err{$_}++;
            $fails++;
        }
        elsif ( !exists $con2{$_} ) {
            printf OUT "%42s    %15s(%d)    %15s(%d)\n", $_, $file1, $con1{$_},
              $file2, 0;
            $fails++;
        }
    }
    foreach ( sort keys %con2 ) {
        if ( exists $con1{$_} && $con1{$_} != $con2{$_} ) {
            next if $err{$_};
            printf OUT "%42s    %15s(%d)    %15s(%d)\n", $_, $file1, $con1{$_},
              $file2, $con2{$_};
            $fails++;
        }
        elsif ( !exists $con1{$_} ) {
            printf OUT "%42s    %15s(%d)    %15s(%d)\n", $_, $file1, 0, $file2,
              $con2{$_};
            $fails++;
        }
    }
}
else {
    foreach ( sort keys %con1 ) {
        if ( exists $con2{$_} and not $RNA ) {
            chomp $_;
            print OUT "$_ in both files.\n";
            $fails++;
        }
    }
}

if ($fails) {
    print "There ", $fails > 1 ? "were" : "was", " a total of $fails failure",
      $fails > 1 ? "s" : "", ".  See $outfile for specifics\n";
}
else {
    print "No problems noted.\n";
}
