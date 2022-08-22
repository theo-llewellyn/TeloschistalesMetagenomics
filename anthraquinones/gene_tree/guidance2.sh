#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=8:mem=96gb

module load anaconda3/personal prank mafft
source activate metawrap-env

cd $PBS_O_WORKDIR

export PERL5LIB=${PERL5LIB}:/rds/general/user/tbl19/home/anaconda3/envs/metawrap-env/bin/perl:/rds/general/user/tbl19/home/anaconda3/envs/metawrap-env/lib/site_perl/5.26.2/x86_64-linux-thread-multi:/rds/general/user/tbl19/home/anaconda3/envs/metawrap-env/lib/site_perl/5.26.2:/rds/general/user/tbl19/home/anaconda3/envs/metawrap-env/lib/5.26.2/x86_64-linux-thread-multi:/rds/general/user/tbl19/home/anaconda3/envs/metawrap-env/lib/5.26.2

guidance.v2.02/www/Guidance/guidance.pl \
 --seqFile OG0000012.fa \
 --msaProgram MAFFT \
 --seqType aa \
 --outDir OG12_Guidance2_mafft \
 --proc_num 8
