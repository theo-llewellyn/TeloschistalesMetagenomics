#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate iqtree-env 

cd IQTree_Leca45T_75p_tAl

#concordance factors concatenated
iqtree2 -t IQTree_Leca45T_75p_tAL/concat_OF_tAl.treefile \
 --gcf IQTree_Leca45T_75p_tAL/gene_OF_tAl.treefile \
 -p Leca45T_75p_msa_tAl \
 --scf 100 \
 --prefix concord_Leca45T_tAl_concat \
 -T 9 \
 -seed 121020

conda deactivate
