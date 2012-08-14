#!/bin/bash

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e $scriptdir/../../../bin/DB/bvdb ]
then
	rm $scriptdir/../../../bin/DB/*
	rmdir $scriptdir/../../../bin/DB/
fi

$scriptdir/../../../bin/bvd-add.pl $scriptdir/case_bvd_add_37.vcf -T colon_cancer,lung_cancer --buildver hg18

cp $scriptdir/result_template $scriptdir/expected_result
db_id="$( grep "^##DB_ID" $scriptdir/../../../bin/DB/bvdb_hg18 )"
sed -i -e "s/^##DB_ID=.*/$db_id/g" $scriptdir/expected_result

result=$(diff $scriptdir/../../../bin/DB/bvdb_hg18 $scriptdir/expected_result)

if [ $? -eq 0 ]; then
    echo "All case_bvd_add_37 are correct !!! Congratz"
else
    echo "Something went wrong in case_bvd_add_37 testing. See below "
    echo "$result"
fi

rm $scriptdir/expected_result