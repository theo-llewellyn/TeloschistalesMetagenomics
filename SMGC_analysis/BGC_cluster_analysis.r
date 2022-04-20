###################################################
# Code to run BGC clustering analysis             #
# with NEW macrogen genomes (45 taxa)             #
# Author: Theo Llewellyn                          #
###################################################

library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(tibble)
library(vegan)
library(fpc)
library(cluster)
library(factoextra)


#load in data
bgcs <- read.table("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Network_Annotations_Full.tsv", sep = "\t", header = TRUE, fill  = TRUE)

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
                                                          "Xanthoria sp_2" = "Xanthoria sp. (2)",
                                                          "Xanpa" = "Xanthoria parietina",
                                                          "Caloplaca aegaea" = "Caloplaca aegea",
                                                          "Usnochroma carphineum" = "Usnochroma carphinea")) 

#load in data
pks1_clusters <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKSI_clustering_c0.46.tsv")
nrps_clusters <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/NRPS_clustering_c0.46.tsv")
pks_nrp_hybrids <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKS-NRP_Hybrids_clustering_c0.46.tsv")
pks_other_clusters <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/PKSother_clustering_c0.46.tsv")
Terpene_clusters <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Terpene_clustering_c0.46.tsv")
Other_clusters <- read_tsv("BigScape_c0.42_.48_clansoff_Leca45T_round2_output/Others_clustering_c0.46.tsv")

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

#option 2 with taxa as first col all bgcs
all_bgcs_linked[,c(2,4)] %>% add_column(presence = 1) %>% 
  pivot_wider(names_from = Family.Number,
              values_from = presence,
              values_fn = list(presence = mean),
              values_fill = 0) %>%
  column_to_rownames(var="Description") %>%
  vegdist(method = "jaccard") -> pam_data


#pam analysis on distance matrix, set k to number of orders (5) or families (8)
pam_results <- pam(pam_data, k = 5, diss = TRUE)
pam_results$data = pam_data
#plot clusters
pdf("BGC_Leca45T_pam_2022.pdf", height = 8.3, width = 8.3)
fviz_cluster(pam_results, repel = TRUE) +
  guides(fill = guide_legend(title = "cluster", override.aes = aes(label = "")))
dev.off()



##### VEGAN PCoA
all_bgcs_linked[,c(2,4)] %>% add_column(presence = 1) %>% 
  pivot_wider(names_from = Family.Number,
              values_from = presence,
              values_fn = list(presence = mean),
              values_fill = 0) %>%
  column_to_rownames(var="Description") -> dissimilarity_input

pco1 <- wcmdscale(vegdist(dissimilarity_input), eig = TRUE)
round(eigenvals(pco1),3)

#with transformation
pco2 <- wcmdscale(vegdist(dissimilarity_input), eig = TRUE, add = "lingoes")
round(eigenvals(pco2),3)


families <- as.factor(c("Parmeliaceae","Parmeliaceae","Parmeliaceae","Parmeliaceae","Letrouitiaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Umbilicariaceae","Umbilicariaceae","Cladoniaceae","Cladoniaceae","Cladoniaceae","Cladoniaceae","Cladoniaceae","Teloschistaceae","Teloschistaceae","Ramalinaceae","Ramalinaceae", "Umbilicariaceae","Parmeliaceae","Letrouitiaceae","Letrouitiaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Graphidaceae","Teloschistaceae","Stictidaceae","Parmeliaceae","Parmeliaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Teloschistaceae","Umbilicariaceae"))
col_vec <- c("#5d6941","black","#d99627","#96adcb","#d1d7b3","pink","#a74207", "#666f6e")
cols <- col_vec[families]
lvl <- levels(families)

orders <- as.factor(c("Lecanorales","Lecanorales","Lecanorales","Lecanorales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Umbilicariales","Umbilicariales","Lecanorales","Lecanorales","Lecanorales","Lecanorales","Lecanorales","Teloschistales","Teloschistales","Lecanorales","Lecanorales", "Umbilicariales","Lecanorales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Ostropales","Teloschistales","Ostropales","Lecanorales","Lecanorales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Teloschistales","Umbilicariales"))

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

png("FIGURES/BGC_Leca45T_PCoA_wEllipse_2022.png", res = 300, width = 2000, height = 2000)
PCoA_plot
dev.off()
