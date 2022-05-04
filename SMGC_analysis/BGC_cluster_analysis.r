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

##### PCoA
pco1 <- wcmdscale(vegdist(presence_absence_ordered_df, method = "jaccard"), eig = TRUE)
round(eigenvals(pco1),3)

orders <- as.factor(c(rep("Ostropales",2),rep("Umbilicariales",4),rep("Teloschistales",25),rep("Lecanorales",14)))

col_vec1 <- c("#96adcb","pink","#d99627", "#666f6e")
cols1 <- col_vec1[orders]
lvl1 <- levels(orders)

set.seed(2308)
#plot just points
pdf("FIGURES/BGC_Leca45T_PCoA_wEllipse_2022.pdf", height = 5.5, width = 5.5)
par(mar = c(4, 4, 1, 1)) 
plot(pco1$points, type = "n",
     scaling = "symmetric",
     display = "sites",
     xlim=c(-.4,.4),
     ylim=c(-.55,.4),
     xlab = "PCoA axis 1",
     ylab = "PCoA axis 2")
abline(h = 0, v = 0, lty = 2)


points(pco1$points,
       scaling = "symmetric",
       display = "sites",
       pch = 19,
       col = cols1)
#draw elipse
ordiellipse(pco1$points, groups = orders,
            kind = "ehull", col = col_vec1,
            scaling = "symmetric", lwd = 2, lty = 2)

legend("topleft", legend = lvl1,
       bty = "n",
       col = col_vec1,
       lty = 1,
       lwd = 2,
       pch = 19)
PCoA_plot <- recordPlot()
plot.new()
PCoA_plot

dev.off()

##### MANTEL TEST
#convert BGC matrix to distance
bgcf_dist <- vegdist(presence_absence_ordered_df, method = "jaccard")
distMatrix <- as.data.frame(as.matrix(bgcf_dist))

#convert tree to phylogenetic distance matrix
phylo_dist <- cophenetic.phylo(iqtree)

#run mantel test
mantel_test <- mantel(phylo_dist, bgcf_dist)
mantel_test

#### PERMANOVA

#prepare input for python script
presence_absence_ordered_df$genome <- rownames(presence_absence_ordered_df)
presence_absence_ordered_df$genome <- gsub(" ", "_", presence_absence_ordered_df$genome)
presence_absence_ordered_df$lifestyle <- as.factor(c(rep("Ostropales",2),rep("Umbilicariales",4),rep("Teloschistales",25),rep("Lecanorales",14)))
presence_absence_ordered_df <- tibble(presence_absence_ordered_df) %>% dplyr::select(genome, lifestyle, everything())
write.csv(presence_absence_ordered_df, "BGCF-presenceabsence.csv", row.names=FALSE, quote=FALSE)
write.tree(iqtree, "concord_Leca45T_tAl_concat.renamed.rooted.tre")
