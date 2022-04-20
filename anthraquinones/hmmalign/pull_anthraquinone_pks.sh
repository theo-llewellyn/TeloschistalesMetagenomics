#!/bin/bah

cat file_noasterisk.fa | seqkit grep -f OG_anthraquinone_headers.txt > OG_anthraquinones.fa
