#!perl -T 

#***************************************************************************************************************************
#
# Purpose  : To check the functinality of bvd-add.pl in user environment
# Note     : The 'database' directory for this testing will have prefix '__TEST_bvd_add' which is located in <hbvdb-toos/bin> directory
#
#***************************************************************************************************************************

use 5.006;
use strict;
use warnings;
use Test::More;

use Cwd 'abs_path';
use File::Basename;
use File::Path qw(mkpath);
use File::Copy;
use Error qw(:try);

use Bvdb_test qw(clear_db untaint get_absolute_db_dir compare_file compare_file_content compare_DB_header DB_header_exist);

my @test_args;
my $absolute_bvd_add_path = untaint(dirname(abs_path($0))."/../bin/bvd-add.pl"); 
my $absolute_perl_path    = untaint($^X);
my $absolute_script_dir   = untaint(dirname(abs_path($0))); 

my $absolute_test_DB_dir;
my $absolute_test_data_dir;
my $source_bvdb;
my $source_chksum;
my $target_bvdb;
my $target_chksum;

=head1 NAME

F<01-production-unit-test-bvd-add.t>

=head1 PURPOSE

To check the functinality of bvd-add.pl in user environment

=head1 NOTE1

The 'database' directory for this testing will have prefix '__TEST_bvd_add' which is located in <hbvdb-toos/bin> directory

=head1 NOTE2

The naming convention of cases and related files can be splitted into 5 levels (This naming convention is not related to version number)

=over 4

=item * The first level indicate the major change or major features

=item * The second and third level are designed to facilatate the test. They will be used to categorize the case into group and sub-group

=item * The forth level is the running number of cases in one sub group
  
=item * The last level is designed so that the tests with the same description can be run several times with diffrent input (retest) 

=back

=head1 CASES group bvd-add.1.x.x.x - The first release

***************************************************************************************************************************

                                              F  I  R  S  T      R  E  L  E  A  S  E   

***************************************************************************************************************************

=head2 cases subgroup bvd-add.1.1.3.x

The purpose of the cases in this group is to check if bvd-add can build additional database from scratch (option -d/--database)

    case bvd-add.1.1.3.1 :
	bvd-add can build additional database from scratch using random variant from 200danes (without options -T)

=cut

