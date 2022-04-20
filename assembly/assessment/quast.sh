#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load anaconda3/personal

cd $PBS_O_WORKDIR

#replace ASSEMBLY.fasta with final.contigs.fa for MEGAHIT or contigs.fasta for metaSPAdes
python2.7 quast-5.0.2/quast.py ASSEMBLY.fasta
