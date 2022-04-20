#!/bin/bash

#in the antismash output directory
for i in ACCESSION*
do
echo $i
cd $i
for gbk in *region*.gbk
do
echo $gbk
cp $gbk ${i}_${gbk}
done
cd ../
done
