### Calculating SR, PD and PE using phyloraster
## R version 4.3.2
## Gabriela Alves-Ferreira (gabriela-alves77@hotmail.com)

# setwd("/media/gabriela/6416C77F16C7512A/Documentos/Doutorado_models_new_SSP")
library(phyloraster)
library(terra)
library(ape)

# rasters with overprediction removal
setwd("D:/Doutorado_new_models_dez_2023/resus/removed_overprediction")
list.files()

# present
mods.pres.bufo <- rast("mods.bi.pres.rm.overpred.iucn.Bufoninae.tif")
mods.pres.hyli <- rast("mods.bi.pres.rm.overpred.iucn.hylidae.tif")

# future optimistic
mods.fut.oti.bufo <- rast("mods.fut.oti.10pt.rm.overpred.iucn.Bufoninae.tif")
mods.fut.oti.hyli <- rast("mods.bi.fut.oti.10pt.rm.overpred.iucn.hylidae.tif")

# future pessimistic
mods.fut.pess.bufo <- rast("mods.fut.pess.10pt.rm.overpred.iucn.Bufoninae.tif")
mods.fut.pess.hyli <- rast("mods.bi.fut.pess.10pt.rm.overpred.iucn.Hylidae.tif")

# join rasters
mods.pres.all <- c(mods.pres.hyli, mods.pres.bufo)
mods.fut.pess.all <- c(mods.fut.pess.hyli, mods.fut.pess.bufo)
mods.fut.oti.all <- c(mods.fut.oti.hyli, mods.fut.oti.bufo)

## Loading a phylogenetic tree to calculate the other metrics
# tree <- read.nexus("D:/Doutorado_UESC/Projeto/Modelagens/phylogenetic_tree/tree_consenso_10000_mcc.nexus")
# setdiff(names(mods.pres.all), tree1$tip.label)

# new tree Portik et al 2023
tree <- read.tree("D:/Doutorado_UESC/Projeto/Modelagens/phylogenetic_tree_2023/TreePL-Rooted_Anura_bestTree.tre")
setdiff(names(mods.pres.all), tree2$tip.label)

## Running metrics of phylogenetic diversity and phylogenetic endemism
# baseline
data.prep <- phylo.pres(mods.pres.all, tree, full_tree_metr = TRUE)
data.pres.prep$branch.length

sr.pres <- rast.sr(data.prep$x)
pd.pres <- rast.pd(data.prep$x, data.prep$tree)
pe.pres <- rast.pe(data.prep$x, data.prep$tree)
# 11:51 initiate
# 1:15 finish

# future SSP 45
data.fut.oti.prep <- phylo.pres(mods.fut.oti.all, tree)
sr.fut.ot <- rast.sr(data.fut.oti.prep$x)
pd.fut.ot <- rast.pd(data.fut.oti.prep$x, data.fut.oti.prep$tree)
pe.fut.ot <- rast.pe(data.fut.oti.prep$x, data.fut.oti.prep$tree) # nao rodou ainda
# 16:57
# 17:30

# future SSP 85
data.fut.pess.prep <- phylo.pres(mods.fut.pess.all, tree)
sr.fut.pess <- rast.sr(data.fut.pess.prep$x)
pd.fut.pess <- rast.pd(data.fut.pess.prep$x, data.fut.pess.prep$tree)
pe.fut.pess <- rast.pe(data.fut.pess.prep$x, data.fut.pess.prep$tree)

div <- c(sr.pres, 
         sr.fut.ot,
         sr.fut.pess,
         pd.pres,
         pd.fut.ot,
         pd.fut.pess,
         pe.pres,
         pe.fut.ot,
         pe.fut.pess)

plot(div)

names(div) <- c("rich.pres", 
                "rich.fut.oti",
                "rich.fut.pess",
                "pd.pres",
                "pd.fut.ot",
                "pd.fut.pess",
                "pe.pres",
                "pe.fut.ot",
                "pe.fut.pess")

writeRaster(div, "D:/Doutorado_new_models_dez_2023/resus/div_metrics/diversity_metrics_allspecies_Portik2023_iucn.tif",
            overwrite=T)

#################
# delta richness
library(phyloraster)
delta_45 <- delta.grid(div$rich.pres, div$rich.fut.oti)
plot(delta_45)

delta_85 <- delta.grid(div$rich.pres, div$rich.fut.pess)
plot(delta_85)

## Delta PD
deltapd45 <- delta.grid(div$pd.pres, div$pd.fut.ot)
deltapd85 <- delta.grid(div$pd.pres, div$pd.fut.pess)

## Delta PE
deltape45 <- delta.grid(div$pe.pres, div$pe.fut.ot)
deltape85 <- delta.grid(div$pe.pres, div$pe.fut.pess)

## saving 
delta <- c(delta_45, delta_85,
           deltapd45, deltapd85,
           deltape45, deltape85)
names(delta) <- c("deltasr45", "deltasr85",
           "deltapd45", "deltapd85",
           "deltape45", "deltape85")
writeRaster(delta, "D:/Doutorado_new_models_dez_2023/resus/div_metrics/delta_metrics_allspecies_Portik2023_iucn.tif",
            overwrite=TRUE)
