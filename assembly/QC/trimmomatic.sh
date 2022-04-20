#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=8:mem=96gb

module load java
module load trimmomatic/0.36

cd $PBS_O_WORKDIR

#replace NexteraPE-PE.fa with TruSeq3-PE-2.fa for TruSeq Nano
java -jar /apps/trimmomatic/0.36/bin/trimmomatic-0.36.jar PE \
 -threads 8 \
 ACCESSION_1.fastq.gz \
 ACCESSION_2.fastq.gz \
 -baseout ACCESSION_Trimmed.fq.gz \
 ILLUMINACLIP:/apps/trimmomatic/0.36/bin/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
