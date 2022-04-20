#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate iqtree-env 

mkdir IQTree_Leca45T_75p_tAL
cd IQTree_Leca45T_75p_tAL

#make concatenated species tree
iqtree2 -p Leca45T_75p_msa_tAl \
 --prefix concat_OF_tAl \
 -B 1000 \
 -T 32

#gene trees
iqtree2 -S Leca45T_75p_msa_tAl \
 --prefix gene_OF_tAl \
 -T 32

conda deactivate
