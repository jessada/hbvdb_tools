#!/bin/bash -l
#SBATCH -A b2011026
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH -J coca_pf_01

start_time=$(date +%s)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#script_dir="/bubo/home/h10/jessada/private/hbvdb/testcase/performance"
db_dir="/home/jessada/development/scilifelab/master_data/HBVDB/200danes"
input_dir="/home/jessada/development/scilifelab/master_data/200danes/vcf"

out_file=$scriptdir/out/case_performance_01_out.txt
if [ -e $db_dir/bvdb ]
then
    rm $db_dir/*
    rmdir $db_dir
fi

if [ -e $out_file ]
then
    rm $out_file
fi

for file in $input_dir/*.vcf
do
    echo $file

    $script_dir/../../bin/bvd-add.pl $file --savediskspace -d $db_dir

    end_time=$(date +%s)
    time_diff=$((end_time-start_time))

    echo total excutetime so far $time_diff seconds
done
 
