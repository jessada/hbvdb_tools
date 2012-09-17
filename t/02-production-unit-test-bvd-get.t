#!perl -T 

#***************************************************************************************************************************
#
# Purpose  : To check the functinality of bvd-get.pl in user environment
# Note     : The 'database' directory for this testing will have prefix '__TEST_bvd_get' which is located in <hbvdb-toos/bin> directory
#
#***************************************************************************************************************************

use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Differences;

use Cwd 'abs_path';
use File::Basename;
use File::Path qw(mkpath);
use File::Copy;

use Bvdb_test qw(clear_db untaint get_absolute_db_dir compare_file compare_file_content compare_file_header exec_bvd_add exec_bvd_get);

my @test_args;
my $absolute_script_dir   = untaint(dirname(abs_path($0))); 

my $absolute_test_DB_dir;
my $absolute_test_data_dir;
my $source_bvdb;
my $source_chksum;
my $target_bvdb;
my $target_chksum;

=head1 NAME

F<02-production-unit-test-bvd-get.t>

=head1 PURPOSE

To check the functinality of bvd-get.pl in user environment

=head1 NOTE1

The 'database' directory for this testing will have prefix '__TEST_bvd_get' which is located in <hbvdb-toos/bin> directory

=head1 NOTE2

The naming convention of cases and related files can be splitted into 5 levels (This naming convention is not related to version number)

=over 4

=item * The first level indicate the major change or major features

=item * The second and third level are designed to facilatate the test. They will be used to categorize the case into group and sub-group

=item * The forth level is the running number of cases in one sub group
  
=item * The last level is designed so that the tests with the same description can be run several times with diffrent input (retest) 

=back

=head1 CASES group bvd-get.1.x.x.x - The first release

***************************************************************************************************************************

                                              F  I  R  S  T      R  E  L  E  A  S  E   

***************************************************************************************************************************

=head2 cases subgroup bvd-get.1.1.2.x

The purpose of the cases in this group is to work with the simulated normal operation (bvd-add then bvd-get) at the additional database

    case bvd-get.1.1.2.1 :
	bvd-get work correctly under the simulated normal operation (bvd-add then bvd-get) at the additional database (option -d).

=cut

