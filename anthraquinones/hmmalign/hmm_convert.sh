#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=32:mem=96gb

module load hmmer

cd $PBS_O_WORKDIR

hmmbuild Pfam_output.out Pfam_seed.txt