sub case_bvd_add_1_1_3_1_1 {

    subtest "case bvd-add.1.1.3.1.1 - bvd-add can build additional database (with option -d) from scratch using random variant from 200danes (without options -T)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.3.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/1.1.3.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.3.1.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.3.2 :
	bvd-add can build additional database from scratch using random variant from 200danes (with options -T)

=cut

sub case_bvd_add_1_1_3_2_1 {

    subtest "case bvd-add.1.1.3.2.1 - bvd-add can build additional database (with option --database) from scratch using random variant from 200danes (with options -T)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.3.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/1.1.3.2.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.3.2.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.1.1.4.x

The purpose of the cases in this group is to check if bvd-add can handle the insertion of variant frequencies into existing additional database

    case bvd-add.1.1.4.1 :
	bvd-add can handle the insertion of variant frequencies without tags into the additional database without tags

=cut

sub case_bvd_add_1_1_4_1_1 {

    subtest "case bvd-add.1.1.4.1.1 - bvd-add can handle the insertion of variant frequencies without tags into the additional database that doesn't have tags" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.4.1.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.4.1.1");

	$source_bvdb   = "$absolute_test_data_dir/1.1.4.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.4.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.4.1.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.4.2 :
	bvd-add can handle the insertion of variant frequencies with tags into the additional database without tags

=cut

sub case_bvd_add_1_1_4_2_1 {

    subtest "case bvd-add.1.1.4.2.1 - bvd-add can handle the insertion of variant frequencies with tags into the additional database that doesn't have tags" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.4.2.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.4.2.1");

	$source_bvdb   = "$absolute_test_data_dir/1.1.4.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.4.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.4.2.1_1.vcf";
	push @test_args, "--tags";
	push @test_args, "lung_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.4.3 :
	bvd-add can handle the insertion of variant frequencies without tags into the additional database with tags

=cut

sub case_bvd_add_1_1_4_3_1 {

    subtest "case bvd-add.1.1.4.3.1 - bvd-add can handle the insertion of variant frequencies without tags into the additional database that has tags" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.4.3.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.4.3.1");

	$source_bvdb   = "$absolute_test_data_dir/1.1.4.3.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.4.3.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.4.3.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.4.4 :
	bvd-add can handle the insertion of variant frequencies with tags into the additional database with tags

=cut

sub case_bvd_add_1_1_4_4_1 {

    subtest "case bvd-add.1.1.4.4.1 - bvd-add can handle the insertion of variant frequencies with tags into the additional database that has tags" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.4.4.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.4.4.1");

	$source_bvdb   = "$absolute_test_data_dir/1.1.4.4.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.4.4.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.4.4.1_1.vcf";
	push @test_args, "--tags";
	push @test_args, "lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.1.1.5.x

The purpose of the cases in this group is to check if all the value that will be used later in frequecy calculation in bvd-get is correctly calculated in bvd-add

    case bvd-add.1.1.5.1 :
	- Check if bvd-add calculate everything correctly by using all possible type of corner cases that can be imagined.
	- This will do both white-box and black-box test.
	- The data here are from both real data from 200danes and synthetic data which is also modified from real data.
	- The cases here are roughly as following
	    case#   CHROM   POS		description								    comment
	    1	    1,2	    any		To test if bvd-add can work fine with a few random real data		    5 variant from each CHROM,
														    2 CHROM from each individual,
														    5 individuals
	    2	    3	    124482502	To test long length REF 
	    3	    3	    3137165	To test long length ALT	
	    4	    3	    154890526	To test long length heterozygote bialleles	
	    5	    3	    100949842   To test heterozygote bialleles, one of GT is REF	
	    6	    10	    1042023	To test trialleles in one individual file   
	    7	    3	    112253207   To test trialleles in multicolumn file  
	    8	    11	    5536537	To test homozygote alleles, REF both	
	    9	    11	    5013431	To test GT out of range	<REMOVE> since the excpetion is raised in vcf-merge
	    10	    11	    5142029	To test invalid order in GT 
	    11	    1	    811512	To test bvd-add if the minimum key(number) is in database		    keys in cases 11-18 are the keys that  
	    12	    1	    11111111    To test bvd-add if the minimum key(string) is in database		    used in sorting and comparison during
	    13	    22	    45972610    To test bvd-add if the maximum key(number) is in database		    'frequency' calculation in bvd-add.
	    14	    X	    20086	To test bvd-add if the maximum key(string) is in database		    With these 8 cases, it's likely to be
	    15	    1	    811510	To test bvd-add if the minimum key(number) is in vcf file		    able to gaurantee that all the variants
	    16	    1	    11111110    To test bvd-add if the minimum key(string) is in vcf file		    records are included, sorted and calculated
	    17	    22	    45972611    To test bvd-add if the maximum key(number) is in vcf file		    correctly.
	    18	    X	    200861	To test bvd-add if the maximum key(string) is in vcf file   

=cut

sub case_bvd_add_1_1_5_1_1 {

    subtest "case bvd-add.1.1.5.1.1 - bvd-add can handle several corner cases that can happen in user environment (see perldoc of this test for more detail)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.5.1.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.5.1.1");

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_1.vcf";
	push @test_args, "--tags";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_2.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_3.vcf";
	push @test_args, "--tags";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_4.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--tags";
	push @test_args, "lung_cancer,colon_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_5.vcf";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.5.1.1_6.vcf";
	push @test_args, "--tags";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.5.2 :
	Check if bvd-add can handle different combination of tags correctly

=cut

sub case_bvd_add_1_1_5_2_1 {

    subtest "case bvd-add.1.1.5.2.1 - bvd-add can handle different combination of tags correctly" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.5.2.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.5.2.1");

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_1.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_2.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_3.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_4.vcf";
	push @test_args, "--tags";
	push @test_args, "lung_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_5.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_6.vcf";
	push @test_args, "--tags";
	push @test_args, "prostate_cancer";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_7.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.5.2.1_8.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.1.1.6.x

The purpose of the cases in this group is to check if bvd-add can handle multi-column vcf file

    case bvd-add.1.1.6.1 :
	bvd-add can handle a multi-column vcf file which combine all the vcf files in the case 1.1.5.1.1 all together.

=cut

sub case_bvd_add_1_1_6_1_1 {

    subtest "case bvd-add.1.1.6.1.1 - bvd-add can handle a multi-column vcf file which combine all the vcf files in the case 1.1.5.1.1 all together" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.6.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/1.1.6.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.6.1.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.1.1.7.x

The purpose of the cases in this group is to see if backup option (-s/--savediskspace) are working correctly

    case bvd-add.1.1.7.2 :
	Without option -s/--savediskspace bvd-add must do the backup for both database content and chksum correctly in additional database.

=cut

sub case_bvd_add_1_1_7_2_1 {

    subtest "case bvd-add.1.1.7.2.1 - Without option -s/--savediskspace bvd-add correctly do the backup for both database content and chksum in additional database" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.7.2.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.7.2.1");

	$source_bvdb   = "$absolute_test_data_dir/1.1.7.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.7.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.7.2.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);

	my $DB_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb2* | /usr/bin/sort -r | /usr/bin/head -1`;
	my $chksum_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb_chksum2* | /usr/bin/sort -r | /usr/bin/head -1`;
        chomp($DB_backup_file);
        chomp($chksum_backup_file);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file(got => "$DB_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_backup", test_description => "database backup is correctly done");
	compare_file(got => "$chksum_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_chksum_backup", test_description => "chksum backup is correctly done");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.7.3 :
	With option -s, bvd-add must not do any backup

=cut

sub case_bvd_add_1_1_7_3_1 {

    subtest "case bvd-add.1.1.7.3.1 - With option -s, No backup was done by bvd-add" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.7.3.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.7.3.1");

	$source_bvdb             = "$absolute_test_data_dir/1.1.7.3.1_bvdb";
	$source_chksum           = "$absolute_test_data_dir/1.1.7.3.1_bvdb_chksum"; 
	my $source_bvdb_backup   = "$absolute_test_data_dir/1.1.7.3.1_bvdb_backup";
	my $source_chksum_backup = "$absolute_test_data_dir/1.1.7.3.1_bvdb_chksum_backup"; 

	$target_bvdb             = "$absolute_test_DB_dir/bvdb";
	$target_chksum           = "$absolute_test_DB_dir/bvdb_chksum";
	my $target_bvdb_backup   = "$absolute_test_DB_dir/bvdb20120224145439";
	my $target_chksum_backup = "$absolute_test_DB_dir/bvdb_chksum20120224145439";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	copy($source_bvdb_backup, $target_bvdb_backup) or die "Cannot copy $source_bvdb_backup to $target_bvdb_backup\n";
	copy($source_chksum_backup, $target_chksum_backup) or die "Cannot copy $source_chksum_backup to $target_chksum_backup\n";
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-s";
	push @test_args, "$absolute_test_data_dir/1.1.7.3.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);

	my $DB_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb2* | /usr/bin/sort -r | /usr/bin/head -1`;
	my $chksum_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb_chksum2* | /usr/bin/sort -r | /usr/bin/head -1`;
        chomp($DB_backup_file);
        chomp($chksum_backup_file);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file(got => "$DB_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_backup", test_description => "database backup is correctly done");
	compare_file(got => "$chksum_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_chksum_backup", test_description => "chksum backup is correctly done");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.1.1.7.4 :
	With option --savediskspace, bvd-add must not do any backup

=cut

sub case_bvd_add_1_1_7_4_1 {

    subtest "case bvd-add.1.1.7.4.1 - With option --savediskspace, No backup was done by bvd-add" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.7.4.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/1.1.7.4.1");

	$source_bvdb             = "$absolute_test_data_dir/1.1.7.4.1_bvdb";
	$source_chksum           = "$absolute_test_data_dir/1.1.7.4.1_bvdb_chksum"; 
	my $source_bvdb_backup   = "$absolute_test_data_dir/1.1.7.4.1_bvdb_backup";
	my $source_chksum_backup = "$absolute_test_data_dir/1.1.7.4.1_bvdb_chksum_backup"; 

	$target_bvdb             = "$absolute_test_DB_dir/bvdb";
	$target_chksum           = "$absolute_test_DB_dir/bvdb_chksum";
	my $target_bvdb_backup   = "$absolute_test_DB_dir/bvdb20120224145439";
	my $target_chksum_backup = "$absolute_test_DB_dir/bvdb_chksum20120224145439";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	copy($source_bvdb_backup, $target_bvdb_backup) or die "Cannot copy $source_bvdb_backup to $target_bvdb_backup\n";
	copy($source_chksum_backup, $target_chksum_backup) or die "Cannot copy $source_chksum_backup to $target_chksum_backup\n";
	@test_args = ();
	push @test_args, "--savediskspace";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.7.4.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);

	my $DB_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb2* | /usr/bin/sort -r | /usr/bin/head -1`;
	my $chksum_backup_file = `/bin/ls $absolute_test_DB_dir/bvdb_chksum2* | /usr/bin/sort -r | /usr/bin/head -1`;
        chomp($DB_backup_file);
        chomp($chksum_backup_file);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file(got => "$DB_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_backup", test_description => "database backup is correctly done");
	compare_file(got => "$chksum_backup_file", expected => "$absolute_test_data_dir/expected_bvdb_chksum_backup", test_description => "chksum backup is correctly done");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.1.1.8.x

The purpose of the cases in this group is for special cases or cases that haven't foreseen during development time

    case bvd-add.1.1.8.1 :
	To handle a strange character, '.', found in GT field correctly
	Note. This error was found by Daniel Nilsson.

=cut

sub case_bvd_add_1_1_8_1_1 {

    subtest "case bvd-add.1.1.8.1.1 - bvd-add can handle a strange character, '.', found in GT field correctly" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.1.1.8.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/1.1.8.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.8.1.1_1.vcf";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES group bvd-add.2.x.x.x - Counting new REF

***************************************************************************************************************************

                                          C  O  U  N  T  I  N  G     N  E  W     R  E  F

***************************************************************************************************************************

head2 cases subgroup bvd-add.2.1.1.x

The purpose of the cases in this group is to check if bvd-add can count new REF correctly

    case bvd-add.2.1.1.1 :
	There is a new REF at one postion in the database which already had one REF and the value of the new REF is lesser than the existing one.

=cut

sub case_bvd_add_2_1_1_1_1 {

    subtest "case bvd-add.2.1.1.1.1 - bvd-add can detect a new REF when it appears at a position that already had one REF and the value of the new REF is lesser than the existing one" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.1.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/2.1.1.1.1_1.vcf";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REF is correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.2 :
	There is a new REF at one postion in the database which already had one REF and the value of the new REF is greater than the existing one.

=cut

sub case_bvd_add_2_1_1_2_1 {

    subtest "case bvd-add.2.1.1.2.1 - bvd-add can detect a new REF when it appears at a position that already had one REF and the value of the new REF is greater than the existing one" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.2.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.2.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REF is correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.3 :
	There is a new REF at one postion in the database which already had two REFs and the value of the new REF is lesser than the existing REFs.

=cut

sub case_bvd_add_2_1_1_3_1 {

    subtest "case bvd-add.2.1.1.3.1 - bvd-add can detect a new REF when it appears at a position that already had two REFs and the value of the new REF is lesser than the existing REFs" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.3.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.3.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.3.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.3.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.3.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REF is correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.4 :
	There is a new REF at one postion in the database which already had two REFs and the value of the new REF is between the existing REFs.

=cut

sub case_bvd_add_2_1_1_4_1 {

    subtest "case bvd-add.2.1.1.4.1 - bvd-add can detect a new REF when it appears at a position that already had two REFs and the value of the new REF is between the existing REFs" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.4.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.4.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.4.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.4.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.4.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REF is correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.5 :
	There is a new REF at one postion in the database which already had two REFs and the value of the new REF is greater than the existing REFs.

=cut

sub case_bvd_add_2_1_1_5_1 {

    subtest "case bvd-add.2.1.1.5.1 - bvd-add can detect a new REF when it appears at a position that already had two REFs and the value of the new REF is greater than the existing REFs" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.5.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.5.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.5.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.5.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.5.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REF is correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.6 :
	There are two new REFs at one postion in the database which already had one REF.

=cut

sub case_bvd_add_2_1_1_6_1 {

    subtest "case bvd-add.2.1.1.6.1 - bvd-add can detect two new REFs when they appear in a position that aleady had one REF" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.6.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.6.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.6.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.6.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.6.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REFs are correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.7 :
	VCF file with ten random new REFs.

=cut

sub case_bvd_add_2_1_1_7_1 {

    subtest "case bvd-add.2.1.1.7.1 - bvd-add can detect ten random new REFs in VCF file (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.7.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.7.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.7.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.7.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.7.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REFs are correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_2_1_1_7_2 {

    subtest "case bvd-add.2.1.1.7.2 - bvd-add can detect ten random new REFs in VCF file (2nd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.7.2"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.7.2";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.7.2_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.7.2_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.7.2_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REFs are correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.2.1.1.8 :
	Check if there are new REFs at every single positions.

=cut

sub case_bvd_add_2_1_1_8_1 {

    subtest "case bvd-add.2.1.1.8.1 - bvd-add can detect new REFs when they appear at every single positions" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.2.1.1.8.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/2.1.1.8.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.8.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.8.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/2.1.1.8.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	compare_file(got => "$absolute_test_DB_dir/logfile", expected => "$absolute_test_data_dir/expected_warning", test_description => "the new REFs are correctly counted");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES group bvd-add.3.x.x.x - Reference and contig table

***************************************************************************************************************************

                          R  E  F  E  R  E  N  C  E     A  N  D     C  O  N  T  I  G     T  A  B  L  E

***************************************************************************************************************************

=head2 cases subgroup bvd-add.3.1.1.x

The purpose of the cases in this group is to check if bvd-add can build the reference and contig table in the database from scratch

    case bvd-add.3.1.1.1 :
	Building reference and contig table using a VCF file that has both the reference and contig table	

=cut

sub case_bvd_add_3_1_1_1_1 {

    subtest "case bvd-add.3.1.1.1.1 - bvd-add can build the reference and contig table using a VCF file that has both the reference and contig table" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/3.1.1.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.1.1.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correctly not found");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.1.2 :
	Building reference and contig table using a VCF file that has only the contig table	

=cut

sub case_bvd_add_3_1_1_2_1 {

    subtest "case bvd-add.3.1.1.2.1 - bvd-add can build the contig table but not reference using a VCF file that has only the contig table" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.1.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/3.1.1.2.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.1.2.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.1.3 :
	Building reference and contig table using a VCF file that has only the reference

=cut

sub case_bvd_add_3_1_1_3_1 {

    subtest "case bvd-add.3.1.1.3.1 - bvd-add can build the reference but not contig table using a VCF file that has only the reference" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.1.3.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/3.1.1.3.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.1.3.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correctly not found");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.3.1.2.x

The purpose of the cases in this group is to check if bvd-add can update the database that already had the contig table but not reference (by using the database from bvd-add.3.1.1.2.1)

    case bvd-add.3.1.2.1 :
	Updating the database that already had the contig table but not reference using a VCF file has both the reference and contig table	

=cut

sub case_bvd_add_3_1_2_1_1 {

    subtest "case bvd-add.3.1.2.1.1 - bvd-add can update the database that already had the contig table but not reference using a VCF file has both the reference and contig table" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.2.1.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.2.1.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.2.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.2.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.2.1.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.2.2 :
	Updating the database that already had the contig table but not reference using a VCF file has only the contig table	

=cut

sub case_bvd_add_3_1_2_2_1 {

    subtest "case bvd-add.3.1.2.2.1 - bvd-add can update the database that already had the contig table but not reference using a VCF file has only the contig table" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.2.2.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.2.2.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.2.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.2.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.2.2.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correctly not found");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.2.3 :
	Updating the database that already had the contig table but not reference using a VCF file has only the reference	

=cut

sub case_bvd_add_3_1_2_3_1 {

    subtest "case bvd-add.3.1.2.3.1 - bvd-add can update the database that already had the contig table but not reference using a VCF file has only the reference" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.2.3.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.2.3.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.2.3.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.2.3.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.2.3.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.3.1.3.x

The purpose of the cases in this group is to check if bvd-add can update the contig table correctly (by using the database from bvd-add.3.1.1.1.1)

    case bvd-add.3.1.3.1 :
	Updating the contig table by using an old contig table (the new contig's length is shorter) 	

=cut

sub case_bvd_add_3_1_3_1_1 {

    subtest "case bvd-add.3.1.2.1.1 - bvd-add can update the contig table by using an old contig table correctly (no update)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.3.1.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.3.1.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.3.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.3.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.3.1.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.3.2 :
	Updating the contig table by using a new contig table (the new contig's length is longer) 	

=cut

sub case_bvd_add_3_1_3_2_1 {

    subtest "case bvd-add.3.1.3.2.1 - bvd-add can update the contig table by using a new contig table correctly (replace)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.3.2.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.3.2.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.3.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.3.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.3.2.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.3.1.3.3 :
	Updating the contig table by using a 'new&old' contig table (some the new contig's length some longer, some shorter) 	

=cut

sub case_bvd_add_3_1_3_3_1 {

    subtest "case bvd-add.3.1.3.3.1 - bvd-add can update the contig table by using a 'new&old' contig table correctly (check before replace)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.3.1.3.3.1"));
	$absolute_test_data_dir = untaint("$absolute_script_dir/test_data/bvd_add/3.1.3.3.1");

	$source_bvdb   = "$absolute_test_data_dir/3.1.3.3.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.3.3.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/3.1.3.3.1_1.vcf";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "REFERENCE", test_description => "REFERENCE is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "CONTIG", test_description => "CONTIG table is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES group bvd-add.4.x.x.x - Build version

***************************************************************************************************************************

                                                      B  U  I  L  D  V  E  R

***************************************************************************************************************************

=head1 CASES subgroup bvd-add.4.1.x.x

>                                                                                                                          <

> > > > > > > > > > > > > > > > > > > > > > > > > > > > Normal usage < < < < < < < < < < < < < < < < < < < < < < < < < < < <

>                                                                                                                          <

=head2 cases subgroup bvd-add.4.1.1.x

The purpose of the cases in this group is to check if bvd-add can insert/update the correct database when --buildver option is explicitly used in the commandline

    case bvd-add.4.1.1.1 :
	With --buildver hg18	

=cut

sub case_bvd_add_4_1_1_1_1 {

    subtest "case bvd-add.4.1.1.1.1 - bvd-add can insert/update the correct database when '--buildver 18' option is explicitly used in the commandline (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.1.1_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_1_2 {

    subtest "case bvd-add.4.1.1.1.2 - bvd-add can insert/update the correct database when '--buildver 18' option is explicitly used in the commandline (2nd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.1.2"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.1.2";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.1.2_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.1.2_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.1.2_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_1_3 {

    subtest "case bvd-add.4.1.1.1.3 - bvd-add can insert/update the correct database when '--buildver 18' option is explicitly used in the commandline (3rd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.1.3"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.1.3";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.1.3_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.1.3_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.1.3_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_1_4 {

    subtest "case bvd-add.4.1.1.1.4 - bvd-add can insert/update the correct database when '--buildver 18' option is explicitly used in the commandline (4th test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.1.4"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.1.4";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.1.4_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.1.4_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.1.4_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb_hg18", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-add.4.1.1.2 :
	With --buildver hg19	

=cut

sub case_bvd_add_4_1_1_2_1 {

    subtest "case bvd-add.4.1.1.2.1 - bvd-add can insert/update the correct database when '--buildver 19' option is explicitly used in the commandline (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.2.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.2.1_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_2_2 {

    subtest "case bvd-add.4.1.1.2.2 - bvd-add can insert/update the correct database when '--buildver 19' option is explicitly used in the commandline (2nd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.2.2"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.2.2";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.2.2_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.2.2_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.2.2_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_2_3 {

    subtest "case bvd-add.4.1.1.2.3 - bvd-add can insert/update the correct database when '--buildver 19' option is explicitly used in the commandline (3rd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.2.3"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.2.3";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.2.3_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.2.3_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.2.3_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_add_4_1_1_2_4 {

    subtest "case bvd-add.4.1.1.2.4 - bvd-add can insert/update the correct database when '--buildver 19' option is explicitly used in the commandline (4th test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.1.1.2.4"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.1.1.2.4";

	$source_bvdb   = "$absolute_test_data_dir/4.1.1.2.4_bvdb";
	$source_chksum = "$absolute_test_data_dir/4.1.1.2.4_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.1.1.2.4_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "NI", test_description => "NI header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "ENTRIES", test_description => "ENTRIES header is correct");
	compare_DB_header(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", header => "TAGS", test_description => "TAGS header is correct");
	compare_file_content(got => "$absolute_test_DB_dir/bvdb", expected => "$absolute_test_data_dir/expected_result", test_description => "file content is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-add.4.1.2.x

The purpose of the cases in this group is to check if bvd-add can insert/update the correct database when --buildver option is not explicitly used in the commandline (backward compatible)

    ** No case has been made here because, without the option, the result will be the same as those in cases 1.x.x.x

=cut

=head1 CASES subgroup bvd-add.4.2.x.x

>                                                                                                                         <

> > > > > > > > > > > > > > > > > > > > > > > > > > > > Exception < < < < < < < < < < < < < < < < < < < < < < < < < < < < <

>                                                                                                                         <


    case bvd-add.4.2.1.1 :
	To check if bvd-add can handle the invalid --buildver option (non-existing buildver)	

=cut

sub case_bvd_add_4_2_1_1_1 {

    subtest "case bvd-add.4.2.1.1.1 - bvd-add can handle the invalid --buildver option" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_add.4.2.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_add/4.2.1.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/4.2.1.1.1_1.vcf";
	push @test_args, "--buildver";
	push @test_args, "hg17";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	open(STDERR, ">$absolute_test_DB_dir/logfile");
	try {
	    system($absolute_perl_path, $absolute_bvd_add_path, @test_args);
	} catch Error with {
	};
	`/bin/grep "ERROR" $absolute_test_DB_dir/logfile > $absolute_test_DB_dir/error_msg`;
	compare_file(got => "$absolute_test_DB_dir/error_msg", expected => "$absolute_test_data_dir/expected_error", test_description => "ERROR is correctly raised");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

case_bvd_add_1_1_3_1_1();
case_bvd_add_1_1_3_2_1();
case_bvd_add_1_1_4_1_1();
case_bvd_add_1_1_4_2_1();
case_bvd_add_1_1_4_3_1();
case_bvd_add_1_1_4_4_1();
case_bvd_add_1_1_5_1_1();
case_bvd_add_1_1_5_2_1();
case_bvd_add_1_1_6_1_1();
case_bvd_add_1_1_7_2_1();
case_bvd_add_1_1_7_3_1();
case_bvd_add_1_1_7_4_1();
case_bvd_add_1_1_8_1_1();
case_bvd_add_2_1_1_1_1();
case_bvd_add_2_1_1_2_1();
case_bvd_add_2_1_1_3_1();
case_bvd_add_2_1_1_4_1();
case_bvd_add_2_1_1_5_1();
case_bvd_add_2_1_1_6_1();
case_bvd_add_2_1_1_7_1();
case_bvd_add_2_1_1_7_2();
case_bvd_add_2_1_1_8_1();
case_bvd_add_3_1_1_1_1();
case_bvd_add_3_1_1_2_1();
case_bvd_add_3_1_1_3_1();
case_bvd_add_3_1_2_1_1();
case_bvd_add_3_1_2_2_1();
case_bvd_add_3_1_2_3_1();
case_bvd_add_3_1_3_1_1();
case_bvd_add_3_1_3_2_1();
case_bvd_add_3_1_3_3_1();
case_bvd_add_4_1_1_1_1();
case_bvd_add_4_1_1_1_2();
case_bvd_add_4_1_1_1_3();
case_bvd_add_4_1_1_1_4();
case_bvd_add_4_1_1_2_1();
case_bvd_add_4_1_1_2_2();
case_bvd_add_4_1_1_2_3();
case_bvd_add_4_1_1_2_4();
case_bvd_add_4_2_1_1_1();


sub dont_forget {
    my ($msg) = @_;
    fail("$msg");
}

TODO: {
    local $TODO = "Here you go";

    dont_forget("handle pipe input");
    dont_forget("handle process substitution");
    dont_forget("handle wild card input?");

}


done_testing();