sub case_bvd_get_1_1_2_1_1 {

    subtest "case bvd-get.1.1.2.1.1 - bvd-get work correctly under the simulated normal operation (bvd-add then bvd-get) at the additional database (option -d)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.1.1.2.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/1.1.2.1.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.1.1_2.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.1.1_1.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.2.1.1_4.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.1.1_3.vcf";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.2.1.1_5.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	exec_bvd_add(options => \@test_args);
	#`$absolute_perl_path $absolute_bvd_add_path $absolute_test_data_dir/1.1.2.1.1_3.vcf -T colon_cancer,lung_cancer -d $absolute_test_DB_dir`;
	#`$absolute_perl_path $absolute_bvd_add_path -d $absolute_test_DB_dir $absolute_test_data_dir/1.1.2.1.1_5.vcf -T lung_cancer`;

	@test_args = ();
	push @test_args, "-T";
	push @test_args, "colon_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "avdb output is correct");
	#my @lines_got_bvd_get_output = `$absolute_perl_path $absolute_bvd_get_path -T colon_cancer -d $absolute_test_DB_dir`;
	#open my $fh_expected_bvd_get_output, "<", "$absolute_test_data_dir/expected_result" or die "Could  not open $absolute_test_data_dir/expected_result: $!";
	#my @lines_expected_bvd_get_output =  <$fh_expected_bvd_get_output>;

	#unified_diff;
	#eq_or_diff_data \@lines_got_bvd_get_output, \@lines_expected_bvd_get_output, "avdb output is correct";
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.1.1.2.2 :
	bvd-get work correctly under the simulated normal operation (bvd-add then bvd-get) at the additional database (option --database).

=cut

sub case_bvd_get_1_1_2_2_1 {

    subtest "case bvd-get.1.1.2.2.1 - bvd-get work correctly under the simulated normal operation (bvd-add then bvd-get) at the additional database (option --database)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.1.1.2.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/1.1.2.2.1";

	clear_db(db_dir => $absolute_test_DB_dir);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.2.1_2.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.2.1_1.vcf";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.2.2.1_4.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "$absolute_test_data_dir/1.1.2.2.1_3.vcf";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_add(options => \@test_args);
	@test_args = ();
	push @test_args, "-d";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "$absolute_test_data_dir/1.1.2.2.1_5.vcf";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	exec_bvd_add(options => \@test_args);

	@test_args = ();
	push @test_args, "-T";
	push @test_args, "colon_cancer";
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "avdb output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-get.1.1.3.x

The purpose of the cases in this group is to variant frequency output is calculated correct when 'tag exclusion' option (-T) is presented

    case bvd-get.1.1.3.1 :
	To test if bvd-get can handle all possible combination of 3 valid tags, "colon_cancer", "lung_cancer" and "prostate_cancer", correctly (note. using database from case 1.1.5.2.1).
	This case consists of 16 subcases, each with different '-T' options. The list of options is as following
	1. <no excluded tags>
	2. colon_cancer
	3. colon_cancer,lung_cancer
	4. colon_cancer,lung_cancer,prostate_cancer
	5. colon_cancer,prostate_cancer
	6. colon_cancer,prostate_cancer,lung_cancer
	7. lung_cancer
	8. lung_cancer,colon_cancer
	9. lung_cancer,colon_cancer,prostate_cancer
	10. lung_cancer,prostate_cancer
	11. lung_cancer,prostate_cancer,colon_cancer
	12. prostate_cancer
	13. prostate_cancer,colon_cancer
	14. prostate_cancer,colon_cancer,lung_cancer
	15. prostate_cancer,lung_cancer
	16. prostate_cancer,lung_cancer,colon_cancer

=cut

sub case_bvd_get_1_1_3_1_1 {

    subtest "case bvd-get.1.1.3.1.1 - bvd-get can handle all possible combination of 3 valid tags, 'colon_cancer', 'lung_cancer' and 'prostate_cancer', correctly" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.1.1.3.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/1.1.3.1.1";

	$source_bvdb   = "$absolute_test_data_dir/1.1.3.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.3.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_1", test_description => "avdb output is correct if no exclustion tags presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_2", test_description => "avdb output is correct if option '-T colon_cancer' is presented");
	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_3", test_description => "avdb output is correct if option '-T colon_cancer,lung_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,lung_cancer,prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_4", test_description => "avdb output is correct if option '-T colon_cancer,lung_cancer,prostate_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_5", test_description => "avdb output is correct if option '-T colon_cancer,prostate_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "colon_cancer,prostate_cancer,lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_6", test_description => "avdb output is correct if option '-T colon_cancer,prostate_cancer,lung_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_7", test_description => "avdb output is correct if option '-T lung_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_8", test_description => "avdb output is correct if option '-T lung_cancer,colon_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_9", test_description => "avdb output is correct if option '-T lung_cancer,colon_cancer,prostate_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_10", test_description => "avdb output is correct if option '-T lung_cancer,prostate_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_11", test_description => "avdb output is correct if option '-T lung_cancer,prostate_cancer,colon_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_12", test_description => "avdb output is correct if option '-T prostate_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer,colon_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_13", test_description => "avdb output is correct if option '-T prostate_cancer,colon_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer,colon_cancer,lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_14", test_description => "avdb output is correct if option '-T prostate_cancer,colon_cancer,lung_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer,lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_15", test_description => "avdb output is correct if option '-T prostate_cancer,lung_cancer' is presented");

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "prostate_cancer,lung_cancer,colon_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result_16", test_description => "avdb output is correct if option '-T prostate_cancer,lung_cancer,colon_cancer' is presented");

	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.1.1.3.2 :
	bvd-get can handle duplicated tags, option '-T lung_cancer,colon_cancer,lung_cancer'.

=cut

sub case_bvd_get_1_1_3_2_1 {

    subtest "case bvd-get.1.1.3.2.1 - bvd-get can handle duplicated tags, option '-T lung_cancer,colon_cancer,lung_cancer'" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.1.1.3.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/1.1.3.2.1";

	$source_bvdb   = "$absolute_test_data_dir/1.1.3.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.3.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "avdb output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.1.1.3.3 :
	bvd-get can handle non-existing tags, 'breast_cancer'.

=cut

sub case_bvd_get_1_1_3_3_1 {

    subtest "case bvd-get.1.1.3.3.1 - bvd-get can handle non-existing tags, 'breast_cancer'" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.1.1.3.3.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/1.1.3.3.1";

	$source_bvdb   = "$absolute_test_data_dir/1.1.3.3.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/1.1.3.3.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer,breast_cancer";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "avdb output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES group bvd-get.2.x.x.x - VCF format (reference and contig table)

***************************************************************************************************************************

                                                    V  C  F     f  o  r  m  a  t   

***************************************************************************************************************************

=head2 cases subgroup bvd-get.2.1.1.x

The purpose of the cases in this group is to check if bvd-get can generally generate the correct output in the VCF format

    case bvd-get.2.1.1.1 :
	bvd-get can generally generate the correct output in the VCF format when both the reference and contig table are presented in the database.

=cut

sub case_bvd_get_2_1_1_1_1 {

    subtest "case bvd-get.2.1.1.1.1 - bvd-get can generally generate the correct output in the VCF format when both the reference and contig table are presented in the database" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.2.1.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/2.1.1.1.1";

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
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.2.1.1.2 :
	bvd-get can generally generate the correct output in the VCF format when neither the reference and contig table are presented in the database (backward compatible).

=cut

sub case_bvd_get_2_1_1_2_1 {

    subtest "case bvd-get.2.1.1.2.1 - bvd-get can generally generate the correct output in the VCF format when neither the reference and contig table are presented in the database (backward compatible)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.2.1.1.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/2.1.1.2.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.1.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.1.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct (no contig table)");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct (no reference)");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-get.2.1.2.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the VCF format some headers are not normally presented in the database

    case bvd-get.2.1.2.1 :
	bvd-get can generate the correct output in the VCF format when only the contig table is presented in the database.

=cut

sub case_bvd_get_2_1_2_1_1 {

    subtest "case bvd-get.2.1.2.1.1 - bvd-get can generate the correct output in the VCF format when only the contig table is presented in the database" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.2.1.2.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/2.1.2.1.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.2.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.2.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct (no reference)");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.2.1.2.2 :
	bvd-get can generate the correct output in the VCF format when only the reference is presented in the database.

=cut

sub case_bvd_get_2_1_2_2_1 {

    subtest "case bvd-get.2.1.2.1.1 - bvd-get can generate the correct output in the VCF format when only the reference is presented in the database" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.2.1.2.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/2.1.2.2.1";

	$source_bvdb   = "$absolute_test_data_dir/2.1.2.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/2.1.2.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "-T";
	push @test_args, "lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct (no contig table)");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES group bvd-get.3.x.x.x - Build version 

***************************************************************************************************************************

                                             B  u  i  l  d     v  e  r  s  i  o  n   

***************************************************************************************************************************

=head1 CASES subgroup bvd-get.3.1.x.x

>                                                                                                                         <

> > > > > > > > > > > > > > > > > > > > > > > > >  a v d b  f o r m a t < < < < < < < < < < < < < < < < < < < < < < < < < <

>                                                                                                                         <

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the avdb format

=head2 cases subgroup bvd-get.3.1.1.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the avdb format when the correct buildver option is explicitly defined

    case bvd-get.3.1.1.1 :
	bvd-get can generate the correct output in the avdb format from the buildver hg18.

=cut

sub case_bvd_get_3_1_1_1_1 {

    subtest "case bvd-get.3.1.1.1.1 - bvd-get can generate the correct output in the avdb format using option '--buildver hg18' (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.1.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.1.1.1.1";

	$source_bvdb   = "$absolute_test_data_dir/3.1.1.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.1.1.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "-T";
	push @test_args, "lung_cancer,lung_cancer";
	push @test_args, "--avdb";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
        compare_file(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The avdb output is correct");
	#clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.3.1.1.2 :
	bvd-get can generate the correct output in the avdb format from the buildver hg19.

=cut

=head2 cases subgroup bvd-get.3.1.2.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the avdb format from the default buildver, 'hg19' when the buildver option is not explicitly defined

    case bvd-get.3.1.2.1 :
	bvd-get can generate the correct output in the avdb format from the default buildver, 'hg19'.

=cut

=head2 cases subgroup bvd-get.3.1.3.x

The purpose of the cases in this group is to check if bvd-get can handle invalid 'buildver' option

    case bvd-get.3.1.3.1 :
	bvd-get raises an exception when the invalid 'buildver' option is presented.

=cut

=head1 CASES subgroup bvd-get.3.2.x.x

>                                                                                                                         <

> > > > > > > > > > > > > > > > > > > > > > > > >  V C F   f o r m a t  < < < < < < < < < < < < < < < < < < < < < < < < < <

>                                                                                                                         <

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the VCF format

=head2 cases subgroup bvd-get.3.2.1.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the VCF format when the correct buildver option is explicitly defined

    case bvd-get.3.2.1.1 :
	bvd-get can generate the correct output in the VCF format using option '--buildver hg18'.

=cut

sub case_bvd_get_3_2_1_1_1 {

    subtest "case bvd-get.3.2.1.1.1 - bvd-get can generate the correct output in the VCF format using option '--buildver hg18' (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.1.1";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "-T";
	push @test_args, "lung_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_get_3_2_1_1_2 {

    subtest "case bvd-get.3.2.1.1.2 - bvd-get can generate the correct output in the VCF format using option '--buildver hg18' (2nd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.1.2"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.1.2";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.1.2_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.1.2_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct (no reference)");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_get_3_2_1_1_3 {

    subtest "case bvd-get.3.2.1.1.3 - bvd-get can generate the correct output in the VCF format using option '--buildver hg18' (3rd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.1.3"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.1.3";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.1.3_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.1.3_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb_hg18";
	$target_chksum = "$absolute_test_DB_dir/bvdb_hg18_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct (no contig table)");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.3.2.1.2 :
	bvd-get can generate the correct output in the VCF format using option '--buildver hg19'.

=cut

sub case_bvd_get_3_2_1_2_1 {

    subtest "case bvd-get.3.2.1.2.1 - bvd-get can generate the correct output in the VCF format using option '--buildver hg19' (1st test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.2.1";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "-T";
	push @test_args, "lung_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_get_3_2_1_2_2 {

    subtest "case bvd-get.3.2.1.2.2 - bvd-get can generate the correct output in the VCF format using option '--buildver hg19' (2nd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.2.2"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.2.2";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.2.2_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.2.2_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct (no reference)");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

sub case_bvd_get_3_2_1_2_3 {

    subtest "case bvd-get.3.2.1.2.3 - bvd-get can generate the correct output in the VCF format using option '--buildver hg19' (3rd test)" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.1.2.3"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.1.2.3";

	$source_bvdb   = "$absolute_test_data_dir/3.2.1.2.3_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.1.2.3_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg19";
	push @test_args, "-T";
	push @test_args, "lung_cancer,colon_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, output_file => "$absolute_test_DB_dir/bvd_get_out");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "contig", test_description => "the contig header of VCF output is correct (no contig table)");
	compare_file_header(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", header => "reference", test_description => "the reference header of VCF output is correct");
        compare_file_content(got => "$absolute_test_DB_dir/bvd_get_out", expected => "$absolute_test_data_dir/expected_result", test_description => "The content of VCF output is correct");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head2 cases subgroup bvd-get.3.2.2.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the VCF format from the default buildver, 'hg19' when the buildver option is not explicitly defined

    Note. The cases in this group are similar to cases in group 2.x.x.x so no cases here.

=cut

=head2 cases subgroup bvd-get.3.2.3.x

The purpose of the cases in this group is to check if bvd-get can handle invalid 'buildver' option

    case bvd-get.3.2.3.1 :
	bvd-get raises an exception when the specified 'buildver' option is not supported by bvd-get while trying to generate output in VCF format.

=cut

sub case_bvd_get_3_2_3_1_1 {

    subtest "case bvd-get.3.2.3.1.1 - bvd-get raises an exception when the specified 'buildver' option is not supported by bvd-get while trying to generate output in VCF format" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.3.1.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.3.1.1";

	$source_bvdb   = "$absolute_test_data_dir/3.2.3.1.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.3.1.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg17";
	push @test_args, "-T";
	push @test_args, "lung_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, error_file => "$absolute_test_DB_dir/bvd_get_error");
	`/bin/grep "ERROR" $absolute_test_DB_dir/bvd_get_error > $absolute_test_DB_dir/got_error`;
        compare_file(got => "$absolute_test_DB_dir/got_error", expected => "$absolute_test_data_dir/expected_error", test_description => "The exception is raised correctly");
	clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=pod

    case bvd-get.3.2.3.2 :
	bvd-get raises an exception when the specified 'buildver' option is supported but not-existing while trying to generate output in VCF format.

=cut

sub case_bvd_get_3_2_3_2_1 {

    subtest "case bvd-get.3.2.3.2.1 - bvd-get raises an exception when the specified 'buildver' option is supported but not-existing while trying to generate output in VCF format" => sub {

	$absolute_test_DB_dir   = untaint(get_absolute_db_dir(db_dir => "__TEST_bvd_get.3.2.3.2.1"));
	$absolute_test_data_dir = "$absolute_script_dir/test_data/bvd_get/3.2.3.2.1";

	$source_bvdb   = "$absolute_test_data_dir/3.2.3.2.1_bvdb";
	$source_chksum = "$absolute_test_data_dir/3.2.3.2.1_bvdb_chksum"; 

	$target_bvdb   = "$absolute_test_DB_dir/bvdb";
	$target_chksum = "$absolute_test_DB_dir/bvdb_chksum";

	clear_db(db_dir => $absolute_test_DB_dir);
	mkpath $absolute_test_DB_dir;
	copy($source_bvdb, $target_bvdb) or die "Cannot copy $source_bvdb to $target_bvdb\n";
	copy($source_chksum, $target_chksum) or die "Cannot copy $source_chksum to $target_chksum\n";

	@test_args = ();
	push @test_args, "--database";
	push @test_args, "$absolute_test_DB_dir";
	push @test_args, "--buildver";
	push @test_args, "hg18";
	push @test_args, "-T";
	push @test_args, "lung_cancer,lung_cancer";
	push @test_args, "--vcf";
	exec_bvd_get(options => \@test_args, error_file => "$absolute_test_DB_dir/bvd_get_error");
	`/bin/grep "ERROR" $absolute_test_DB_dir/bvd_get_error > $absolute_test_DB_dir/got_error`;
        compare_file(got => "$absolute_test_DB_dir/got_error", expected => "$absolute_test_data_dir/expected_error", test_description => "The exception is raised correctly");
	#clear_db(db_dir => $absolute_test_DB_dir);

	done_testing();
    };
}

=head1 CASES subgroup bvd-get.3.3.x.x

>                                                                                                                         <

> > > > > > > > > > > > > > > > > > > > > > >  d e f a u l t   f o r m a t  < < < < < < < < < < < < < < < < < < < < < < < <

>                                                                                                                         <

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the default format, avdb, when no format option is explicitly defined

=head2 cases subgroup bvd-get.3.3.1.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the default format, avdb,  when the correct buildver option is explicitly defined

    case bvd-get.3.3.1.1 :
	bvd-get can generate the correct output in the default format, avdb, from the buildver hg18.

=cut

=pod

    case bvd-get.3.3.1.2 :
	bvd-get can generate the correct output in the default format, avdb, from the buildver hg19.

=cut

=head2 cases subgroup bvd-get.3.3.2.x

The purpose of the cases in this group is to check if bvd-get can generate the correct output in the default format, avdb, from the default buildver, 'hg19' when the buildver option is not explicitly defined

    Note. The cases in this group are similar to cases in group 1.x.x.x so no cases here.

=cut

=head2 cases subgroup bvd-get.3.3.3.x

The purpose of the cases in this group is to check if bvd-get can handle invalid 'buildver' option

    case bvd-get.3.3.3.1 :
	bvd-get raises an exception when the invalid 'buildver' option is presented.

=cut

#case_bvd_get_1_1_2_1_1();
#case_bvd_get_1_1_2_2_1();
#case_bvd_get_1_1_3_1_1();
#case_bvd_get_1_1_3_2_1();
#case_bvd_get_1_1_3_3_1();
#case_bvd_get_2_1_1_1_1();
#case_bvd_get_2_1_1_2_1();
#case_bvd_get_2_1_2_1_1();
#case_bvd_get_2_1_2_2_1();
case_bvd_get_3_1_1_1_1();
#case_bvd_get_3_2_1_1_1();
#case_bvd_get_3_2_1_1_2();
#case_bvd_get_3_2_1_1_3();
#case_bvd_get_3_2_1_2_1();
#case_bvd_get_3_2_1_2_2();
#case_bvd_get_3_2_1_2_3();
#case_bvd_get_3_2_3_1_1();
#case_bvd_get_3_2_3_1_1();

#case_bvd_get_3_2_3_2_1();

sub dont_forget {
    my ($msg) = @_;
    fail("$msg");
}

TODO: {
    local $TODO = "Here you go";

    dont_forget("case 3.1.1.1.1");
#    dont_forget("case 3.1.1.2.1");
#    dont_forget("case 3.1.2.1.1");
#    dont_forget("case 3.1.3.1.1");
#    dont_forget("case 3.3.1.1.1");
#    dont_forget("case 3.3.1.2.1");
#    dont_forget("case 3.3.3.1.1");

    dont_forget("Fix bug from case 1.1.3.1.1, it should raise an exception instead because it's probably a typo");
    dont_forget("Fix bug from case 3.2.3.2.1");
    dont_forget("test if tags can have '-' character");
#    dont_forget("migrate script from the past");

}


done_testing();

