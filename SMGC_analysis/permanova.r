###################################################
# Code to run BGC clustering analysis             #
# with NEW macrogen genomes (45 taxa)             #
# does PCoA, Mantel test and PERMANOVA            #
# Author: Theo Llewellyn                          #
###################################################

library(EcoSimR)
library(vegan)
library(permute)
library(ape)
library(tidyr)
library(dplyr)
library(readr)
library(tibble)
library(phylobase)
library(adephylo)
library(phytools)
library(picante)

setwd("~/The Royal Botanic Gardens, Kew/Teloschistales - Documents/0_THEO_LLEWELLYN_PHD/03_RESULTS")

#load in data
bgcs <- read.table("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Network_Annotations_Full.tsv", sep = "\t", header = TRUE, fill  = TRUE)

#remove the MIBiG clusters
bgcs %>% filter(!grepl('BGC', BGC)) -> filtered_bgcs

#edit the Taxon names to be more reader friendly
filtered_bgcs <- mutate(filtered_bgcs, Description=recode(Description, 
                                                          "Al_sar"="Alectoria sarmentosa",
                                                          "Cl_mac" = "Cladonia macilenta",
                                                          "Cl_met" = "Cladonia metacorallifera",
                                                          "Cl_rang" = "Cladonia rangiferina",
                                                          "Cl_unc" = "Cladonia uncialis",
                                                          "Clagr" = "Cladonia grayii",
                                                          "Cy_ast" = "Cyanodermella asteris",
                                                          "E_pru" = "Evernia prunastri",
                                                          "La_pus" = "Lasallia pustulata",
                                                          "Las_his" = "Lasallia hispanica",
                                                          "Le_col" = "Letharia columbiana",
                                                          "Le_lup" = "Letharia lupina",
                                                          "Ps_fur" = "Pseudevernia furfuracea",
                                                          "Ra_int" = "Ramalina intermedia",
                                                          "Ram_per" = "Ramalina peruviana",
                                                          "Niorma chrysophthalma" = "Teloschistes chrysophthalmus",
                                                          "Teloschistes villosus" = "Seirophora villosa",
                                                          "Teloschistes sp. TBL-2021a" = "Teloschistes peruviana",
                                                          "Umbmu" = "Umbilicaria muehlenbergii",
                                                          "Us_hak" = "Usnea hakonensis",
                                                          "Usnflo" = "Usnea florida",
                                                          "Xanthoria sp" = "Xanthoria sp.",
                                                          "Xanpa" = "Xanthoria parietina",
                                                          "Caloplaca aegaea" = "Caloplaca aegea",
                                                          "Usnochroma carphineum" = "Usnochroma carphinea")) 

#load in data
pks1_clusters <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKSI_clustering_c0.46.tsv")
nrps_clusters <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/NRPS_clustering_c0.46.tsv")
pks_nrp_hybrids <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKS-NRP_Hybrids_clustering_c0.46.tsv")
pks_other_clusters <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKSother_clustering_c0.46.tsv")
Terpene_clusters <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Terpene_clustering_c0.46.tsv")
Other_clusters <- read_tsv("BIGSCAPE/BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Others_clustering_c0.46.tsv")

#change colname
pks1_clusters <- rename(pks1_clusters, BGC = `#BGC Name`, Family.Number = `Family Number`)
nrps_clusters <- rename(nrps_clusters, BGC = `#BGC Name`, Family.Number = `Family Number`)
pks_nrp_hybrids <- rename(pks_nrp_hybrids, BGC = `#BGC Name`, Family.Number = `Family Number`)
pks_other_clusters <- rename(pks_other_clusters, BGC = `#BGC Name`, Family.Number = `Family Number`)
Terpene_clusters <- rename(Terpene_clusters, BGC = `#BGC Name`, Family.Number = `Family Number`)
Other_clusters <- rename(Other_clusters, BGC = `#BGC Name`, Family.Number = `Family Number`)

table_list <- list(pks1_clusters, nrps_clusters, pks_nrp_hybrids, pks_other_clusters, Terpene_clusters, Other_clusters)

#detach plyr after so it doesnt interfere with dplyr
library(plyr)
all_bgc_clusters <- join_all(table_list, type = "full")
detach("package:plyr", unload = TRUE)

#link tbls by BGC column, the nrows drops as it removes any clusters from MiBig
all_bgcs_linked <- inner_join(x = all_bgc_clusters, y = filtered_bgcs)

#make into dissimilarity matrix
all_bgcs_linked[,c(2,4)] %>% add_column(presence = 1) %>% 
  pivot_wider(names_from = Family.Number,
              values_from = presence,
              values_fn = list(presence = mean),
              values_fill = 0) %>%
  column_to_rownames(var="Description") -> presence_absence


#read tree
iqtree <- read.tree("PHYLOGENOMICS/IQTree_Leca45T_75p_round2/concord_Leca45T_tAl_concat.renamed.rooted.tree")

#edit tip labels to match matrix
iqtree$tip.label <- c("Cyanodermella asteris","Diploschistes diacapsis","Lasallia pustulata","Lasallia hispanica","Umbilicaria vellea","Umbilicaria muehlenbergii","Caloplaca aegea","Variospora aurantia","Seirophora lacunosa","Seirophora lacunosa_2", "Seirophora villosa","Caloplaca aetnensis","Caloplaca ligustica","Usnochroma carphinea","Gyalolechia ehrenbergii","Gyalolechia flavorubescens","Letrouitia leprolyta","Flavoplaca oasis","Rusavskia elegans","Xanthoria sp.","Xanthoria sp_2","Xanthoria aureola","Xanthoria mediterranea","Xanthoria steineri","Xanthoria parietina","Xanthomendoza fulva","Teloschistes chrysophthalmus","Teloschistes peruviana","Teloschistes flavicans","Letrouitia transgressa_93","Letrouitia transgressa_94","Ramalina intermedia","Ramalina peruviana","Cladonia macilenta","Cladonia metacorallifera","Cladonia rangiferina","Cladonia uncialis","Cladonia grayii","Usnea hakonensis","Usnea florida","Alectoria sarmentosa","Evernia prunastri","Pseudevernia furfuracea","Letharia columbiana","Letharia lupina")

presence_absence_ordered <- match.phylo.data(iqtree, presence_absence)
presence_absence_ordered_df <- presence_absence_ordered$data

#convert BGC matrix to distance
bgcf_dist <- vegdist(presence_absence_ordered_df, method = "jaccard")
distMatrix <- as.data.frame(as.matrix(bgcf_dist))

#read in the metadata.csv file from the python script
PC_data <- read.csv("BGCF-presenceabsence/metadata.csv")
perm <- adonis2(distMatrix~PC1+PC2, data = PC_data, permutations = 9999)
perm
