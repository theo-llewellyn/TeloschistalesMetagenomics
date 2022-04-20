#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

#takes the uniref90 db and produces a list of taxa with their taxonomy id
perl -lane 'if(/^>(\w+)\s.+TaxID\=(\d+)/){print "$1 $2"}' <(zcat uniref90.fasta.gz) | gzip > uniref90.fasta.taxlist.gz
