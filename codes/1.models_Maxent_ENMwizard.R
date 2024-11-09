########################################################################
############ SDMs using MAXENT and ENMwizard ###########
# Rversion = 4.3.2 
# Gabriela Alves Ferreira (gabriela-alves77@hotmail.com)

## Run the following code from your R console:
library(devtools)
library(usethis)
# devtools::install_github("HemingNM/ENMwizard")
#install_github("raster", force= TRUE)
#detach("package:ENMeval", unload=TRUE)
# install_version("ENMeval", version = "0.3.1")
library(ENMeval)
library(ENMwizard)
library(dismo)
library(rgdal)
library(raster)
library(rgeos)
library(spThin)
library(rJava)

## Directory
setwd("/media/gabriela/Gabi_HD/Doutorado_new_models_dez_2023")
list.files()

## We can also make a list for multiple species, using the following function.
spp <- read.csv("/media/gabriela/HDD/Documents/Doutorado_UESC/Projeto/Modelagens/Occs_to_model/spps_occ_env_thin_f.csv", head = T, sep = ",")

## Make it a list
spp.occ.list <- lapply(unique(spp$sp), function(i, x){
  x[x$sp==i,c("long", "lat")]
}, x=spp)
names(spp.occ.list) <- unique(spp$sp)
names(spp.occ.list) 
View(data.frame(names(spp.occ.list)))
head(spp.occ.list)

## Create occ polygon to crop rasters prior to modelling.
x11()
par(mfrow = c(3,3))
occ.polys <- set_calibarea_b(spp.occ.list)

## Create buffer
##... and the occurrence polygons are buffered using 1.5 degrees.
occ.b <- buffer_b(occ.polys, width = 1.5)


## Get and cut enviromental layers

## path with data for present
filePath2 <- "/media/gabriela/Gabi_HD/shapes_rasters/rasters/wc2.1_2.5m_bio/" # path to the dataset folder

## import all files in a single folder as a list
vars <- list.files(path = filePath2, pattern='.tif',
                   all.files=TRUE)

current <- stack(paste0(filePath2, vars))
names(current) 
names(current) <- sub(".*[_$]", "bio_", names(current))
names(current) 
plot(current)

## Cut environmental variables for each species (and plot them for visual inspection).
pred.cut <- cut_calibarea_b(occ.b, current)

## plot them for visual inspection
# dev.off()
# windows()
# par(mfrow=c(2,3))
# for(i in 1:length(pred.cut)){
#   plot(pred.cut[[i]])
#   #plot(occ.polys[[i]], border = "red", add = T)
#   #plot(occ.b[[i]], add = T)
# }


## Select the least correlated variables.
x11()
# vars <- select_vars_b(pred.cut, cutoff=.75, names.only = T)

## See selected variables for each species.
#lapply(vars, function(x)x[[1]])

## Remove correlated variables from our variable set.
pred.cut <- select_vars_b(pred.cut, cutoff=.75, names.only = F)

#####################################################
## Great! Now we are ready for tunning species' ENMs
#####################################################

## Model tuning using ENMeval
## Here we will run ENMevaluate_b to call ENMevaluate (from ENMeval package). 

## Here we will test which combination of Feature Classes and 
## Regularization Multipliers give the best results. 
## For this, we will partition our occurrence data using the "block" method.

## By providing [at least] two lists, occurrence and environmental data, 
## we will be able to evaluate ENMs for as many species as listed in our occ.locs object. 
## For details see ?ENMeval::ENMevaluate. Notice that you can use multiple cores for this task. 
## This is specially usefull when there are a large number of models and species.

## method based on the number of occs: jackknife: 15 occs, block more than 15
# method <- ifelse(sapply(spp.occ.list, nrow) <= 15, "jackknife", "block")
cbind(names(spp.occ.list), names(pred.cut), method)
names(spp.occ.list[87:89]) == names(method[87:89])
names(spp.occ.list) == names(pred.cut)


ENMeval.res.lst <- ENMevaluate_b(spp.occ.list, pred.cut, 
                                 RMvalues = seq(0.5, 5, 0.5),
                                 fc = c("L", "P", "Q", "LP", "LQ", 
                                        "PQ", "LPQ"),
                                 method="block", algorithm="maxent.jar", 
                                 numCores =8 , parallel = T)

saveRDS(ENMeval.res.lst, "ENMeval.res.lst.rds")
rm(ENMeval.res.lst)


# ## Model fitting (calibration)
# ## After tuning MaxEnt models, we will calibrate them using all occurrence data.
# ## (i.e. without partition them).
# ## Run model

cbind(names(spp.occ.list) == names(ENMeval.res.lst))

mxnt.mdls.preds.lst <- calib_mdl_b(ENMeval.o.l = ENMeval.res.lst, 
                                   a.calib.l = pred.cut, 
                                   occ.l = spp.occ.list, 
                                   mSel = c("EBPM"))
rm(ENMeval.res.lst)

saveRDS(mxnt.mdls.preds.lst, "mxnt_mdls_preds_list.rds")

## Projection
## Prepare projecion area
## Download environmental data
library(raster)

## Get data for present
##SSP##
#Read data for future projection (2050)

r_CNRM_45 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_CNRM-CM6-1_ssp245_2041-2060.tif", format="GTiff")
r_CNRM_85 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_CNRM-CM6-1_ssp585_2041-2060.tif", format="GTiff")

r_MIROC_45 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_MIROC6_ssp245_2041-2060.tif", format="GTiff")
r_MIROC_85 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_MIROC6_ssp585_2041-2060.tif", format="GTiff")

r_MRI_45 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_MRI-ESM2-0_ssp245_2041-2060.tif", format="GTiff")
r_MRI_85 <- brick("/media/gabriela/Gabi_HD/shapes_rasters/rasters/ssp_worldclim/wc2.1_2.5m_bioc_MRI-ESM2-0_ssp585_2041-2060.tif", format="GTiff")

