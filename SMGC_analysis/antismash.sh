#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=50:mem=600gb

module load anaconda3/personal
source activate antismash

cd $PBS_O_WORKDIR

antismash \
 ACCESSION_CONCOCT_genes_masked/predict_results/SPECIES.gbk \
 -c 30 \
 --taxon fungi \
 --cassis \
 --cb-general \
 --cb-subclusters \
 --cb-knownclusters \
 --asf \
 --pfam2go \
 --genefinding-tool none \
 -v \
 --logfile antismash_ACCESSION_log.txt \
 --output-dir antismash_Leca45T_output/ACCESSION

conda deactivate
