#PBS -l walltime=72:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate spades-env

cd $PBS_O_WORKDIR

SPAdes-3.14.0-Linux/bin/metaspades.py \
 --pe1-1 ACCESSION_Trimmed_1P.fq.gz \
 --pe1-2 ACCESSION_Trimmed_2P.fq.gz \
 -o metaSPAdes_ACCESSION

conda deactivate
