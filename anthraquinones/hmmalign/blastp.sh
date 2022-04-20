#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load blast+

cd $PBS_O_WORKDIR

#converts the proteins to a searchable blast database made up of multiple files named -out
makeblastdb \
-in OG_anthraquinones.fa \
-out OG_anthraquinones \
-parse_seqids \
-dbtype prot

blastp \
-num_threads 8 \
-query aptA_PT_domain.fa \
-db OG_anthraquinones \
-outfmt "6 sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore sseq" \
-evalue 1 \
-out aptA_PT.vs.OG_anthraquinone.blastp.out
