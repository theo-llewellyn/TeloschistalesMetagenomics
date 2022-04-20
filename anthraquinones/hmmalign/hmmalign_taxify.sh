#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=8:mem=96gb

module load anaconda3/personal
source activate EukCC-env

cd $PBS_O_WORKDIR

#add these to path so it finds all the right stuff
export PATH=home/software/eukcc/gmes_linux_64:home/software/perl-5.16.3/bin:home/anaconda3/envs/EukCC-env/bin/fastaqual_select.pl:$PATH
export PERL5LIB=${PERL5LIB}:home/perl5/lib/perl5:home/software/perl-5.16.3/bin

~/scripts/taxify_uniprot_treefile.pl \
 -i hmmalign_KS_PT_OG_Liu/IQTREE_OG_Liu_PT/hmmsearch-easy.KS_PT_OG_Liu.hmmalign.clustal.treefile \
 -p hmmalign/ \
 -s speclist.txt \ # https://www.uniprot.org/docs/speclist
 -t uniref90.fasta.taxlist

conda deactivate
