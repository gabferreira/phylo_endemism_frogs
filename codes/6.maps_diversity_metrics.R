setwd("F:/new_SDMs_2024/resus_2024/div_metrics")
library(terra)

# metrics calculated in another script
div <- rast("diversity_metrics_allspecies_Portik_jetzpyron_2024_iucn.tif")
plot(div$pd.pres)
pd_ses_pres <- rast("ses_pd_pres_999_new.tif")
pd_ses_fut <- rast("ses_pd_fut_pess_999_new.tif")


x11()
plot(div$pd.pres/div$rich.pres)
plot(pd_ses_pres$SES.PD)

## delta
delta <- rast("delta_metrics_allspecies_Portik_jetzpyron_2024_iucn.tif")

plot(delta[[1]])

library(phyloraster)
# delta_45 <- delta.grid(div$rich.pres, div$rich.fut.oti)
# delta_85 <- delta.grid(div$rich.pres, div$rich.fut.pess)
# plot(delta_85)

## delta PD
# deltapd45 <- delta.grid(div$pd.pres, div$pd.fut.ot)
# deltapd85 <- delta.grid(div$pd.pres, div$pd.fut.pess)

## delta PE
# deltape45 <- delta.grid(div$pe.pres, div$pe.fut.ot)
# deltape85 <- delta.grid(div$pe.pres, div$pe.fut.pess)

# background for maps
# nw <- vect("/media/gabriela/Gabi_HD/shapes_rasters/shapes/newworld/NWCountries.shp")
nw <- vect("F:/shapes/shapes/newworld/NWCountries.shp")

# path to plot figures
setwd("F:/new_SDMs_2024/resus_2024/figures")

