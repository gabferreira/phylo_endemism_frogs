### Null models PD

library(phyloraster)
library(terra) #1.7.8
library(ape)
library(phytools)
library(SESraster)

# directory
setwd("F:/new_SDMs_2024/resus_2024/removed_overprediction")

# loading a phylogenetic tree 
library(ape)
tree1 <- read.nexus("F:/new_SDMs_2024/tree_consenso_10000_mcc.nexus")

# updating the names of the species
tree1$tip.label <- gsub("Scinax_x-signatus", "Scinax_x_signatus", tree1$tip.label)
tree1$tip.label <- gsub("Hypsiboas", "Boana", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_albomarginatus", "Boana_albomarginata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_marginatus", "Boana_marginata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_prasinus", "Boana_prasina", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_semiguttatus", "Boana_semiguttata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_albopunctatus", "Boana_albopunctata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_ornatissimus", "Boana_ornatissima", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_riojanus", "Boana_riojana", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_semilineatus", "Boana_semilineata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_leptolineatus", "Boana_leptolineata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_picturatus", "Boana_picturata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_rubracylus", "Boana_rubracyla", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_punctatus", "Boana_punctata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_calcaratus", "Boana_calcarata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_atlanticus", "Boana_atlantica", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_fasciatus", "Boana_fasciata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_multifasciatus", "Boana_multifasciata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_pulchellus", "Boana_pulchella", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_rufitelus", "Boana_rufitela", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_geographicus", "Boana_geographica", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_ventrimaculatus", "Boana_ventrimaculata", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_polytaenius", "Boana_polytaenia", tree1$tip.label) 
tree1$tip.label <- gsub("Boana_fuentei", "Boana_xerophylla", tree1$tip.label) 
tree1$tip.label <- gsub("Ptychohyla_spinipollex", "Atlantihyla_spinipollex", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_arenicolor", "Dryophytes_arenicolor", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_cinerea", "Dryophytes_cinereus", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_euphorbiacea", "Dryophytes_euphorbiaceus", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_eximia", "Dryophytes_eximius", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_plicata", "Dryophytes_plicatus", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_walkeri", "Dryophytes_walkeri", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_wrightorum", "Dryophytes_wrightorum", tree1$tip.label) 
tree1$tip.label <- gsub("Myersiohyla_kanaima", "Nesorohyla_kanaima", tree1$tip.label) 
tree1$tip.label <- gsub( "Lysapsus_boliviana", "Lysapsus_bolivianus", tree1$tip.label)
tree1$tip.label <- gsub("Pseudacris_regilla", "Pseudacris_hypochondriaca", tree1$tip.label) 
tree1$tip.label <- gsub("Ptychohyla_acrochorda", "Quilticohyla_acrochorda", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_arborescandens", "Sarcohyla_arborescandens", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_bistincta", "Sarcohyla_bistincta", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_celata", "Sarcohyla_celata", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_charadricola", "Sarcohyla_charadricola", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_cyclada", "Sarcohyla_cyclada", tree1$tip.label) 
tree1$tip.label <- gsub("Plectrohyla_hapsa", "Sarcohyla_hapsa", tree1$tip.label)
tree1$tip.label <- gsub("Plectrohyla_pentheter", "Sarcohyla_pentheter", tree1$tip.label) 
tree1$tip.label <- gsub("Scinax_cruentommus", "Scinax_cruentomma", tree1$tip.label) 
tree1$tip.label <- gsub("Ecnomiohyla_tuberculosa", "Tepuihyla_tuberculosa", tree1$tip.label) 
tree1$tip.label <- gsub("Scinax_cruentommus", "Scinax_cruentomma", tree1$tip.label) 
tree1$tip.label <- gsub("Anotheca_spinosa", "Triprion_spinosus", tree1$tip.label) 
tree1$tip.label <- gsub("Diaglena_spatulata", "Triprion_spatulatus", tree1$tip.label) 
tree1$tip.label <- gsub("Hyla_squirella", "Dryophytes_squirellus", tree1$tip.label) 
# c(setdiff(names(mods.pres.all), tree1$tip.label))

## Running null model for PD

###################################################
## Future pessimistic
x_fut <- rast("F:/new_SDMs_2024/resus_2024/removed_overprediction/mods.fut.pess.all.2024.tif")
data.prep <- phylo.pres(x_aggregated, tree1, full_tree_metr = TRUE)

# 12:36
# 13:41 com 69 aleats
library(SESraster)

Sys.time()
# [1] "2024-10-21 14:08:44 -03"
pd.fut.ses <- rast.pd.ses(data.prep$x, edge.path = data.prep$edge.path,
                          branch.length = data.prep$branch.length, aleats = 999,
                          random = "spat", filename = "ses_pd_fut_pess_999_new.tif")
Sys.time()
# [1] "2024-10-21 14:13:24 -03"
beepr::beep(sound = 8)
plot(pd.fut.ses)

###################################################
## Future optimistic
x_fut <- rast("F:/new_SDMs_2024/resus_2024/removed_overprediction/mods.fut.oti.all.2024.tif")
data.prep <- phylo.pres(x_aggregated, tree1, full_tree_metr = TRUE)

# 12:36
# 13:41 com 69 aleats
setwd("F:/new_SDMs_2024/resus_2024/div_metrics")
library(SESraster)

Sys.time()
# [1] "2024-10-24 12:15:32 -03"
pd.fut.ses <- rast.pd.ses(data.prep$x, edge.path = data.prep$edge.path,
                          branch.length = data.prep$branch.length, aleats = 999,
                          random = "spat", filename = "ses_pd_fut_oti_999_new.tif")
Sys.time()
# [1] "2024-10-24 16:22:35 -03"

beepr::beep(sound = 8)
plot(pd.fut.ses)

###################################################
## Present
x_pres <- rast("F:/new_SDMs_2024/resus_2024/removed_overprediction/mods.pres.all.2024.tif")
data.prep <- phylo.pres(x_aggregated, tree1, full_tree_metr = TRUE)

setwd("F:/new_SDMs_2024/resus_2024/div_metrics")
Sys.time()
# [1] "2024-10-22 17:14:57 -03"
pd.pres.ses <- rast.pd.ses(data.prep$x, edge.path = data.prep$edge.path,
                           branch.length = data.prep$branch.length, aleats = 999,
                           random = "spat", filename = "ses_pd_pres_999_new.tif")
Sys.time()
# [1] "2024-10-22 21:16:38 -03"
beepr::beep(sound = 8)
plot(pd.pres.ses)
