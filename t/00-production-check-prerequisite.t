#!perl -T

#***************************************************************************************************************************
#
# Purpose  : To check if the prerequisite libraries for both production and testing were already installed
#
#***************************************************************************************************************************

use 5.006;
use strict;
use warnings;
use Test::More tests => 5;

require_ok('Vcf');
require_ok('Log::Log4perl');
require_ok('Test::Differences');
require_ok('Bvdb');
require_ok('Bvdb_test');


