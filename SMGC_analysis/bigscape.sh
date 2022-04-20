#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate bigscape

cd $PBS_O_WORKDIR

python bigscape.py \
 -i antismash_Leca45T_output/antismash_Leca45T_gbks \
 -o BigScape_c0.4_1_clansoff_Leca45T_output \
 -c 32 \
 --cutoffs 0.4 0.5 0.6 0.7 0.8 0.9 1.0 \ #here add whichever cut-offs you want
 --banned_classes RiPPs Saccharides \
 --hybrids-off \
 --clans-off \
 -v \
 --mibig
 
 conda deactivate
