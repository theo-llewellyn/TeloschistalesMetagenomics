#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb
#PBS -J 1-3

#get name of contigs file
ACCESSION=NAME_OF_SEQUENCE

module load anaconda3/personal
source activate redundans-env

cd $PBS_O_WORKDIR

#reduction, scaffolding using pe-reads and gap closing using pe-reads
redundans/redundans.py -v \
-i ${ACCESSION}_concoct_Asco_R1.fq.gz ${ACCESSION}_concoct_Asco_R2.fq.gz \
-f ${ACCESSION}_concoct_Asco_contigs.fa \
-t 32 \
-o redundans_${ACCESSION}_concoct

conda deactivate
