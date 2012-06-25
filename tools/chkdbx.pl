#!/usr/bin/perl

# $Id: $
use strict;
use warnings;

my $infile = $ARGV[0] ||= "sp.txt";
-r $infile || die "No input file.\n";
open IN, $infile or die "Couldn't open input: ";
my $result;
{local $/; $result = <IN> }
my @tests = split /(?=\n======*\n)/, $result;
while ($tests[0] =~ /connecting........DONE/) { shift @tests; }
foreach (@tests) {
	print if ($_ !~ /get results time/)
}

#fin
exit 0;
