#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb
 
module load anaconda3/personal
source activate busco-env


cd $PBS_O_WORKDIR

export BUSCO_CONFIG_FILE="anaconda3/envs/busco-env/config/config.ini"

busco -i ASSEMBLY.fasta \
 -o BUSCO_Asco_ACCESSION \
 -l ascomycota_odb10 \
 -c 32 \
 -m genome

conda deactivate
