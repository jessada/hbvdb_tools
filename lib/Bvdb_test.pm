package Bvdb_test;

use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Differences;

use Cwd 'abs_path';
use File::Basename;
use File::Path;

use Exporter;
use vars qw/@ISA @EXPORT @EXPORT_OK/;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/clear_db get_absolute_db_dir safety_check untaint compare_file compare_file_content compare_file_header file_header_exist exec_bvd_add exec_bvd_get/;

use constant DEFAULT_DB_DIR     => 'DB';

my $absolute_bvd_add_path = untaint(dirname(abs_path($0))."/../bin/bvd-add.pl"); 
my $absolute_bvd_get_path = untaint(dirname(abs_path($0))."/../bin/bvd-get.pl"); 
my $absolute_perl_path    = untaint($^X);

=head1 NAME

Bvdb_test.pm.  This module is exclusively used for testing purpose so the document here is for people who will maintain this module only.

=cut

#***************************************************************************************************************************
#
# function : untaint
# purpose  : to 'clean' unsecure variable
# input    : any untaint data
# note     : What is this whole stuff for? It's not secure at all.
#
#***************************************************************************************************************************

sub untaint
{
    my ($input) = @_;

    my ($result) = $input =~ /^(.*)$/;
    $ENV{"PATH"} = "";

    return $result;
}

#***************************************************************************************************************************
#
# function : safety_check
# purpose  : to check if the environment is safe enough to run the development test
# input    : For now, the input is only the prefix of hbvdb-tools directory, home directory
# note     : the logic is simply to compare the input if it is home directory
#
#***************************************************************************************************************************

sub safety_check
{
    my (%args) = @_;

    if ((! defined($args{home_dir})) || (length($args{home_dir}) == 0)) {
	return 0;
    }
    
    my ($home_dir) = dirname(abs_path($0)) =~ /^(\/\w*\/\w*)/; 

    if ($home_dir ne $args{home_dir}) {
	return 0;
    }
    return 1;
}

#***************************************************************************************************************************
#
# function : clear_db
# purpose  : to prepare database for testing by removing the existing content
# input    : 
#   1. either absolute path, partial path (under 'bin' directory) or NONE (default path -> 'DB')
#   2. authentication to access unsafe environment
#
#***************************************************************************************************************************

sub clear_db
{
    my (%args) = @_;

    rmtree(untaint(get_absolute_db_dir(%args)));
}

#***************************************************************************************************************************
#
# function : get_absolute_db_dir
# purpose  : convert raw directory argument into absolute path of directory 
# input    : 
#   1. either absolute path, partial path (under 'bin' directory) or NONE (default path -> 'DB')
#   2. authentication to access unsafe environment
# note     : a logic to locate the relative path to the exact working directory is implemented here
#
#***************************************************************************************************************************

sub get_absolute_db_dir
{
    my (%args) = @_;
    my $result_dir;

    my $absolute_bin_dir = untaint(dirname(abs_path($0))."/../bin/"); 
    $absolute_bin_dir = `cd $absolute_bin_dir; pwd;`;
    chomp($absolute_bin_dir);

    if ((! defined($args{db_dir})) || (length($args{db_dir}) == 0)) {
	$result_dir = $absolute_bin_dir."/".DEFAULT_DB_DIR;
    } elsif (substr($args{db_dir}, 0, 1) eq '/') {
	$result_dir = $args{db_dir};
    } else {
	$result_dir = $absolute_bin_dir."/".$args{db_dir};
    }

    if (($result_dir eq $absolute_bin_dir."/".DEFAULT_DB_DIR) && (! safety_check(home_dir => $args{home_dir}))) {
	die("It's not allow to access default database directory in unsafe environment");
    }
    return $result_dir;
}

#***************************************************************************************************************************
#
# function : compare_file
# purpose  : to compare if 'got' and 'expected' file are the same
# input    : hash object with key 'got' and 'expected'
# output   : no return value. Without Test::Harness, the compare result of this function will go directy to IO.
#
#***************************************************************************************************************************

sub compare_file
{
    my (%args) = @_;

    if (! defined($args{got}))  {
	die "Could  not open 'got' file: $!";
    } 
    open my $fh_got, "<", $args{got} or die "Could  not open $args{got}: $!";
    if (! defined($args{expected}))  {
	die "Could  not open 'expected' file: $!";
    } 
    open my $fh_expected, "<", $args{expected} or die "Could  not open $args{expected}: $!";

    my @lines_got      =  <$fh_got>;
    my @lines_expected =  <$fh_expected>;

    unified_diff;
    eq_or_diff_data \@lines_got, \@lines_expected, $args{test_description};
}

#***************************************************************************************************************************
#
# function : compare_file_content
# purpose  : to compare the content of two input files
# input    : hash object with key 'got' and 'expected'
# output   : no return value. Without Test::Harness, the compare result of this function will go directy to IO.
# note     : The content mean every lines in the files that don't start with '#' 
#
#***************************************************************************************************************************

