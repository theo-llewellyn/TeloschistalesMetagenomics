#rename ncbi headers in CDS files
for i in *fa; do PREFIX=${i%%.cds*}; sed -i "s/FUN/${PREFIX}/" $i; done

#rename JGI headers in CDS files
cat Usnflo1_GeneCatalog_CDS_20160419.fasta | awk '/^>/{print ">Usnea_florida_prot" ++i; next}{print}' > Usnflo1_cds-transcripts_renamed.fa

#copy all CDS to new directory and cat into a single file
cat *cds* > Leca45T_CDS_all.fa

#take the headers of the guidance2 filtered alignment
grep '>' MSA.MAFFT.aln.With_Names > OG12_guidance_headers.txt
 #loop through protein headers
 LINES=$(cat OG12_guidance_headers.txt)
 #same but just saving one file
  for LINE in $LINES
   do
    #get the fasta header and any sequence until the next fasta then remove the final line and change header to just species name. This is saved to a separate file for each genome
    sed -n -e "/$LINE/,/>/p" Leca45T_CDS_all.fa | sed '1b;/>.*/d' | sed "s/>.*/${LINE}/" >> OG12_guidance_CDS.fa
  done
done
