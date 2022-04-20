#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=124gb
 
module load anaconda3/personal
source activate diamond-env

cd $PBS_O_WORKDIR

mkdir diamond_output

#blast genome assembly against the uniprot90
diamond blastx \
   --index-chunks 1 \
   -e 1e-25 \
   -p 16 \
   -q ASSEMBLY.fasta \
   -d uniref90.fasta.dmnd \
   --out diamond_output/ACCESSION.vs.uniref90.diamond \
   --outfmt 6 \
   --sensitive

conda deactivate
