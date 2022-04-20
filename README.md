# *Teloschistales* Metagenomics
Bioinformatic scripts/code for Llewellyn et al. (2022) Metagenomics shines light on the evolution og 'sunscreen' pigments in the *Teloschistales* (lichen-forming Ascomycota)

All scripts (except .R scripts) were run on the Imperial College London High Performance Computer. This HPC uses the PBS queueing system, therefore core/RAM/runtimes in .sh scripts are specified in PBS format.

## 1. Assembly
### 1.1 Quality assessment of Illumina reads
Uses fastq.gz paired end Illumina raw reads. Read trimming requires `TruSeq3-PE-2.fa` for TruSeq Nano Library prep and `NexteraPE-PE.fa` for Nextera XT Library prep. Both .fa adpater files are included in trimmmotatic v0.36 within the adapters directory.
`cd assembly/QC`
1. `qsub fastqc.sh` assesses raw read quality using FastQC
2. `qsub trimmomatic.sh` trims low-quality bases and adapters with Trimmomatic
3. `qsub fastqc_trimmed.sh` assesses read quality post-trimming

### 1.2 Metagenome assembly
`cd assemnbly/metagenome_assembly`
1. `qsub megahit.sh` metagenome assembly using MEGAHIT
2. `qsub metaspades.sh` metagenome assembly using MetaSPAdes

### 1.3 Metagenome assessment
`cd assembly/assessment`
1. `qsub quast.sh` assembly contiguity using QUAST
2. `qsub busco.sh` assembly completeness using BUSCO and the Ascomycota dataset

### 1.4 Mycobiont read filtering
