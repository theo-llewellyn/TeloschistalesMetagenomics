#PBS -l walltime=00:20:00
#PBS -l select=1:ncpus=1:mem=1gb

pal2nal.v14.pal2nal.pl \
 OG12_Guidance2_MAFFT_round2/MSA.MAFFT.aln.With_Names \ 
 OG12_guidance_CDS.fa \
 -output fasta
