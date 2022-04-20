#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load java fastqc

cd $PBS_O_WORKDIR

fastqc ACCESSION_1P.fq.gz ACCESSION_2P.fq.gz -t 8
