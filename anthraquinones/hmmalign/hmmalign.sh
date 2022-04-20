#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load anaconda3/personal
source activate EukCC-env

cd $PBS_O_WORKDIR

#add these to path so it finds all the right stuff
export PATH=home/software/eukcc/gmes_linux_64:home/software/perl-5.16.3/bin:home/anaconda3/envs/EukCC-env/bin/fastaqual_select.pl:$PATH
export PERL5LIB=${PERL5LIB}:home/perl5/lib/perl5:home/software/perl-5.16.3/bin

/rds/general/user/tbl19/home/scripts/hmmsearch-easy.pl \
 -q PF14765_hmm.out \
 -d OG_anth_Liu_PF14765.out \
 -a PF14765_seed.txt \
 -p 'hmmsearch-easy.KS_PT_OG_Liu'

conda deactivate
