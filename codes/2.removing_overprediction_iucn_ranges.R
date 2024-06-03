### Removing the overprediction SDMs
## R version 4.3.2
## Gabriela Alves-Ferreira (gabriela-alves77@hotmail.com)

library(terra)
setwd("D:/Doutorado_new_models_dez_2023/resus")

## Bufonidae ##
{
  # Range IUCN species
  range_iucn_bufo <- vect("D:/Doutorado_new_models_dez_2023/resus/div_metrics/range_iucn_bufo.shp")
  
  plot(range_iucn_bufo[2:6])
  plot(range_iucn_bufo[3])
  plot(range_iucn_bufo[3])
  
  # Group the polygons by species name
  range_iucn_bufo2 <- split(range_iucn_bufo, range_iucn_bufo$sci_name)
  
  # Getting the species name again because the function "split" change the order
  # unique(values(range_iucn_bufo2[[69]])$sci_name)
  sp_names <- character(length = 106)
  for(i in 1:length(range_iucn_bufo2)){
    sp_names[i] <- unique(values(range_iucn_bufo2[[i]])$sci_name)
  }
  sp_names <- gsub(" ", "_", sp_names)
  names(range_iucn_bufo2) <- sp_names
  
  ## Create buffer
  ##... buffer if 3,300 meters- Smith e Green 2005. 
  iucn.b.pres <- list()
  for(i in 1:length(range_iucn_bufo2)) {
    iucn.b.pres[[i]] <- buffer(range_iucn_bufo2[[i]], width = 3300)
  }
  names(iucn.b.pres) <- sp_names
  
  ## for future: each anuran generation have 2.5 years
  ## between 2000 and 2050 we have 50 years = 20 generations
  ## 3.300*20= 66.000 meters
  
  iucn.b.fut <- list()
  for(i in 1:length(range_iucn_bufo2)) {
    iucn.b.fut[[i]] <- buffer(range_iucn_bufo2[[i]], width = 66000)
  }
  names(iucn.b.fut) <- sp_names
  
  # SDMs
  mods.bi.pres <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.pres.Bufoninae.tif")
  mods.bi.fut.pess.10pt <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.pess.10pt.Bufoninae.tif")
  mods.bi.fut.oti.10pt <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.oti10pt.Bufoninae.tif")
  
  x11()
  plot(mods.bi.pres[[1]])
  plot(range_iucn_bufo2[[1]], add = T)
  plot(occ.b.pres[[1]], add = T, col = "red", border = NULL, )
  # plot(occ.b.pres[[1]])
  plot(occ.b.fut[[1]], add = T, col = "purple", border = NULL)
  
  # Cropping SDMs
  # present
  cbind(names(mods.bi.pres), names(iucn.b.pres))
  (names(mods.bi.pres) == names(iucn.b.pres))
  
  mods.pres.crop <- list()
  for(i in 1:nlyr(mods.bi.pres)){
    mods.pres.crop[[i]] <- terra::mask(mods.bi.pres[[i]], iucn.b.pres[[i]], updatevalue = 0)
  }
  
  mods.pres.crop <- rast(mods.pres.crop)
  plot(mods.pres.crop[[106]])
  writeRaster(mods.pres.crop, "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.bi.pres.rm.overpred.iucn.Bufoninae.tif",
              overwrite=TRUE)
  
  # fut pessimistic
  (names(mods.bi.fut.pess.10pt) == names(iucn.b.fut))
  mods.fut.pess.10pt.crop <- list()
  for(i in 1:nlyr(mods.bi.fut.pess.10pt)){
    mods.fut.pess.10pt.crop[[i]] <- terra::mask(mods.bi.fut.pess.10pt[[i]], 
                                                iucn.b.fut[[i]], updatevalue = 0)
  }
  
  mods.fut.pess.10pt.crop <- rast(mods.fut.pess.10pt.crop)
  writeRaster(mods.fut.pess.10pt.crop, "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.fut.pess.10pt.rm.overpred.iucn.Bufoninae.tif",overwrite=TRUE)
  
  # fut optimistic com 10pt
  (names(mods.bi.fut.oti.10pt) == names(iucn.b.fut))
  
  mods.fut.oti.10pt.crop <- list()
  for(i in 1:nlyr(mods.bi.fut.oti.10pt)){
    mods.fut.oti.10pt.crop[[i]] <- terra::mask(mods.bi.fut.oti.10pt[[i]], iucn.b.fut[[i]], updatevalue = 0)
  }
  mods.fut.oti.10pt.crop <- rast(mods.fut.oti.10pt.crop)
  writeRaster(mods.fut.oti.10pt.crop, "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.fut.oti.10pt.rm.overpred.iucn.Bufoninae.tif", overwrite=TRUE)
}

