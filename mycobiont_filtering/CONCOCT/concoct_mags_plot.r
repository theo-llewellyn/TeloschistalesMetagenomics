###################################################
# Code to plot CONCOCT metagenome results         #
# scatterplots coloured by MAG                    #
# Author: Theo Llewellyn                          #
###################################################

library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(colorspace)
library(ggrepel)
library(cowplot)

#read in data and rename column headers to be able to merge
bins <- read_csv("ACCESSION_clustering_merged.csv", col_types = cols(contig_id = col_character(), cluster_id = col_character()))
colnames(bins) <- c("contig_id", "metagenome_bin")
gc_cov <- read_table("ACCESSION_cov.txt")
colnames(gc_cov) <- c("contig_id", "gc", "coverage","TaxID")

#change all bacteria phyla to Bacteria
gc_cov$TaxID <- gsub(".*acter.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Firmicutes","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub(".*laeota","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub(".*maeota","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Candidatus","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Chloroflexi","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Gemma.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Nitro.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Plancto.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Spiro.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Thermo.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Verru.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Armat.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Dein.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Bacill.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Api.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Calditr.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Teneri.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Aqui.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Evosea.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Chlorobi*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Dictyoglomi","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Lenti.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Bacill.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Elusi.*","Bacteria", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Syner.*","Bacteria", gc_cov$TaxID)
#change minimal things to Other
gc_cov$TaxID <- gsub("Arthropoda","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Mucoromycota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Basidiomycota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Streptophyta","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Chordata","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Arch.*","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("candidate","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub(".*archaeota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("unresolved","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Platyhelminthes","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Eukaryota-undef","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Chytridiomycota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Echinodermata","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Rhodophyta","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Nematoda","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Chlamydiae","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Zoopagomycota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Porifera","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Mollusca","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Cnidaria","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Viruses.*","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Cryptomycota","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Ciliophora","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Discosea","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Endomyxa","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Rotifera","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Priapulida","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Heterolobosea","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Foraminifera","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Tardigrada","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Euglenozoa","Other", gc_cov$TaxID)
gc_cov$TaxID <- gsub("Microsporidia","Other", gc_cov$TaxID)

gc_cov$TaxID <- gsub("undef","Ascomycota", gc_cov$TaxID)

unique(gc_cov$TaxID)

#link tbls by contig
linked_contigs <- inner_join(x = bins, y = gc_cov)

#make a df with the names of each bin placed at the mean values for that bin so it sits in the middle of the cloud of points on the plot
label.df_2 <- linked_contigs %>% 
  group_by(metagenome_bin) %>% 
  summarize(gc = mean(gc), coverage = mean(coverage))

#make scatterplot of all contigs with GC content and coverage, coloured by MAG
plot_a <- ggplot(linked_contigs, aes(colour = metagenome_bin, x = gc, y = log(coverage))) +
  geom_point() +
  scale_color_discrete_qualitative(palette = "Set 2") +
  geom_label_repel(data = label.df_2, aes(label = metagenome_bin, x = gc, y = log(coverage)), show.legend = FALSE) +
  theme(legend.position = "none") +
  xlab("GC content")

#same as plot A but each MAG as a facet
plot_b <- ggplot(linked_contigs, aes(colour = metagenome_bin, x = gc, y = log(coverage))) +
  geom_point() +
  scale_color_discrete_qualitative(palette = "Set 2") +
  gghighlight::gghighlight() + 
  facet_wrap(vars(metagenome_bin)) +
  #theme(aspect.ratio = 1) +
  xlab("GC content")

#combine the plots into a multiplot figure and save as pdf
jpeg("ACCESSION_concoct_bins_multiplot.jpg", height = 5.85, width = 11.7, units = "in", res = 300)
plot_grid(plot_a, plot_b,
          labels = c('(a)', '(b)'),
          align = "h",
          nrow = 1)
dev.off()


#make scatterplot of all contigs with GC content and coverage, coloured by TaxID
plot_c <- ggplot(linked_contigs, aes(colour = TaxID, x = gc, y = log(coverage))) +
  geom_point() +
  scale_color_discrete_qualitative(palette = "Set 2") +
  xlab("GC content")

#same as plot A but each MAG as a facet and coloured by TaxID
plot_d <- ggplot(linked_contigs, aes(colour = TaxID, x = gc, y = log(coverage))) +
  geom_point() +
  scale_color_discrete_qualitative(palette = "Set 2") +
  gghighlight::gghighlight() + 
  facet_wrap(vars(metagenome_bin)) +
  #theme(aspect.ratio = 1) +
  xlab("GC content")

jpeg("ACCESSION_concoct_bins_bars.jpg", height = 5.85, width = 11.7, units = "in", res = 300)
ggplot(linked_contigs, aes(x = TaxID, fill = TaxID)) + 
  geom_bar() + 
  theme(axis.text.x = element_text(angle = 45),
        axis.text.y = element_blank(),
        axis.title = element_blank()) +
  facet_wrap(vars(metagenome_bin), scales = "free_y")
dev.off()

jpeg("ACCESSION_concoct_bins_multiplot2.jpg", height = 5.85, width = 11.7, units = "in", res = 300)
plot_grid(plot_a, plot_d,
          labels = c('(a)', '(b)'),
          align = "h",
          nrow = 1)
dev.off()

jpeg("ACCESSION_concoct_bins_multiplot3.jpg", height = 5.85, width = 11.7, units = "in", res = 300)
plot_grid(plot_c, plot_d,
          labels = c('(a)', '(b)'),
          align = "h",
          nrow = 1)
dev.off()

