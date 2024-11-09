# Load packages
library(terra)
library(car)
library(nortest)
library(spdep)
library(spatialreg)

# Read raster files and set projection
setwd("F:/new_SDMs_2024/resus_2024/div_metrics")
div <- rast("diversity_metrics_allspecies_Portik_jetzpyron_2024_iucn.tif")

plot(div)

# Combine rasters and set names
# vars <- c(rich.td.pre, rich.fd.pre, rich.pd.pre)
# names(vars) <- c("TD", "FD", "PD")

# Convert rasters to data frame
vars.df <- as.data.frame(div, na.rm = TRUE, xy = T)

# Extract coordinates
xy <- terra::crds(div, df = FALSE, na.rm = TRUE)
# vars.df <- cbind(xy, vars.df)

# Display the first few rows of the data frame
head(vars.df)

# Calculate correlation matrix of variables
cor(na.omit(vars.df))

# Fit linear regression model
model.td <- lm(rich.pres ~ pd.pres, data = vars.df)
summary(model.td)
model.td.oti <- lm(vars.df$rich.fut.oti ~ vars.df$pd.fut.ot, data = vars.df)
summary(model.td.oti)
model.td.pes <- lm(vars.df$rich.fut.pess ~ vars.df$pd.fut.pess, data = vars.df)
summary(model.td.pes)

model.td.pe <- lm(rich.pres ~ pe.pres, data = vars.df)
summary(model.td.pe)
model.td.pe.oti <- lm(vars.df$rich.fut.oti ~ vars.df$pe.fut.ot, data = vars.df)
summary(model.td.pe.oti)
model.td.pe.pes <- lm(vars.df$rich.fut.pess ~ vars.df$pe.fut.pess, data = vars.df)
summary(model.td.pe.pes)

# Check for multicollinearity using Variance Inflation Factor (VIF)
# car::vif(model.td)

# Plot histogram of model residuals
hist(model.td$residuals)

# Perform Anderson-Darling test on residuals for normality
ad.test(model.td$residuals)

# Construct spatial weights matrix using k-nearest neighbors
knn <- knearneigh(xy, longlat = TRUE)
kn1 <- knn2nb(knn)

# Create neighborhood structure from cell grid
neigh <- cell2nb(nrow = 236, ncol = 220)

# Convert neighborhood structure to listw format
neigh.l <- nb2listw(kn1)

# Conduct Moran's I test for spatial autocorrelation
lmMoranTest.td <- lm.morantest(model.td, neigh.l)
lmMoranTest.td

lmMoranTest.td.pe <- lm.morantest(model.td.pe, neigh.l)
lmMoranTest.td.pe

