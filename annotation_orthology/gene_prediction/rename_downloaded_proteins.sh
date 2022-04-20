#!/bin/bash

for i in *fa
do 
#takes the species name from the file and saves in a variable
	PREFIX=${i%%.proteins*}
#replaces FUN with the taxon name
	sed "s/FUN/${PREFIX}/" $i > ${PREFIX}.proteins_renamed.fa
done