sub compare_file_content
{
    my (%args) = @_;

    if (! defined($args{got}))  {
	die "Could  not open 'got' file: $!";
    } 
    open my $fh_got, "<", $args{got} or die "Could  not open $args{got}: $!";
    if (! defined($args{expected}))  {
	die "Could  not open 'expected' file: $!";
    } 
    open my $fh_expected, "<", $args{expected} or die "Could  not open $args{expected}: $!";

    my @lines_got      =  grep !/^#/, <$fh_got>;
    my @lines_expected =  grep !/^#/, <$fh_expected>;

    unified_diff;
    eq_or_diff_data \@lines_got, \@lines_expected, $args{test_description};
}

#***************************************************************************************************************************
#
# function : compare_file_header
# purpose  : to compare one given header of two input files
# input    : hash object with key 'got', 'expected' and 'header'
# output   : no return value. Without Test::Harness, the compare result of this function will go directy to IO.
# note     : 
#  1. This function will compare if the header content of 'got' and 'expected' are exactly the same 
#  2. Header line is the line starting with '##'
#
#***************************************************************************************************************************

sub compare_file_header
{
    my (%args) = @_;

    if (! defined($args{got}))  {
	die "Could  not open 'got' file: $!";
    } 
    open my $fh_got, "<", $args{got} or die "Could  not open $args{got}: $!";
    if (! defined($args{expected}))  {
	die "Could  not open 'expected' file: $!";
    } 
    open my $fh_expected, "<", $args{expected} or die "Could  not open $args{expected}: $!";

    if (! defined($args{header}))  {
	die "header is not defined";
    } 

    my @header_got      =  grep /^##$args{header}/, <$fh_got>;
    my @header_expected =  grep /^##$args{header}/, <$fh_expected>;

    unified_diff;
    eq_or_diff_data \@header_got, \@header_expected, $args{test_description};
}

#***************************************************************************************************************************
#
# function : DB_header_exist
# purpose  : to check if a header line exists with correct format
# input    : hash object with the following keys
#  - 'got' (require)      - result file name
#  - 'header' (require)   - DB header
#  - 'format' (optional)  - the value format (default:None)
#  - 'count' (optional)   - number of records that is expected to be found (default: > 0) 
# note     : This function do the format checking using regular expression.
#
#***************************************************************************************************************************

sub file_header_exist
{
    my (%args) = @_;

    if (! defined($args{got}))  {
	die "Could  not open 'got' file: $!";
    } 
    open my $fh_got, "<", $args{got} or die "Could  not open $args{got}: $!";

    if (! defined($args{header}))  {
	die "header is not defined";
    } 

    my $my_reg = "^##$args{header}=";
    if (defined($args{format})) {
	$my_reg .= $args{format};
    }
    my @headers_got      =  grep /$my_reg/, <$fh_got>;

    if (defined($args{count})) {
	return (scalar @headers_got) == $args{count};
    } 

    return (scalar @headers_got) > 0;
}

#***************************************************************************************************************************
#
# function : exec_bvd_add
# purpose  : execute bvd-add with options
# input    : hash object with 'options' key (array)
# output   : output from STDOUT and error from STDERR which will be stored in the file specified 'output_file' key and 'error_file' key repectively
# note     : commandline execution is done by backsticks.
#
#***************************************************************************************************************************

sub exec_bvd_add {
    my (%args) = @_;
    my $cmd = "$absolute_perl_path $absolute_bvd_add_path";

    if (defined($args{options})) {
	$cmd .= " @{$args{options}}";
    }
    if (defined($args{error_file})) {
	$cmd .= " 2> $args{error_file}";
    }
    if (defined($args{output_file})) {
	$cmd .= " > $args{output_file}";
    }

    `$cmd`;
} 

#***************************************************************************************************************************
#
# function : exec_bvd_get
# purpose  : execute bvd-get with options
# input    : hash object with 'options' key (array)
# output   : output from STDOUT and error from STDERR which will be stored in the file specified 'output_file' key and 'error_file' key repectively
# note     : commandline execution is done by backsticks.
#
#***************************************************************************************************************************

sub exec_bvd_get {
    my (%args) = @_;
    my $cmd = "$absolute_perl_path $absolute_bvd_get_path";

    if (defined($args{options})) {
	$cmd .= " @{$args{options}}";
    }
    if (defined($args{error_file})) {
	$cmd .= " 2> $args{error_file}";
    }
    if (defined($args{output_file})) {
	$cmd .= " > $args{output_file}";
    }

    `$cmd`;
} 

=head1 AUTHOR

Jessada Thutkawkorapin << <jessada.thutkawkorapin@scilifelab.se> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Jessada Thutkawkorapin.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Bvdb