# Fit spatial autoregressive (SAR) model
# Phylogenetic diversity
reg_SAR_pres <- spautolm(model.td, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_pres, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
reg_SAR_oti <- spautolm(model.td.oti, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_oti, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
reg_SAR_pess <- spautolm(model.td.pes, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_pess, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)

# Phylogenetic endemism
reg_SAR_pres_pe <- spautolm(model.td.pe, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_pres_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
reg_SAR_oti_pe <- spautolm(model.td.pe.oti, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_oti_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
reg_SAR_pess_pe <- spautolm(model.td.pe.pes, data = vars.df, neigh.l, family = "SAR")
summary(reg_SAR_pess_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)

# Extracting results from SAR models to save
summary_pres <- summary(reg_SAR_pres, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
summary_oti <- summary(reg_SAR_oti, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
summary_pess <- summary(reg_SAR_pess, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)

summary_pres_pe <- summary(reg_SAR_pres_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
summary_oti_pe <- summary(reg_SAR_oti_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)
summary_pess_pe <- summary(reg_SAR_pess_pe, correlation = TRUE, adj.se = TRUE, Nagelkerke = TRUE)

# Graphic
# Fitted values and residuals
fitted_values_pres <- fitted(reg_SAR_pres)
fitted_values_oti <- fitted(reg_SAR_oti)
fitted_values_pess <- fitted(reg_SAR_pess)
residuals_pres <- resid(reg_SAR)
residuals_oti <- resid(reg_SAR_oti)
residuals_pess <- resid(reg_SAR_pess)

# Plotting residuals vs fitted values
plot(fitted_values_pres, residuals_pres,
     main = "Residuals vs Fitted Values",
     xlab = "Fitted Values",
     ylab = "Residuals")
abline(h = 0, col = "red", lwd = 2)  # Add a horizontal line at y = 0
# Histogram of residuals
hist(residuals_pres, breaks = 20, main = "Histogram of Residuals",
     xlab = "Residuals", col = "lightblue", border = "black")

# Q-Q plot of residuals to check for normality
qqnorm(residuals_pres)
qqline(residuals_pres, col = "red", lwd = 2)
qqnorm(residuals_oti)
qqline(residuals_oti, col = "red", lwd = 2)
qqnorm(residuals_pess)
qqline(residuals_pess, col = "red", lwd = 2)


# Regression graphs for the paper SR vs PD
setwd("F:/new_SDMs_2024/resus_2024/figures")
tiff("regression_graphs_PD_PE_SR.tiff",
     width = 12, height = 6, units = "in", res = 600)
par(mfrow = c(2, 3))
par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
# par(mfrow = c(1,3))

# Scatter plot of SR - Present vs PD - Present
plot(vars.df$rich.pres, vars.df$pd.pres,
     # main = "SR - Present vs PD - Present",
     xlab = "SR - Present",
     ylab = "PD - Present")
# Fit a linear model to SR - Present and PD - Present
lm_model_pres <- lm(vars.df$pd.pres ~ vars.df$rich.pres)
# Add the fitted line to the plot
abline(lm_model_pres, col = "#00b4c5", lwd = 2)
# Add text (a) and pseudo-R² to the plot
text(x = min(vars.df$rich.pres), y = max(vars.df$pd.pres), 
     labels = "(a)", pos = 4, cex = 1.5)
text(x = 27, y = min(vars.df$pd.pres) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.993)), pos = 4, cex = 1.2)


# Scatter plot of SR - Fut Optimistic vs PD - Fut Optimistic
plot(vars.df$rich.fut.oti, vars.df$pd.fut.ot,
     # main = "SR - SSP245 Optimistic vs PD - SSP245 Optimistic",
     xlab = "SR - SSP245 Optimistic",
     ylab = "PD - SSP245 Optimistic")
# Fit a linear model to SR - Present and PD - Present
lm_model_oti <- lm(vars.df$pd.fut.ot ~ vars.df$rich.fut.oti)
# Add the fitted line to the plot
abline(lm_model_oti, col = "#00b4c5", lwd = 2)
# Add text (b) and pseudo-R² to the plot
text(x = min(vars.df$rich.fut.oti), y = max(vars.df$pd.fut.ot), 
     labels = "(b)", pos = 4, cex = 1.5)
text(x = 32, y = min(vars.df$pd.fut.ot) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.995)), pos = 4, cex = 1.2)

# Scatter plot of SR - Fut Pessimistic vs PD - Fut Pessimistic
plot(vars.df$rich.fut.pess, vars.df$pd.fut.pess,
     # main = "SR - SSP245 Pessimistic vs PD - SSP245 Pessimistic",
     xlab = "SR - SSP585 Pessimistic",
     ylab = "PD - SSP585 Pessimistic")
# Fit a linear model to SR - Pessimistic and PD - Pessimistic
lm_model_pess <- lm(vars.df$pd.fut.pess ~ vars.df$rich.fut.pess)
# Add the fitted line to the plot
abline(lm_model_pess, col = "#00b4c5", lwd = 2)
# Add text (c) and pseudo-R² to the plot
text(x = min(vars.df$rich.fut.pess), y = max(vars.df$pd.fut.pess), 
     labels = "(c)", pos = 4, cex = 1.5)
text(x = 33, y = min(vars.df$pd.fut.pess) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.994)), pos = 4, cex = 1.2)
# dev.off()

# Regression graphs for the paper SR vs PD
# setwd("F:/new_SDMs_2024/resus_2024/figures")
# tiff("regression_graphs_PE_SR.tiff",
#      width = 12, height = 4, units = "in", res = 600)
# par(mfrow = c(1, 3))
# par(mar = c(4.3, 5, 2, 1), cex.lab = 1.5)
# par(mfrow = c(1,3))

# Scatter plot of SR - Present vs PD - Present
plot(vars.df$rich.pres, vars.df$pe.pres,
     # main = "SR - Present vs PD - Present",
     xlab = "SR - Present",
     ylab = "PE - Present")
# Fit a linear model to SR - Present and PD - Present
lm_model_pres <- lm(vars.df$pe.pres ~ vars.df$rich.pres)
# Add the fitted line to the plot
abline(lm_model_pres, col = "#00b4c5", lwd = 2)
# Add text (a) and pseudo-R² to the plot
text(x = min(vars.df$rich.pres), y = max(vars.df$pe.pres), 
     labels = "(d)", pos = 4, cex = 1.5)
text(x = 27, y = max(vars.df$pe.pres) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.017)), pos = 4, cex = 1.2)

# Scatter plot of SR - Fut Optimistic vs PD - Fut Optimistic
plot(vars.df$rich.fut.oti, vars.df$pe.fut.ot,
     # main = "SR - SSP245 Optimistic vs PD - SSP245 Optimistic",
     xlab = "SR - SSP245 Optimistic",
     ylab = "PE - SSP245 Optimistic")
# Fit a linear model to SR - Present and PD - Present
lm_model_oti <- lm(vars.df$pe.fut.ot ~ vars.df$rich.fut.oti)
# Add the fitted line to the plot
abline(lm_model_oti, col = "#00b4c5", lwd = 2)
# Add text (b) and pseudo-R² to the plot
text(x = min(vars.df$rich.fut.oti), y = max(vars.df$pe.fut.ot), 
     labels = "(e)", pos = 4, cex = 1.5)
text(x = 32, y = max(vars.df$pe.fut.ot) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.053)), pos = 4, cex = 1.2)

# Scatter plot of SR - Fut Pessimistic vs PD - Fut Pessimistic
plot(vars.df$rich.fut.pess, vars.df$pe.fut.pess,
     # main = "SR - SSP245 Pessimistic vs PD - SSP245 Pessimistic",
     xlab = "SR - SSP585 Pessimistic",
     ylab = "PE - SSP585 Pessimistic")
# Fit a linear model to SR - Pessimistic and PD - Pessimistic
lm_model_pess <- lm(vars.df$pe.fut.pess ~ vars.df$rich.fut.pess)
# Add the fitted line to the plot
abline(lm_model_pess, col = "#00b4c5", lwd = 2)
# Add text (c) and pseudo-R² to the plot
text(x = min(vars.df$rich.fut.pess), y = max(vars.df$pe.fut.pess), 
     labels = "(f)", pos = 4, cex = 1.5)
text(x = 33, y = max(vars.df$pe.fut.pess) * 0.9, 
     labels = bquote("Pseudo-R² = " ~ .(0.047)), pos = 4, cex = 1.2)
dev.off()

