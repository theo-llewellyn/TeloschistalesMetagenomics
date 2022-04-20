
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

ACCESSION=NAME_OF_SEQUENCE

cat ${ACCESSION}.sam.covstats | awk '{print $1,$5,$7}' > ${ACCESSION}_gc_cov.txt