#projeção dos rasters
proj4string(r_MRI_45) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados
proj4string(r_MRI_85) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados

proj4string(r_MIROC_45) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados
proj4string(r_MIROC_85) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados

proj4string(r_CNRM_45) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados
proj4string(r_CNRM_85) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados

## names
names(r_MRI_45) <- sub(".*[_$]", "bio_", names(r_MRI_45))
names(r_MRI_85) <- sub(".*[_$]", "bio_", names(r_MRI_85))

names(r_MIROC_45) <- sub(".*[_$]", "bio_", names(r_MIROC_45))
names(r_MIROC_85) <- sub(".*[_$]", "bio_", names(r_MIROC_85))

names(r_CNRM_45) <- sub(".*[_$]", "bio_", names(r_CNRM_45))
names(r_CNRM_85) <- sub(".*[_$]", "bio_", names(r_CNRM_85))

predictors.l <- list(current = current,
                     r_MRI_SSP_45 = r_MRI_45,
                     r_MRI_SSP_85 = r_MRI_85,
                     r_MIROC_SSP_45 = r_MIROC_45,
                     r_MIROC_SSP_85 = r_MIROC_85,
                     r_CNRM_SSP_45 = r_CNRM_45,
                     r_CNRM_SSP_85 = r_CNRM_85)

## Check the layers names
lapply(predictors.l, names)

## Preparing projecion area
## Select area for projection based on a extent object or a polygon
neotropic <- rgdal::readOGR("/media/gabriela/Gabi_HD/shapes_rasters/shapes/neotropic/Neotropic_Lowenberg_Neto_2014.shp")  # salvar? poligonos como um shape
proj4string(neotropic) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")#informando o SRC dos dados
# plot(neotropic)

## Preparing projection area
pa.env.proj.l <- cut_projarea_rst_mscn_b(neotropic, predictors.l, occ.polys, mask = T)

## Model projections

# names matching?
setdiff(names(pa.env.proj.l), names(mxnt.mdls.preds.lst))
cbind(names(pa.env.proj.l)== names(mxnt.mdls.preds.lst))
# around 6 hours running for 25 species

mxnt.mdls.preds.cf <- proj_mdl_b(mxnt.mdls.preds.lst,
                                  a.proj.l = pa.env.proj.l)


saveRDS(mxnt.mdls.preds.cf, "mxnt.mdls.preds.cf_dendropsophini.rds")
names(mxnt.mdls.preds.cf)

# plot projections

x11()
par(mfrow=c(1,3), mar=c(1,2,1,2))
for(i in seq_along(mxnt.mdls.preds.cf)){
  plot(mxnt.mdls.preds.cf[[i]]$mxnt.preds$current, main=names(mxnt.mdls.preds.cf)[i])
  plot(mxnt.mdls.preds.cf[[i]]$mxnt.preds$r_MRI_SSP_45)
  plot(mxnt.mdls.preds.cf[[i]]$mxnt.preds$r_MIROC_SSP_45)
}

## Create consensual projections across GCMs by (e.g.) year and/or RCP
## The climate scenario projections can be grouped and averaged to create consensual projections. 
## Here we downloaded two GCMs for 2050 for SSP45 and SSP85. 

## just in case you have multiple GCMs by year and RCP, this is an example 
## that return more groups

# grouping codes
ssp <- c("SSP_45", "SSP_85")
groups <- list(ssp)

# names of climate scenarios
names(mxnt.mdls.preds.cf[[1]]$mxnt.preds)

clim.scn.nms <- c("current", "r_MRI_SSP_45", "r_MRI_SSP_85", "r_MIROC_SSP_45",
                  "r_MIROC_SSP_85", "r_CNRM_SSP_45", "r_CNRM_SSP_85")

## here we do compute the consensual projections for multiple groups
consensus_gr(groups = list(ssp), clim.scn.nms)

## here we do compute the consensual projections
# around 3 hours running for 106 species
mxnt.mdls.preds.cf_cons <- consensus_scn_b(mcmp.l= mxnt.mdls.preds.cf, 
                                           groups = list(ssp), ref = "current", 
                                           save = T, numCores = 8)
saveRDS(mxnt.mdls.preds.cf_cons, "mxnt.mdls.preds.cf_cons.rds")

# plot projections for multiple species
# par(mfrow=c(1,3))
# for(i in seq_along(mxnt.mdls.preds.cf_cons)){
#   plot(mxnt.mdls.preds.cf_cons[[i]]$mxnt.preds$current, main=names(mxnt.mdls.preds.cf)[i])
#   plot(mxnt.mdls.preds.cf_cons[[i]]$mxnt.preds$r_MRI_SSP_45)
#   plot(mxnt.mdls.preds.cf_cons[[i]]$mxnt.preds$r_MRI_SSP_85)
# }

## Applying thresholds on climatic scenarios
mods.thrshld.lst <- thrshld_b(mxnt.mdls.preds.cf_cons, thrshld.i = c(4,5), numCores = 7)

saveRDS(mods.thrshld.lst, "mods_thrshld_lst.rds")

## Visualize
# plot projections for multiple species
windows()
par(mfrow=c(1,3), mar=c(1,2,1,2))
for(i in seq_along(mods.thrshld.lst)){
  plot(mods.thrshld.lst[[i]]$current$binary$x10ptp)
  plot(mods.thrshld.lst[[i]]$binary$x10ptp, main=names(mods.thrshld.lst)[i])
  plot(mods.thrshld.lst[[i]]$SSP_85$binary$x10ptp)
}

## Compute species' total suitable area
get_tsa_b(mods.thrshld.lst)
