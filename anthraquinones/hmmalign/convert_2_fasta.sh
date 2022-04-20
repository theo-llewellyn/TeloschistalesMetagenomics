#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load bedtools

cut -f 1,8,9 aptA_PT.vs.OG_anthraquinone.blastp.out > OG_anthraquinone_PT_coords.bed
bedtools getfasta -fi OG_anthraquinones.fa -bed OG_anthraquinone_PT_coords.bed -fo OG_anth_PF14765.out
