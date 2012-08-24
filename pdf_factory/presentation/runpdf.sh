#!/bin/bash -l

pdflatex multicenter-merge.tex
if [ -e multicenter-merge.pdf ]
then
    evince multicenter-merge.pdf
fi


