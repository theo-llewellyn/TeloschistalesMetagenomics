#PBS -l walltime=03:00:00
#PBS -l select=1:ncpus=16:mem=124gb
#PBS -J 1-10

module load anaconda3/personal
source activate blobtools

#get name of contigs file
ACCESSION=NAME_OF_SEQUENCE

cd $PBS_O_WORKDIR

# taxify results of diamond using the taxid_mapping file to link GCA to NCBI taxonomy numbers
blobtools taxify \
 -f diamond_output/${ACCESSION}.vs.uniref90.diamond \
 -m uniref90.fasta.taxlist \
 -s 0 -t 1

mv ${ACCESSION}.vs.uniref90.diamond.taxified.out diamond_output/

# taxify results of blast linking to wgs nucleotide taxids
blobtools taxify \
 -f blast_output/${ACCESSION}.vs.Lecanoromycetes_genomes.blastn \
 -m nucl_wgs.accession2taxid_xan \
 -s 1 -t 2

mv ${ACCESSION}.vs.Lecanoromycetes_genomes.blastn.taxified.out blast_output/

mkdir ${ACCESSION}_blobtools.out

#create the blobDB with input, -t hits files for uniprot and lichens
blobtools create \
 -i ASSEMBLY.fasta \
 -c ${ACCESSION}.sam.cov \
 -t diamond_output/${ACCESSION}.vs.uniref90.diamond.taxified.out \
 -t blast_output/${ACCESSION}.vs.Lecanoromycetes_genomes.blastn.taxified.out \
 -o ${ACCESSION}_blobtools.out/${ACCESSION}_blobplot

#create a view of the blobDB, at family rank, default is phylum
blobtools view \
 -i ${ACCESSION}_blobtools.out/${ACCESSION}_blobplot.blobDB.json \
 -r phylum \
 -o ${ACCESSION}_blobtools.out/

#create the blobplot colouring by family and plotting unwanted ones first
blobtools plot \
 -i ${ACCESSION}_blobtools.out/${ACCESSION}_blobplot.blobDB.json \
 -o ${ACCESSION}_blobtools.out/ \
 -r phylum \
 -m \
 --sort_first no-hit,other 
