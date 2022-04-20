#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate OrthoFinder-env

cd $PBS_O_WORKDIR

orthofinder \
 -f formatted_proteomes_45T \
 -t 32 \
 -n Leca45T

conda deactivate
