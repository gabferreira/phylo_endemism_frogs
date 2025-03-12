## Diversity of Neotropical frogs (Bufonidae and Hylidae)

### Description

<p align="justify">

Scripts used to build Species Distribution Models and calculate diversity metrics for 526 neotropical frogs in the families Hylidae and Bufonidae.

</p>

### Abstract

<p align="justify">

Climate change is widely recognized as one of the main threats to biodiversity and predicting its consequences is critical to conservation efforts. A wide range of studies have evaluated the effects of future climate using taxon-based metrics, but few studies to date have applied a phylogenetic approach to forecast these impacts. Here, we show that future climate change is expected to significantly modify not only species richness, but also phylogenetic diversity and phylogenetic endemism of Neotropical frogs. Our results show that by 2050, the ranges of 42.20% (n = 213) of species are projected to shrink and the range of 1.71% of species (n = 9) are projected to disappear. Furthermore, we find that areas of high SR and PD are not always congruent with areas of high PE. Our study highlights the projected impacts of climate change on Neotropical frog diversity and identifies target areas for conservation efforts that consider not just species numbers, but also distinct evolutionary histories.

## codes

All analyses were performed in [R language](https://www.r-project.org/) version 4.3.2. To run the analysis we used a machine with the following specifications: ‘AMD® Ryzen 7 7800h with radeon graphics × 16 cores' with 40GB RAM, and 512 GB SSD. The software used was Windows 11. This folder contains R code files used:

-   `1.models_Maxent_ENMwizard.R`: build SDMs for species
-   `2.removing_overprediction_iucn_ranges.R`: remove overprediction of the SDMs
-   `3.diversity_metrics_SDMs_dispersal_barrier.R`: calculate diversity metrics (species richness, phylogenetic diversity and phylogenetic endemism)
-   `4.null_models_PD.R`: build null models for PD
-   `5.spatial_regression.R`: run spatial autoregressive models for diversity metrics
-   `6.maps_diversity_metrics.R`: maps for diversity metrics 

## data

Data used in the analysis:

-   `occurrence_records_neotropical_frogs.R`: occurrence records used to build SDMs for species

## results

Results generated:

-   `area_change_SDMs.csv`: species modeled, their IUCN status, branch length (Myr), and their range area in present, future optimistic, and future pessimistic. 


