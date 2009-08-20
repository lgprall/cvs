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
		vendor_str => 'Apple',
		product_str => 'Mac OS',
		version_str => '9.2.2',
		vendor_id => "174",
		product_id => "10002084",
		major => "9",
		minor => "2",
	}))
	{
		warn "SetOS failed with error $retval";
		exit;
	}	