#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb
 
module load anaconda3/personal
source activate megahit-env

cd $PBS_O_WORKDIR

megahit -1 ACCESSION_Trimmed_1P.fq.gz \
 -2 ACCESSION_Trimmed_2P.fq.gz \
 -o megahit_ACCESSION \
 -t 32

conda deactivate
