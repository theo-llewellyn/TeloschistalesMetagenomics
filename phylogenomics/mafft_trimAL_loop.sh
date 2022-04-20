#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=8:mem=96gb

module load mafft/7.271 trimal

cd Results_Leca45T/Single_Copy_Orthologues_75percent
mkdir Leca45T_75p_msa

for i in *.fa
do
ORTHOGROUP=${i%%.fa}
mafft --auto $i > Leca45T_75p_msa/${ORTHOGROUP}_msa.fa
done


cd Leca45T_75p_msa

for i in *.fa
do 
ORTHGROUP=${i%%.fa}
trimal -in $i -out ${ORTHGROUP}_tAl.fa -fasta -automated1
done
