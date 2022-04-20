#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=96gb

module load anaconda3/personal
source activate iqtree-env

cd $PBS_O_WORKDIR

iqtree2 -s hmmsearch-easy.KS_PT_OG_Liu.hmmalign.clustal \
 -B 1000 \
 -T 16
