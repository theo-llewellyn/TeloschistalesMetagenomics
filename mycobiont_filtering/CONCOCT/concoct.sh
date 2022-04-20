#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=62gb
 
module load anaconda3/personal
source activate concoct_env

ACCESSION=NAME_OF_SEQUENCE

cd $PBS_O_WORKDIR

mkdir ${ACCESSION}
cd ${ACCESSION}

cut_up_fasta.py ASSEMBLY.fasta \
 -c 10000 \
 -o 0 \
 --merge_last \
 -b ${ACCESSION}_contigs_10K.bed > ${ACCESSION}_contigs_10K.fa

concoct_coverage_table.py ${ACCESSION}_contigs_10K.bed ${ACCESSION}_bwa.bam > ${ACCESSION}_coverage_table.tsv

concoct \
 --composition_file ${ACCESSION}_contigs_10K.fa \
 --coverage_file ${ACCESSION}_coverage_table.tsv \
 -b concoct_output/ \
 --threads 16

merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv

mkdir concoct_output/fasta_bins

extract_fasta_bins.py ASSEMBLY.fasta \
 concoct_output/clustering_merged.csv --output_path concoct_output/fasta_bins

conda deactivate
