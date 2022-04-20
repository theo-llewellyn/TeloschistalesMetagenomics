#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=124gb

module load blast+

cd $PBS_O_WORKDIR

mkdir blast_output

#converts the Lecanoromycetes databse to a searchable blast database made up of multiple files named -out
makeblastdb \
-in Lecanoromycetes_genomes_all.fna \
-out Lecanoromycetes_genomes_all \
-parse_seqids \
-dbtype nucl

blastn \
 -task megablast \
 -num_threads 16 \
 -culling_limit 5 \
 -query ASSEMBLY.fasta \
 -db Lecanoromycetes_genomes_all \
 -outfmt 6 \
 -evalue 1e-25 \
 -out blast_output/ACCESSION.vs.Lecanoromycetes_genomes.blastn
