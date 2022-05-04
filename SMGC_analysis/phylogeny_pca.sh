#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=8:mem=10gb
 
cd $PBS_O_WORKDIR

module load anaconda3/personal
source activate lifestyles-env

mkdir BGCF-presenceabsence

python run_edited.py 	-i BGCF-presenceabsence.csv \
                      -t concord_Leca45T_tAl_concat.renamed.rooted.tre \
                      -o BGCF-presenceabsence \
			                --colors Ostropales:pink,Umbilicariales:#d99627,Teloschistales:#666f6e,Lecanorales:#96adcb

conda deactivate
