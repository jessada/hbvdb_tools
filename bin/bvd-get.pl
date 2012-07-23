#!/usr/bin/env perl
#
# Author: jessada@kth.se
#

use Carp;
use strict;
use Cwd 'abs_path';
use File::Basename;

#use lib dirname(abs_path($0))."/lib";
use Bvdb;
use Vcf;

use constant AVDB_FORMAT => 'AVDB';
use constant VCF_FORMAT  => 'VCF';

my $opts = parse_params();
bvd_get($opts);

exit;

#--------------------------------

sub error
{
    my (@msg) = @_;
    if ( scalar @msg ) { croak join('',@msg); }
    die
        "About: Export variant frequencies from Background Variation Database, default in ANNOVAR generic format.\n",
        "Usage:",
        "   bvd-get.pl [OPTIONS]\n",
        "\n",
        "   Optional arguments:\n",
        "      -h, -?, --help                  This help message.\n",
        "\n",
        "      Arguments to control database content\n",
        "         --buildver <string>             genome build version (default: hg19)\n",
        "         -d, --database <db_path>        Specific target database. Default is 'DB'\n",
        "         -T, --tags <string>             Tags to exclude, comma separated.\n",
        "\n",
        "      Arguments to control output format\n",
        "         --avdb                          Output in ANNOVAR generic format (default).\n",
        "         --vcf                           Output in VCF format.\n",
        "\n",
}


sub parse_params
{
    my $opts = { args=>[$0, @ARGV] };
    while (my $arg=shift(@ARGV))
    {
        if ( $arg eq '--buildver' ) { $$opts{buildver}=shift(@ARGV); next; }
        if ( $arg eq '-T' || $arg eq '--tags' ) { $$opts{tags}=shift(@ARGV); next; }
        if ( $arg eq '-d' || $arg eq '--database' ) { $$opts{database}=shift(@ARGV); next; }
        if ( $arg eq '--avdb' ) { $$opts{output_format}=AVDB_FORMAT; next; }
        if ( $arg eq '--vcf' ) { $$opts{output_format}=VCF_FORMAT; next; }
        if ( $arg eq '-?' || $arg eq '-h' || $arg eq '--help' ) { error(); }
        error("Unknown parameter or non-existent file \"$arg\". Run -? for help.\n");
    }
    $$opts{output_format} = AVDB_FORMAT unless exists($$opts{output_format});
    $$opts{buildver}      =  Bvdb::get_default_buildver() unless defined($$opts{buildver});
    if ( ! Bvdb::valid_buildver($$opts{buildver})) {
        error("ERROR : invalid buildver \"$$opts{buildver}\". Run -? for help.\n");
    }
    return $opts;
}

sub bvd_get
{
    my ($opts) = @_;
	
    validate_tags();

    if ( $$opts{output_format} eq AVDB_FORMAT  ) {
        output_avdb();
    }
    elsif ( $$opts{output_format} eq VCF_FORMAT  ) {
        output_vcf();
    }
    else {
        error("Unknown format. Run -? for help.\n");
    }
}

sub output_avdb
{
    #Connect to DB
    my $bvdb = Bvdb->new(db_dir=>$$opts{database});
    $bvdb->load_header();
    while (my $variant = $bvdb->next_data_hash($$opts{tags})) {
        if ($variant->{fq}) {
            my $len = $variant->{POS}+length($variant->{REF})-1;
            print "$variant->{CHROM} $variant->{POS} $len $variant->{REF} $variant->{ALT} $variant->{fq}\n";
        }
    }
    $bvdb-close();
}

sub output_vcf
{
    #Connect to DB
    my $bvdb = Bvdb->new(db_dir=>$$opts{database});

    #Create VCF output
    my $vcf_out = Vcf->new();

    #Output VCF header
    $bvdb->load_header();

    my @cols;
    $vcf_out->add_columns(@cols);

    #$vcf_out->add_header_line({key=>'INFO',ID=>'AC',Number=>-1,Type=>'Integer',Description=>'Allele count in genotypes'});
    #$vcf_out->add_header_line({key=>'INFO',ID=>'AN',Number=>1,Type=>'Integer',Description=>'Total number of alleles in called genotypes'});
    print $vcf_out->format_header();

    while (my $variant = $bvdb->next_data_hash($$opts{tags})) {
        if ($variant->{fq}) {
            my %out;
            my %info;

            my $len = $variant->{POS}+length($variant->{REF})-1;
            $out{CHROM} = $variant->{CHROM};
            $out{POS}   = $variant->{POS};
            $out{ID}    = '.';
            $out{REF}   = $variant->{REF};
            $out{QUAL}  = '.';
            #$out{ALT}   = [];
            push @{$out{ALT}}, $variant->{ALT};
            # push @{$out{ALT}}, 'Z';
            $info{BVDMAF} = $variant->{fq};
            $out{INFO} = { %info }; 
            #$out{FORMAT} = [];
            print $vcf_out->format_line(\%out);
            # print $variant->{record_ref}, "\n";
            # print "$variant->{CHROM} $variant->{POS} $len $variant->{REF} $variant->{ALT} $variant->{fq}\n";
        }
    }
    $bvdb-close();
}

sub validate_tags
{
	#Assuming that tags value is stored in $$opts{tags}
	my @array = split(/,/, $$opts{tags});
	my %seen = ();
	my @unique = grep { ! $seen{ $_ }++ } @array;
	$$opts{tags} = join(',', sort @unique);
}