## Hylidae ##
{
  library(terra)
  
  # ranges species IUCN
  range_iucn_hyli <- vect("D:/Doutorado_new_models_dez_2023/resus/div_metrics/range_iucn_hyli.shp")
  plot(range_iucn_hyli[2:6])
  
  # Group the polygons by species name
  range_iucn_hyli2 <- split(range_iucn_hyli, range_iucn_hyli$sci_name)
  
  # Getting the species name again because the function "split" change the order
  # unique(values(range_iucn_bufo2[[69]])$sci_name)
  sp_names <- character(length = 278)
  for(i in 1:length(range_iucn_hyli2)){
    sp_names[i] <- unique(values(range_iucn_hyli2[[i]])$sci_name)
  }
  sp_names <- gsub(" ", "_", sp_names)
  names(range_iucn_hyli2) <- sp_names
  
  ## Create buffer
  ##... 2,300 meters- Smith e Green 2005. 
  iucn.h.pres <- list()
  for(i in 1:length(range_iucn_hyli2)) {
    iucn.h.pres[[i]] <- buffer(range_iucn_hyli2[[i]], width = 2.300)
  }
  names(iucn.h.pres) <- sp_names
  
  # 20*2.300 = 46000 meters
  iucn.h.fut <- list()
  for(i in 1:length(range_iucn_hyli2)) {
    iucn.h.fut[[i]] <- buffer(range_iucn_hyli2[[i]], width = 46000)
  }
  names(iucn.h.fut) <- sp_names
  
  # SDMs
  mods.bi.pres.copho <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.pres.Cophomantini.tif")
  mods.bi.fut.pess.10pt.copho <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.pess.10pt.Cophomantini.tif")
  mods.bi.fut.oti.10pt.copho <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.oti10pt.Cophomantini.tif")
  
  mods.bi.pres.LopHylini <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.pres.LopHylini.tif")
  mods.bi.fut.pess.10pt.LopHylini <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.pess.10pt.LopHylini.tif")
  mods.bi.fut.oti.10pt.LopHylini <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.oti10pt.LopHylini.tif")
  
  mods.bi.pres.Dendro <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.pres.Dendropsophini.tif")
  mods.bi.fut.pess.10pt.Dendro <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.pess.10pt.Dendropsophini.tif")
  mods.bi.fut.oti.10pt.Dendro <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.oti10pt.Dendropsophini.tif")
  
  mods.bi.pres.gbif <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.pres.spps.buscar.dados.gbif.tif")
  mods.bi.fut.pess.10pt.gbif <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.pess.10pt.spps.buscar.dados.gbif.tif")
  mods.bi.fut.oti.10pt.gbif <- rast("D:/Doutorado_new_models_dez_2023/resus/binary_models/mods.bi.fut.oti10pt.spps.buscar.dados.gbif.tif")
  
  mods.bi.pres.hylidae <- c(mods.bi.pres.copho, mods.bi.pres.LopHylini,
                            mods.bi.pres.Dendro, mods.bi.pres.gbif)
  rm(mods.bi.pres.copho)
  rm(mods.bi.pres.LopHylini)
  rm(mods.bi.pres.Dendro)
  rm(mods.bi.pres.gbif)
  names(mods.bi.pres.hylidae)
  
  # matching order of polygons list
  mods.bi.pres.hylidae <- mods.bi.pres.hylidae[[sp_names]]
  
  mods.bi.fut.pess.hylidae <- c(mods.bi.fut.pess.10pt.copho, mods.bi.fut.pess.10pt.LopHylini,
                                mods.bi.fut.pess.10pt.Dendro, mods.bi.fut.pess.10pt.gbif)
  rm(mods.bi.fut.pess.10pt.copho)
  rm(mods.bi.fut.pess.10pt.LopHylini)
  rm(mods.bi.fut.pess.10pt.Dendro)
  rm(mods.bi.fut.pess.10pt.gbif)
  
  mods.bi.fut.oti.hylidae <- c(mods.bi.fut.oti.10pt.copho, mods.bi.fut.oti.10pt.LopHylini,
                               mods.bi.fut.oti.10pt.Dendro, mods.bi.fut.oti.10pt.gbif)
  
  rm(mods.bi.fut.oti.10pt.copho)
  rm(mods.bi.fut.oti.10pt.LopHylini)
  rm(mods.bi.fut.oti.10pt.Dendro)
  rm(mods.bi.fut.oti.10pt.gbif)
  
  plot(mods.bi.pres[[48]])
  plot(occ.polys[[48]], add = T)
  plot(occ.b[[48]], add = T)
  plot(mods.bi.fut.oti.10pt[[48]])
  
  # Cropping SDMs
  # present
  names(mods.bi.pres.hylidae) == names(iucn.h.pres)
  mods.pres.crop <- list()
  for(i in 1:nlyr(mods.bi.pres.hylidae)){
    mods.pres.crop[[i]] <- terra::mask(mods.bi.pres.hylidae[[i]], 
                                       iucn.h.pres[[i]], updatevalue = 0)
  }
  mods.pres.crop <- rast(mods.pres.crop)
  plot(mods.pres.crop[[48]])
  writeRaster(mods.pres.crop, "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.bi.pres.rm.overpred.iucn.hylidae.tif", overwrite=TRUE)
  
  # fut otimista com 10pt
  mods.bi.fut.oti.hylidae <- mods.bi.fut.oti.hylidae[[sp_names]]
  
  mods.fut.oti.crop <- list()
  for(i in 1:nlyr(mods.bi.fut.oti.hylidae)){
    mods.fut.oti.crop[[i]] <- terra::mask(mods.bi.fut.oti.hylidae[[i]], iucn.h.fut[[i]], updatevalue = 0)
  }
  
  mods.fut.oti.crop <- rast(mods.fut.oti.crop)
  writeRaster(mods.fut.oti.crop, overwrite=TRUE,
              "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.bi.fut.oti.10pt.rm.overpred.iucn.hylidae.tif")
  
  # fut pessimista com 10pt
  mods.bi.fut.pess.hylidae <- mods.bi.fut.pess.hylidae[[sp_names]]
  cbind(names(mods.bi.fut.pess.hylidae)== names(iucn.h.fut))
  
  mods.fut.pess.crop <- list()
  for(i in 1:nlyr(mods.bi.fut.pess.hylidae)){
    mods.fut.pess.crop[[i]] <- terra::mask(mods.bi.fut.pess.hylidae[[i]], iucn.h.fut[[i]], updatevalue = 0)
  }
  mods.fut.pess.crop <- rast(mods.fut.pess.crop)
  plot(mods.fut.pess.crop[[48]])
  writeRaster(mods.fut.pess.crop, 
              "D:/Doutorado_new_models_dez_2023/resus/removed_overprediction/mods.bi.fut.pess.10pt.rm.overpred.iucn.Hylidae.tif",
              overwrite = T)
}
