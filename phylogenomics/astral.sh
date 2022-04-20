#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load openjdk/11 astral/5.7.1

mkdir ASTRAL_Leca45T_75p_tAl
cd /ASTRAL_Leca45T_75p_tAl

astral -i IQTree_Leca45T_75p_tAl/gene_OF_tAl.treefile \
 -t 3 \
 -o ASTRAL_Leca45T_75p_OF_tAl.tre \
 2>ASTRAL_out.log