# richness maps
{
  # install.packages("viridis")
  # library(viridis)
  #   viridis(n = 6)
  
  div
  div_
  breaks_rq <- seq(0, 54, by = 0.1)
  # colors_rq <- colorRampPalette(c("#2385E8","#62EF99","#FDFB72","#FD982E", "#FD0000"))(length(breaks_rq)-1)
  # colors_rq <- colorRampPalette(c("white","#BDE496","#F9E56A","#FA9C24","#E15650"))(length(breaks_rq)-1)
  # colors_rq <- colorRampPalette(c("white","#36ff36","#43bf47","#517f59","#5f3f6b", "#6d007d"))(length(breaks_rq)-1)
  colors_rq <- colorRampPalette(c("white","#fde725","#7ad151","#22a884","#2a788e", "#414487","#440154"))(length(breaks_rq)-1)
  # colors_rq <- colorRampPalette(c("#440154FF", "#414487","#22a884","#7ad151","#fde725"))(length(breaks_rq)-1)
  # colors_rq <- colorRampPalette(c("#440154FF", "#414487FF", "#2A788EFF", "#22A884FF", "#7AD151FF", "#FDE725FF"))(length(breaks_rq)-1)
  
  # install.packages("rcartocolor")
  # library(rcartocolor)
  # display_carto_all(colorblind_friendly = TRUE)
  delta
  delta
  breaks_dt <- seq(-11.75309, 25.09877, by = 0.1)
  # colors_dt <- colorRampPalette(c("#990000","#CC2630", "white","#96b7d6", "#2a63ab","#0c3c80", "#001842","purple" ))(length(breaks_dt))
  colors_dt <- colorRampPalette(c("#990000","#B23F3F", "#FFFFFF", "#D4D7E2", "#AAAFC6", "#7F87AA", "#555F8D", "#2A3771", "#001055","black"))(length(breaks_dt-1))
  
  
  # plotting
  # {
  setwd("F:/new_SDMs_2024/resus_2024/figures")
  tiff("richness_all_species.iucn.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  
  plot(div$rich.pres, col = c(colors_rq), range = c(0, 53), 
       main = "(a) SR - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  
  plot(div$rich.fut.pess, col = c(colors_rq), range = c(0, 57),
       main = "(b) SR - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5),
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  
  plot(delta_85, col = c(colors_dt), range = c(-11, 32),
       main = "(c) Delta SR - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5),
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  
  dev.off()
  
  setwd("F:/new_SDMs_2024/resus_2024/figures")
  tiff("aggregated_richness_all_species.iucn.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  
  plot(div$rich.pres, col = c(colors_rq), range = c(0, 54), 
       main = "(a) SR - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  
  plot(div$rich.fut.pess, col = c(colors_rq), range = c(0, 54),
       main = "(b) SR - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5),
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  
  plot(delta$deltasr85, col = c(colors_dt), range = c(-11.75309, 25.09877),
       main = "(c) Delta SR - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5),
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  # lines(nw, alpha = 0.6, col = "grey50", lwd = 1)
  dev.off()
}

tiff("supplementary_richness_optimistic.tiff",
     width = 12, height = 6, units = "in", res = 600)
par(mfrow = c(1, 3))
par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)

plot(div$rich.pres, col = c(colors_rq), range = c(0, 57),
     main = "(a) SR - Present",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)

plot(div$rich.fut.oti, col = c(colors_rq), range = c(0, 57),
     main = "(b) SR - SSP245 Optimistic",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)

plot(delta_45, col = c(colors_dt), range = c(-11,32),
     axes = T,
     main = "(c) Delta SR - SSP245 Optimistic",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)
dev.off()

tiff("aggregated_supplementary_richness_optimistic.tiff",
     width = 12, height = 6, units = "in", res = 600)
par(mfrow = c(1, 3))
par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)

plot(div$rich.pres, col = c(colors_rq), range = c(0, 54),
     main = "(a) SR - Present",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)

plot(div$rich.fut.oti, col = c(colors_rq), range = c(0, 54),
     main = "(b) SR - SSP245 Optimistic",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)

plot(delta$deltasr45, col = c(colors_dt), range = c(-11.75309, 25.09877),
     axes = T,
     main = "(c) Delta SR - SSP245 Optimistic",
     plg = list( # parameters for drawing legen
       cex = 1.5),
     pax=list(cex.axis = 1.5), # Axis text size)
     cex.main = 1.8)# Title text size)
lines(nw, alpha = 0.3)
dev.off()

# phylo div maps
{
  minmax(div)
  minmax(div$pd.fut.ot)
  minmax(div$pd.fut.pess)
  
  breaks_pd <- seq(0, 1831.497, by = 3)
  # colorsr <- colorRampPalette(c("#FEFFE1","orange2","red2","darkred","purple"))(length(breaksr)-1)
  # colors_pd <- colorRampPalette(c("white","#86faf2","#0058B3", "purple"))(length(breaks_pd))
  # colors_pd <- colorRampPalette(c("#C0C6CB","#00BA2D","#009658", "#007185", "#0053A8", "#003193"))(length(breaks_pd))
  # colors_pd <- colorRampPalette(c("white","#90ee90","#67d89a", "#34bea5", "#1ea9ac", "#1d80af","darkblue"))(length(breaks_pd))
  # colors_pd <- colorRampPalette(c("white","#86faf2","#00A6D7","#0058B3","#0c3c80","purple","#440154FF"))(length(breaks_pd))
  # colors_pd <- colorRampPalette(c("white","#A8D0F0","#198df8","#5CFF00","#FDFB00", "#FF8B00","#FF0C12"))(length(breaks_pd)-1)
  colors_pd <- colorRampPalette(c("white","#fde725","#7ad151","#22a884","#2a788e", "#414487","#440154"))(length(breaks_pd)-1)
  # colors_pd <- colorRampPalette(c("#440154FF", "#414487", "#2a788e","#22a884","#7ad151","#fde725"))(length(breaks_pd)-1)
  
  # colors_pd <- colorRampPalette(c("grey90","#FBF15E", "#5DC863FF","#21908CFF","#3B528BFF","#440154FF"))(length(breaks_pd))
  
  ## Definindo breaks para os mapas de PE
  minmax(delta)
  minmax(deltapd85)
  
  breaks_dpd <- seq(-300.7098, 826.8979 , by = 10)
  # colors_dpd <- colorRampPalette(c("#990000","#B23F3F", "#FFFFFF", "#CCD9EB" ,"#99B3D8" ,"#658DC4", "#3267B1", "#00429E", "#001055"))(length(breaks_dpd))
  colors_dpd <- colorRampPalette(c("#990000","#B23F3F", "#FFFFFF", "#D4D7E2", "#AAAFC6", "#7F87AA", "#555F8D", "#2A3771", "#001055"))(length(breaks_dpd-1))
  
  
  colfunc <- colorRampPalette(c("white","#001055"))
  colfunc(7)
  
  colfunc <- colorRampPalette(c("white","#990000"))
  colfunc(5)
  
  # plotando PD
  tiff("aggregated_PD_all_species.iucn.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  # par(mfrow = c(1,3))
  
  plot(div$pd.pres, col = c(colors_pd), range = c(0, 1831.497),
       axes = T,
       main = "(d) PD - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(div$pd.fut.pess, col = c(colors_pd), range = c(0, 1831.497),
       axes = T,
       main = "(e) PD - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(delta$deltapd85, col = c(colors_dpd), range = c(-300.7098, 826.8979 ),
       axes = T,
       main = "(f) Delta PD - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  dev.off()
  
  tiff("PD_all_species.iucn.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  # par(mfrow = c(1,3))
  
  plot(div$pd.pres, col = c(colors_pd), range = c(0, 1891.471),
       axes = T,
       main = "(d) PD - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(div$pd.fut.pess, col = c(colors_pd), range = c(0, 1891.471),
       axes = T,
       main = "(e) PD - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(deltapd85, col = c(colors_dpd), range = c(-411.1559, 1075.7270),
       axes = T,
       main = "(f) Delta PD - SSP585 Pessimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  dev.off()
  
  ## Supplementary
  
  tiff("aggregated_supplementary_PD_optimistic.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  
  plot(div$pd.pres, col = c(colors_pd), range = c(0, 1831.497),
       axes = T,
       main = "(d) PD - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(div$pd.fut.ot, col = c(colors_pd), range = c(0, 1831.497),
       axes = T,
       main = "(e) PD - SSP245 Optimistic",
       # legend=FALSE,
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(delta$deltapd45, col = c(colors_dpd), range = c(-300.7098, 826.8979),
       axes = T,
       main = "(f) Delta PD - SSP245 Optimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  dev.off()
  
  tiff("supplementary_PD_optimistic.tiff",
       width = 12, height = 6, units = "in", res = 600)
  par(mfrow = c(1, 3))
  par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
  
  plot(div$pd.pres, col = c(colors_pd), range = c(0, 1891.471),
       axes = T,
       main = "(d) PD - Present",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(div$pd.fut.ot, col = c(colors_pd), range = c(0, 1891.471),
       axes = T,
       main = "(e) PD - SSP245 Optimistic",
       # legend=FALSE,
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  
  plot(deltapd45, col = c(colors_dpd), range = c(-411.1559, 1075.7270),
       axes = T,
       main = "(f) Delta PD - SSP245 Optimistic",
       plg = list( # parameters for drawing legen
         cex = 1.5),
       pax=list(cex.axis = 1.5), # Axis text size)
       cex.main = 1.8)# Title text size)
  lines(nw, alpha = 0.3)
  dev.off()
  
  ## Definindo breaks para os mapas de PE
  minmax(div$pe.pres)
  minmax(div$pe.fut.pess)
  minmax(div$pe.fut.pess)
  plot(div$pe.pres)
  breaks_pe <- seq(0.000000, 5.30, by = 0.1)
  colors_pe <- colorRampPalette(c("grey","#fde725","#7ad151","#22a884","#2a788e", "#414487","#440154"))(length(breaks_pe)-1)
  # colorsr <- colorRampPalette(c("#FEFFE1","orange2","red2","darkred","purple"))(length(breaksr)-1)
  # colors_pe <- colorRampPalette(c("grey95","#48BF92","#4C74A6", "#4F42B4"))(length(breaks_pe))
  # colors_pe <- colorRampPalette(c("grey99","#E60001","#B00405","#7B0708"))(length(breaks_pe))
  # colors_pe <- colorRampPalette(c("white","#A8D0F0","#198df8","#5CFF00","#FDFB00", "#FF8B00","#FF0C12"))(length(breaks_pe)-1)
}

# trying phylo endm maps (did not work :/ )
{
  x11()
  par(mfrow = c(1,2))
  plot(div$pe.pres)
  plot(div$pe.fut.ot)
  plot(div$pe.fut.pess)
  plot(delta$delta_pe_85, range = c(-4.548492, 5))
  
  plot(density(na.omit(values(div$pe.pres))), xlim = c(0,1))
  plot(density(na.omit(values(div$pe.fut.ot))), xlim = c(0,1))
  plot(density(na.omit(values(div$pe.fut.pess))), xlim = c(0,1))
  
  
  tiff("PE_all_species_pres.tiff",  width = 10, height = 10, unit = "in", res = 300)
  x11()
  plot(div$pe.pres, col = c(colors_pe), range = c(0.000000, 5.30),
       axes = T,
       main = "(a) PE - Present Baseline",
       plg = list( # parameters for drawing legend
         # title = "b)",
         # title.cex = 2, # Legend title size
         cex = 2), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.2), # Axis text size
       cex.main = 2) # Title text size
  lines(nw, alpha = 0.3)
  # maps::map(database = "world", add = T)
  dev.off()
  
  breaks_pe <- seq(0.000000, 4.804358, by = 0.05)
  #colorsr <- colorRampPalette(c("#FEFFE1","orange2","red2","darkred","purple"))(length(breaksr)-1)
  # colors_pe <- colorRampPalette(c("#C0C6CB","#00A6D7","#0058B3", "#001B87", "darkblue"))(length(breaks_pe))
  # colors_pe <- colorRampPalette(c("grey98", "#C44004", "#00563F"))(length(breaks_pe))
  colors_pe <- colorRampPalette(c("grey95", "red","red", "darkred"))(length(breaks_pe)-1)
  
  tiff("PE_all_species_future.tiff",  width = 10, height = 10, unit = "in", res = 300)
  par(mfrow = c(1,2), oma=c(0,0,3,1.5))
  
  x11()
  plot(div$pe.fut.ot, 
       range = c(0.000000, 4),
       axes = T,
       main = "(b) PE - SSP245 Optimistic",
       plg = list( # parameters for drawing legend
         # title = "b)",
         # title.cex = 2, # Legend title size
         cex = 1.8), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.8), # Axis text size
       cex.main = 2) # Title text size
  lines(nw, alpha = 0.3)
  teste <- rast("D:/Doutorado_new_models_dez_2023/resus/div_metrics/pe_fut_oti_EPM.tiff")
  x11()
  plot(teste)
  
  plot(div$pe.fut.pess, 
       # col = c(colors_pe),
       range = c(0.000000, 4),
       # axes = F,
       main = "(c) PE - SSP585 Pessimistic",
       plg = list( # parameters for drawing legend
         cex = 1.8), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.8), # Axis text size
       cex.main = 2,
       # legend = FALSE,
       mar=c(1,1,1,4)) # Title text size
  
  
  plot(div$pe.fut.pess, 
       # col = c(colors_pe),
       range = c(4.1, 22.98053),
       axes = T,
       main = "(c) PE - SSP585 Pessimistic",
       plg = list( # parameters for drawing legend
         # title = "b)",
         # title.cex = 2, # Legend title size
         cex = 1.8), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.8), # Axis text size
       cex.main = 2,
       add = T,
       mar=c(1,1,1,4)) # Title text size
  lines(nw, alpha = 0.3)
  dev.off()
  
  ## Delta PE
  deltape45 <- delta.grid(div$pe.pres, div$pe.fut.ot)
  deltape85 <- delta.grid(div$pe.pres, div$pe.fut.pess)
  
  ## Definindo breaks para os mapas de PE
  minmax(delta$deltape45)
  minmax(delta$deltape85)
  
  breaks_dpe <- seq(-4.548492, 22 , by = 1)
  #colorsr <- colorRampPalette(c("#FEFFE1","orange2","red2","darkred","purple"))(length(breaksr)-1)
  colors_dpe <- colorRampPalette(c("#990000","#990000",  "grey95", "grey95",
                                   "#96b7d6", "#2a63ab",
                                   "#1432BA", "black",
                                   "#1432BA", "black",  "black",  "black"))(length(breaks_dpe))
  plot(delta$delta_pe_45, col = c(colors_dpe), range = c(-4.548492, 22))
  
  
  # tiff("delta_PE_all_species_fut_45.tiff", width = 10, height = 8, unit = "in", res = 600)
  # 
  x11()
  # par(mfrow = c(1,2))
  
  plot(delta$delta_pe_45, col = c(colors_dpe), range = c(-4.548492, 5),
       axes = T,
       main = "d)",
       plg = list( # parameters for drawing legend
         # title = "b)",
         # title.cex = 2, # Legend title size
         cex = 1.8), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.8), # Axis text size
       cex.main = 2) # Title text size
  lines(nw, alpha = 0.3)
  dev.off()
  
  tiff("delta_PE_all_species_fut_85.tiff", width = 10, height = 8, unit = "in", res = 600)
  breaks_dpe <- seq(-1.810204, 9.711723, by = 0.1)
  #colorsr <- colorRampPalette(c("#FEFFE1","orange2","red2","darkred","purple"))(length(breaksr)-1)
  colors_dpe <- colorRampPalette(c("darkred", "gray95", "#0c3c80"))(length(breaks_dpe))
  
  plot(deltape85, col = c(colors_dpe), range = c(-1.810204, 9.711723),
       axes = T,
       main = "e)",
       plg = list( # parameters for drawing legend
         # title = "b)",
         # title.cex = 2, # Legend title size
         cex = 1.8), # Legend text size
       pax=list( # parameters for drawing axes
         cex.axis = 1.8), # Axis text size
       cex.main = 2) # Title text size
  lines(nw, alpha = 0.3)
  dev.off()
  
  
  {
    tiff("present_all_species.tiff",
         width = 12, height = 6, units = "in", res = 600)
    par(mfrow = c(1, 3))
    par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
    
    plot(div$rich.pres.all, col = c(colors_rq), range = c(0, 44), 
         main = "(a) SR - Present Baseline",
         plg = list( # parameters for drawing legen
           cex = 1.5),
         pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8)# Title text size)
    lines(nw, alpha = 0.3)
    
    plot(div$pd.pres, col = c(colors_pd), range = c(0, 1408.45),
         axes = T,
         main = "(b) PD - Present Baseline",
         plg = list( # parameters for drawing legen
           cex = 1.5),
         pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8)# Title text size)
    lines(nw, alpha = 0.3)
    
    plot(div$pe.pres, col = c(colors_pe), range = c(0.000000, 22),
         axes = T,
         legend = T,
         smooth = T,
         main = "(c) PE - Present Baseline",
         plg = list( # parameters for drawing legend
           # at = c(0, 1, 2, 5, 10, 15, 20),# parameters for drawing legen
           labels = NULL,
           cex = 1.5),
         pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8)# Title text size)
    
    plot(div$pe.pres, col = c(colors_pe), range = c(0.000000, 4.804358),
         axes = F,
         legend = F,
         main = "(c) PE - Present Baseline",
         # plg = list( # parameters for drawing legen
         #   cex = 1.5),
         # pax=list(cex.axis = 1.5), # Axis text size)
         # add = T , #Title text size)
         cex.main = 1.8)
    lines(nw, alpha = 0.3)
    dev.off()
  }
  
  {
    tiff("fut_pessimistic_all_species.tiff",
         width = 12, height = 6, units = "in", res = 600)
    par(mfrow = c(1, 3))
    par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
    
    plot(div$rich.fut.all, col = c(colors_rq), range = c(0, 44),
         main = "(d) SR - SSP585 Pessimistic",
         plg = list( # parameters for drawing legen
           cex = 1.5),
         pax=list(cex.axis = 1.5),
         cex.main = 1.8)# Title text size)
    lines(nw, alpha = 0.3)
    
    plot(div$pd.fut.pess, col = c(colors_pd), range = c(0, 1408.45),
         main = "(e) PD - SSP585 Pessimistic",
         plg = list( # parameters for drawing legen
           cex = 1.5),
         pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8)# Title text size)
    lines(nw, alpha = 0.3)
    
    plot(div$pe.fut.pess, col = c(colors_pe), range = c(0.000000, 22),
         legend = T,
         smooth = T,
         main = "(f) PE - SSP585 Pessimistic",
         plg = list( # parameters for drawing legend
           # at = c(0, 1, 2, 5, 10, 15, 20),# parameters for drawing legen
           labels = NULL,
           cex = 1.5),
         pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8)# Title text size)
    
    plot(div$pe.fut.pess, col = c(colors_pe), range = c(0.000000, 4.85),
         axes = F,
         main = "(f) PE - SSP585 Pessimistic",
         legend = F,
         # plg = list(
         #   # at = c(0, 1, 2, 5, 10, 15, 20),# parameters for drawing legend
         #   labels = c(0, 1, 2, 5,10, 15, 20),
         #   cex = 1.5),
         # pax=list(cex.axis = 1.5), # Axis text size)
         cex.main = 1.8,
         add = T)# Title text size)
    lines(nw, alpha = 0.3)
    dev.off()
  }
}