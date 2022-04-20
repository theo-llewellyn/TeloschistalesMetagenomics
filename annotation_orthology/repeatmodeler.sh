#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=5:mem=96gb

#get name of contigs file
ACCESSION=NAME_OF_SEQUENCE

module load anaconda3/personal
source activate RepeatModeler
#module load perl

cd $PBS_O_WORKDIR

#build database
RepeatModeler/BuildDatabase \
 -name ${ACCESSION}_concoct \
  redundans_${ACCESSION}_NX_concoct/scaffolds_filled_sorted.fa

## add dirs to @INC
export PERL5LIB=${PERL5LIB}:home/perl5/lib/perl5:home/anaconda3/envs/RepeatModeler/lib/perl5/site_perl/5.32.0/x86_64-linux/:home/anaconda3/envs/RepeatModeler/lib/perl5/site_perl/5.32.0:home/anaconda3/envs/RepeatModeler/lib/perl5/5.32.0/x86_64-linux:home/anaconda3/envs/RepeatModeler/lib/perl5/5.32.0
## check @INC
perl -V

#run repeatmodeller
RepeatModeler/RepeatModeler \
 -database ${ACCESSION}_concoct \
 -pa 1 -LTRStruct >& ${ACCESSION}_concoct.out

conda deactivate
