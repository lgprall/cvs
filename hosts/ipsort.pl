#!/usr/bin/perl

my $fn = shift || "iplist";;
open IN, "<$fn";
my @hosts = <IN>;

for ( sort ipsort @hosts ) { print; }

sub ipsort;


sub ipsort {
	my ( @a, @b);
	@a = split /\./, $a;
	@b = split /\./, $b;
	for ( my $i = 0; $i < 4; $i++ ) {
		return $a[$i] <=> $b[$i] if $a[$i] <=> $b[$i];
	}
}	
