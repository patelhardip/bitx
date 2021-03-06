#!/usr/bin/perl
use strict;
use warnings;

#This script is used to modify sequence identifiers in GTF files provided by NCBI RefSeq to chromosome names. This is not tested on all species. Use with caution.

open (F, "<$ARGV[0]") or die $!; #assembly report file ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/747/795/GCF_900747795.1_fErpCal1.1

my %chrnames = ();
while (<F>) {
	chomp $_;
	next if (substr($_,0,1) eq "#");
	my @a = split ("\t", $_);
	$chrnames{$a[6]} = "chr$a[2]" if ($a[1]) eq "assembled-molecule";
	$chrnames{$a[6]} = "chr$a[2]"."_$a[6]"."_random" if ($a[1]) eq "unlocalized-scaffold";
	$chrnames{$a[6]} = "chrUn_$a[6]" if ($a[1]) eq "unplaced-scaffold";
}
close F;

open (G, "gunzip -c $ARGV[1] |") or die $!; #GTF file ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/747/795/GCF_900747795.1_fErpCal1.1/GCF_900747795.1_fErpCal1.1_genomic.gtf.gz
while (<G>) {
	if (substr($_,0,1) eq "#") {
		print $_;
		next;
	}
	else{
		my @a = split ("\t", $_);
		$a[0] = $chrnames{$a[0]};
		print join ("\t", @a);
	}
}

close G;
exit;
