#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=32:mem=124gb
 
module load bwa gatk/4.0 samtools

ACCESSION=NAME_OF_SEQUENCE

cd $PBS_O_WORKDIR


#index the assembly
bwa index -a bwtsw ASSEMBLY.fasta

#align reads to assembly
bwa mem ASSEMBLY.fa \
 ${ACCESSION}_Trimmed_1P.fq.gz \
 ${ACCESSION}_Trimmed_2P.fq.gz \
 > ${ACCESSION}bwa.sam

#convert output to binary format
gatk SortSam -I ${ACCESSION}bwa.sam \
 -O ${ACCESSION}_bwa.bam \
 -SO coordinate \
 --CREATE_INDEX=true

#asses alignment
samtools flagstat ${ACCESSION}_bwa.bam
