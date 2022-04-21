# *Teloschistales* Metagenomics
Bioinformatic scripts/code for Llewellyn et al. (2022) Metagenomics shines light on the evolution og 'sunscreen' pigments in the *Teloschistales* (lichen-forming Ascomycota)

All scripts (except .R scripts) were run on the Imperial College London High Performance Computer. This HPC uses the PBS queueing system, therefore core/RAM/runtimes in .sh scripts are specified in PBS format. All scripts are written in the format of a single genome (replacing the word ACCESSION for the name of the sequence) but can be converted into array scripts to handle multiple genomes.

## 1. Metagenome Assembly
### 1.1 Quality assessment of Illumina reads
Uses fastq.gz paired end Illumina raw reads. Read trimming requires `TruSeq3-PE-2.fa` for TruSeq Nano Library prep and `NexteraPE-PE.fa` for Nextera XT Library prep. Both .fa adpater files are included in trimmmotatic v0.36 within the adapters directory.  
`cd assembly/QC`
1. `qsub fastqc.sh` assesses raw read quality using [FastQC](https://github.com/s-andrews/FastQC)
2. `qsub trimmomatic.sh` trims low-quality bases and adapters with [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
3. `qsub fastqc_trimmed.sh` assesses read quality post-trimming

### 1.2 Metagenome assembly
`cd assembly/metagenome_assembly`
1. `qsub megahit.sh` metagenome assembly using [MEGAHIT](https://github.com/voutcn/megahit)
2. `qsub metaspades.sh` metagenome assembly using [MetaSPAdes](https://github.com/ablab/spades)

### 1.3 Metagenome assessment
`cd assembly/assessment`
1. `qsub quast.sh` assembly contiguity using [QUAST](https://github.com/ablab/quast)
2. `qsub busco.sh` assembly completeness using [BUSCO](https://busco.ezlab.org/) and the Ascomycota dataset

## 2. Mycobiont read filtering
The following steps filter the metagenome to retrieve only the contigs belonging to the Lecanoromycete mycobiont.

### 2.1 BlobTools (round 1)
Uses a DIAMOND blast of the contigs against the UniRef90 database which can be downloaded [here](https://ftp.expasy.org/databases/uniprot/current_release/uniref/uniref90/uniref90.fasta.gz) and a BLASTn against all Lecanoromycetes genomes in NCBI and three JGI Mycocosm genomes ([Xanthoria parietina](https://mycocosm.jgi.doe.gov/Xanpa2/Xanpa2.home.html), [Cladonia grayii](https://mycocosm.jgi.doe.gov/Clagr3/Clagr3.home.html) and [Usnea florida](https://mycocosm.jgi.doe.gov/Usnflo1/Usnflo1.home.html))  
`cd mycobiont_filtering/BlobTools`
1. `qsub diamond.sh` [DIAMOND](https://github.com/bbuchfink/diamond) blast against UniRef90
2. `qsub blastn.sh` [BLASTn](https://blast.ncbi.nlm.nih.gov/Blast.cgi) against Lecanoromycete database
3. `qsub bbmap.sh` calculates read coverage using [BBTools](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/) bbmap function
4. `qsub taxlist_diamond.sh` link Uniref taxids to taxa
5. `qsub BlobTools.sh` uses [BlobTools](https://github.com/DRL/blobtools) to visualise coverage, GC-content and blast results of contigs. Requires taxonomy file to taxify the output of blast and DIAMOND searches. NCBI taxlist can be downloaded [here](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjmq-eb9qT3AhXcQkEAHZ4TCCMQFnoECAMQAQ&url=https%3A%2F%2Fftp.ncbi.nih.gov%2Fpub%2Ftaxonomy%2Faccession2taxid%2Fnucl_wgs.accession2taxid.gz&usg=AOvVaw2Oeb-8gVxs3HaGSJh4Ck4L) and supplemented with the taxids for JGI genomes by adding rows at the bottom.

### 2.2 CONCOCT
`cd mycobiont_filtering/CONCOCT`
1. `qsub bwa_gatk.sh` align reads to contigs using [BWA-mem](https://github.com/lh3/bwa) and convert to .bam with [GATK](https://gatk.broadinstitute.org/hc/en-us)
2. `qsub concoct.sh` bins metagenome contigs into MAGs using [CONCOCT](https://github.com/BinPro/CONCOCT)
3. `qsub make_cov_gc.sh` makes a coverage and gc_content file from the bbmap output to be used in the following step
4. `Rscript concoct_mags_plot.r` visualises CONCOCT binning and BlobTools blasts to identify Ascomycota bins. Requires the 'clustering_merged.csv' file in the concoct_output
5. `cat bin1.fa bin2.fa bin3.fa > Lecanoromycete_MAG.fa` merge potential mycobiont bins into a single file

### 2.3 Blobtools (round 2)
The `Lecanoromycete_MAG.fa` can then be run through the steps in 2.1 using the exact same scripts but replacing the metagenome assembly for `Lecanoromycete_MAG.fa` taking care to change the output file names so as not to overwrite the first round of BlobTools. The results can then be used to remove any remaining non-mycbiont reads as follows  
`cd mycobiont_filtering/BlobTools_round2`
1. `qsub remove_contam.sh` extracts contig headers of contigs with a top blast of Ascomycota or 'no hit'. Requires the `.bestsum.table.txt` file from BlobTools
2. `qsub seqkit_bbmap.sh` extract contigs based on headers file from previous step using [SeqKit](https://bioinf.shenwei.me/seqkit/) and then pulls reads which map to those contigs using bbmap

### 2.4 Mycobiont assembly cleaning
`cd mycobiont_filtering/cleaning`
1. `qsub redundans.sh` uses [redundans](https://github.com/lpryszcz/redundans) to remove redundant contifs, scaffold and close gaps

## 3. Annotation and orthology inference
### 3.1 Repeat Masking
`cd annotation_orthology/repeat_masking`
1. `qsub repeatmodeler.sh` generates repeat content library using [RepeatModeler](https://www.repeatmasker.org/RepeatModeler/)
2. `qsub funnanotate_sort.sh` sorts contigs using [funnanotate](https://github.com/nextgenusfs/funannotate) pipeline
3. `qsub repeatmasker.sh` uses custom repeat library to softmask genome using [RepeatMasker](https://www.repeatmasker.org/RepeatMasker/)

### 3.2 Gene Prediction
`cd annotation_orthology/gene_prediction`
1. `qsub funnanotate_masked.sh` predicts genes from sorted, masked genome using funnanotate. This uses ESTs and proteins from Xanthoria parietina, Cladonia grayii and Usnea florida as evidence downloaded from JGI mycocosm.
2. `qsub rename_downloaded_proteins.sh` renames the protein headers from assemblies downloaded from NCBI/JGI so that they are unique between proteomes

### 3.3 Orthology inference
`cd annotation_orthology/orthology`
1. `cp *_CONCOCT_genes_masked/predict_results/*proteins.fa formatted_proteomes_45T` copies all predicted proteomes to a new directory called `formatted_proteomes_45T`
2. `qsub orthofinder.sh` runs orthology inference using [OrthoFinder](https://github.com/davidemms/OrthoFinder)

## 4. Phylogenomics
`cd phylogenomcis`
1. `Rscript Orthogroups_75percent.R` uses the `Orthogroups.GeneCount.tsv` file from OrthoFinder to extract a list of single copy orthologues present in at least 75% of taxa
2. `qsub extract_75_orthogroups.sh` pull 75% orthogroups and copy to new directory
3. `qsub mafft_trimAL_loop.sh` uses [MAFFT](https://mafft.cbrc.jp/alignment/software/) to align each orthogroup and [TrimAL](http://trimal.cgenomics.org/) to remove ambiguous regions
4. `qsub edit_protein_headers.sh` removes trailing information on protein headers so that only the species name remains. This is needed in order for tree building tools to recognise which sequences belong to the same genome
5. `qsub iqtree.sh` produces a concatenated maximum likelihood tree from all orthgroups alignments and also individual orthogroup 'gene trees' for each orthogroup separately using [IQ-Tree](https://github.com/iqtree/iqtree2)
6. `qsub iqtree_gfc.sh` calculates gene- and site-concordance factors using IQTree
7. `qsub astral.sh` produces coalescent-based species tree using [ASTRAL](https://github.com/smirarab/ASTRAL)

## 5. Secondary metabolite biosynthetic gene cluster (BGC) analysis
`cd SMGC_analysis`
1. `qsub antismash.sh` predicts BGCs from funnanotate predictions using [antismash](https://github.com/antismash/antismash)
2. `qsub edit_antismash_gbks.sh` edits the antismash .gbk files so that each one includes the name of the genome it came from. This prevent identical named files from being removed in the next stage
3. `cp *.gbk antismash_Leca45T_gbks` copies renamed .gbks from all genomes into a new directory
4. `qsub bigscape.sh` identifies BGC families using [BiG-SCAPE](https://github.com/medema-group/BiG-SCAPE)
5. `Rscript BGC_cluster_analysis.r` Mantel tests and PCoA of BGC data in R. Requires a rooted version of the ML Tree produced in section 4

## 6. Anthraquinone BGC analysis
### 6.1 Functional annotation
Once anthraquinone BGCFs have been identified from BiG-SCAPE output the orthofinder orthogroup to which those PKSs belong can be further characterised.
`cd anthraquinones/functional_annotation`
1. `sed 's/*//g' orthogroup.fa > file_noasterisk.fa` removes any asterisks from orthgroup file as these can't be read by Interpro
2. `qsub interproscan.sh` functional annotation of orthogroup using [InterProScan](https://www.ebi.ac.uk/interpro/about/interproscan/)
3. `qsub extract_PANTHER.sh` extract PANTHER annotations from interpro output

### 6.2 PT domain analysis
The following steps combine the PT domains from our anthraquinone PKSs with the Pfam seed alignment for that domain which can be downloaded [here](https://pfam.xfam.org/family/PF14765#tabview=tab3). The orthogroup of interest may also contain non-anthraqunone PKSs, therefore we need to make a note of which ones are putative anthraquinone PKSs by hovering over the relevant PKSs in the BiG-SCAPE PKSI html file. The names of the putative anthraquinone PKSs need to be saved into a file called `OG_anthraquinone_headers.txt`

`cd anthraquinones/hmmalign`
1. `qsub hmm_convert.sh` converts the Pfam seed alignment to an HMM file using hmmbuilf function of [hmmer](https://github.com/EddyRivasLab/hmmer)
2. `qsub pull_anthraquinone_pks.sh` extract just anthraquinone PKSs from orthogroup of interest
3. `qsub blastp.sh` extracts PT domains from PKSs using the aptA Aspergillus PT domain from [Szewczyk et al. (2008)](https://doi.org/10.1128/AEM.01743-08) (downloaded from [here](https://www.uniprot.org/uniprot/Q5B0D0) as a query using BLASTp
4. `qsub convert_2_fasta.sh` extract PT coordinates from blastp and convert to a fast file [bedtools](https://bedtools.readthedocs.io/en/latest/)
5. The above two steps are repeated for the [Liu et al. (2015)](https://doi.org/10.1038/srep10463) sequences and then combined into a single file of PT domains with our putative anthraquinone PT domains called `OG_anth_Liu_PF14765.out`
6. `qsub hmmalign.sh` uses [this](https://github.com/reubwn/scripts/blob/master/hmmsearch-easy.pl) script from Reuben Nowell to align the PT domains to those in the Pfam seed alignment `PF14765_seed.txt`
7. `qsub iqtree_hmmalign.sh` uses IQTree to build a ML tree from the clustal alignment
8. `qsub hmmalign_taxify.sh` uses [this](https://github.com/reubwn/scripts/blob/master/taxify_uniprot_treefile.pl) script from Reuben Nowell to taxify the output. Requires the Uniref90 taxlist used for BlobTools.
