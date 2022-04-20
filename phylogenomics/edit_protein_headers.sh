#!/bin/bash

#copy the tAl files to a new directory
cp msa_taL/*tAl.fa new_msa_tAl
#first one to remove it from my genomes
for i in *.fa; do sed -E -i '/^>L(6|Q).*/s/_.*//' $i; done
#second one to remove it from the ncbi genomes which I had formatted in the pre-CONCOCT style Cl_mac_prot1 etc
for i in *.fa; do sed -i '/^>/s/_prot.*//' $i; done
