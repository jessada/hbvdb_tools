#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

grep "^#" $1 > $2

grep -P "^1\t811616" $1 >> $2
grep -P "^1\t811630" $1 >> $2
grep -P "^7\t85261" $1 >> $2
grep -P "^7\t102786" $1 >> $2
grep -P "^12\t133720865" $1 >> $2
grep -P "^12\t133728600" $1 >> $2
grep -P "^12\t133732512" $1 >> $2
grep -P "^12\t133732624" $1 >> $2
grep -P "^12\t133780851" $1 >> $2
grep -P "^15\t102272275" $1 >> $2
grep -P "^15\t102358198" $1 >> $2
grep -P "^15\t102369379" $1 >> $2
grep -P "^19\t281360" $1 >> $2
grep -P "^19\t282226" $1 >> $2
grep -P "^22\t51064915" $1 >> $2
grep -P "^22\t51065291" $1 >> $2
grep -P "^X\t166485" $1 >> $2
grep -P "^X\t200860" $1 >> $2
grep -P "^Y\t58983063" $1 >> $2
grep -P "^Y\t58983082" $1 >> $2

