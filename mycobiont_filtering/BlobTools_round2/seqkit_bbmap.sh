#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=124gb

module load anaconda3/personal
source activate seqkit-env

cd $PBS_O_WORKDIR

#opens the assembly, searches for particular contigs and puts into a new file
cat ASSEMBLY.fasta | seqkit grep -f ACCESSION_concoct_Asco_headers.fa > ACCESSION_Asco_contigs.fa

conda deactivate

#pull reads mapping to those contigs with bbmap
module load bbmap

bbmap.sh -Xmx62g \
nodisk=t \
ref=ACCESSION_Asco_contigs.fa \
in1=ACCESSION_Trimmed_1P.fq.gz \
in2=ACCESSION_Trimmed_2P.fq.gz \
threads=16 \
outm=ACCESSION_concoct_Asco_R#.fq.gz
