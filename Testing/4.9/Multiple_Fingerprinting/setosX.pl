#!/usr/bin/perl 
 
use SF::SFDataCorrelator::HostInput; 
 
# Set the Source Type 
my $source_type = $SF::SFDataCorrelator::HostInput::SOURCE_TYPE_APP; 
 
# Obtain an Application ID 
my $source_id = SF::SFDataCorrelator::HostInput::GetSourceAppIDByName("FineGrain"); 
 
my $retval; 
 
# Set the operating system for Drill Press
if ($retval = SF::SFDataCorrelator::HostInput::SetOS(
	$source_type, $source_id, "10.4.12.75", [],
	{
		vendor_str => 'Apple, Inc',
		product_str => 'Mac OS X',
		version_str => '10.3.9',
		vendor_id => "174",
		product_id => "325",
		major => "10",
		minor => "3",
	}))
	{
		warn "SetOS failed with error $retval";
		exit;
	}	