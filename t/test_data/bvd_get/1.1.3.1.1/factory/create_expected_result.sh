#!/bin/bash

grep "^8" $1 | awk '{printf("10\t%s\t%s\tG\tA\t%.4f\n", $1, $1, $2);}'
