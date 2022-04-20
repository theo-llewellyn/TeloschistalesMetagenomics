#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=16:mem=62gb

module load bbmap

cd $PBS_O_WORKDIR

bbmap.sh \
 nodisk=t \
 ref=ASSEMBLY.fasta \
 in1=ACCESSION_Trimmed_1P.fq.gz \
 in2=ACCESSION_Trimmed_2P.fq.gz \
 threads=16 \
 outm=ACCESSION.sam.gz \
 covstats=ACCESSION.sam.covstats \
 covhist=ACCESSION.sam.covhist

#generate covfile for blobtools
perl -lane 'BEGIN{print "# contig_id\tread_cov\tbase_cov"}if(/#/){next}else{$reads=($F[6]+$F[7]);print join("\t",$F[0],$reads,$F[1])}' ACCESSION.sam.covstats > ACCESSION.sam.cov
