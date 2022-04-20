#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=124gb

module load anaconda3/personal
source activate RepeatModeler

cd $PBS_O_WORKDIR

## add dirs to @INC
export PERL5LIB=${PERL5LIB}:home/perl5/lib/perl5:home/anaconda3/envs/RepeatModeler/lib/perl5/site_perl/5.32.0/x86_64-linux/:home/anaconda3/envs/RepeatModeler/lib/perl5/site_perl/5.32.0:home/anaconda3/envs/RepeatModeler/lib/perl5/5.32.0/x86_64-linux:home/anaconda3/envs/RepeatModeler/lib/perl5/5.32.0
## check @INC
perl -V

RepeatMasker \
 -e ncbi \
 -lib ACCESSION_concoct-families.fa \
 -pa 20 \
 -xsmall \
 -dir ACCESSION_concoct_masked \
 -alignments \
 redundans_ACCESSION_concoct/scaffolds_filled_sorted.fa

conda deactivate
