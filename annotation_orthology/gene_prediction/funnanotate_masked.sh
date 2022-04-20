#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

#get name of contigs file
ACCESSION=NAME_OF_SEQUENCE
SPECIES=NAME_OF_SPECIES
LOCUS_TAG=NCBI_LOCUS_TAG


module load anaconda3/personal
source activate funannotate

cd $PBS_O_WORKDIR

export FUNANNOTATE_DB=home/anaconda3/envs/funannotate/funannotate_db

funannotate predict \
 -i ${ACCESSION}_concoct_masked/scaffolds_filled_sorted.fa.masked \
 -s "${SPECIES}" \
 --name ${LOCUS_TAG} \
 --transcript_evidence Clagr3_ESTs_20111209_Velvet_and_Trinity_contigs.fasta Clagr3_ESTs_20111121_454_ESTs.fasta Usnflo1_ESTs_20160419_est.fasta Xanpa2_ESTs_20140928_est.fasta \
 --protein_evidence Clagr3_GeneCatalog_proteins_20111121.aa.fasta Usnflo1_GeneCatalog_proteins_20160419.aa.fasta Xanpa2_GeneCatalog_proteins_20140928.aa.fasta $FUNANNOTATE_DB/uniprot_sprot.fasta \
 -o ${ACCESSION}_CONCOCT_genes_masked \
 --cpus 32 \
 --force

conda deactivate
