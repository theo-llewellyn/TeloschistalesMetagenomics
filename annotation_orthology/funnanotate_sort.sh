#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=8:mem=96gb

#get name of contigs file
ACCESSION=NAME_OF_SEQUENCE

module load anaconda3/personal
source activate funannotate

cd $PBS_O_WORKDIR

export FUNANNOTATE_DB=home/anaconda3/envs/funannotate/funannotate_db

funannotate sort \
 -i redundans_${ACCESSION}_concoct/scaffolds.filled.fa \
 -o redundans_${ACCESSION}_concoct/scaffolds_filled_sorted.fa

conda deactivate
