#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=96gb

module load anaconda3/personal java/oracle-jdk-11.0.10
source activate interproscan

cd $PBS_O_WORKDIR

interproscan.sh -i file_noasterisk.fa \
 -f tsv \
 -o OG_Leca45T_interpro_out.tsv \
 -goterms \
 -pa \
 -cpu 30

conda deactivate
