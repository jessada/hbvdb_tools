#!/bin/bash

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $scriptdir/case_bvd_add_35_bvdb $scriptdir/../../../bin/DB/bvdb
cp $scriptdir/case_bvd_add_35_bvdb_chksum $scriptdir/../../../bin/DB/bvdb_chksum

$scriptdir/../../../bin/bvd-add.pl $scriptdir/case_bvd_add_35.vcf

result=$(diff $scriptdir/../../../bin/DB/bvdb $scriptdir/expected_result)

if [ $? -eq 0 ]; then
    echo "All case_bvd_add_35 are correct !!! Congratz"
else
    echo "Something went wrong in case_bvd_add_35 testing. See below "
    echo "$result"
fi


