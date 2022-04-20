#!/bin/bash

perl -lane 'if(($F[5]=~"Ascomycota")|($F[5]=~"no-hit")){print $F[0]}' ACCESSION_concoct_blobtools.out/ACCESSION_concoct_blobplot.blobDB.bestsum.table.txt > ACCESSION_concoct_Asco_headers.fa
