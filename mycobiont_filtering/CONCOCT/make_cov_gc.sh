cat ${ACCESSION}.sam.covstats | awk '{print $1,$5,$7}' > ${ACCESSION}_gc_cov.txt
