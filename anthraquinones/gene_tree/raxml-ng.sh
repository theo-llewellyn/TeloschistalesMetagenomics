#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=8:mem=10gb

cd $PBS_O_WORKDIR

#convert to binary format and check how many cores to use
raxml-ng --parse \
 --msa OG0000012_guidance_msa_PAL2NAL_codon.fa \
 --model GTR+G \
 --prefix T1

raxml-ng --all \
 --msa T1.raxml.rba \
 --model GTR+G \
 --prefix OG12_295T_mafft_guidance \
 --seed 2  \
 --bs-metric fbp,tbe \
 --threads 8
