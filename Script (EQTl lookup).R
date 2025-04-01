.libPaths("Q:\\Stagiairs\\Bashir Hussein.W\\R")

# Packages
install.packages("tidyverse")
install.packages("data.table")
install.packages("dplyr")
install.packages("R.utils")
install.packages("biomaRt")
install.packages("httr")
install.packages("jsonlite")
install.packages("ggplot2")
install.packages("TCGAbiolinks")


if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("TCGAbiolinks")

install.packages("jsonlite", lib = "Q:/Stagiairs/Bashir Hussein.W/R", type = "binary")

library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(data.table)
library(utils)
library(TCGAbiolinks)



tar_file <- "Q:/Stagiairs/Bashir Hussein.W/Data/GTEx/GTEx_Analysis_v10_eQTL (1).tar"
untar(tar_file, exdir = "Q:/Stagiairs/Bashir Hussein.W/Data/GTEx/GTEx_Analysis_v10_eQTL_updated")
bladder_eqtl_file <- "Q:/Stagiairs/Bashir Hussein.W/Data/GTEx/GTEx_Analysis_v10_eQTL_updated/GTEx_Analysis_v10_eQTL_updated/Bladder.v10.eGenes.txt.gz"
bladder_eqtl_data <- fread(file = bladder_eqtl_file)

significant_eqtls <- bladder_eqtl_data %>%
  filter(pval_nominal < 0.005, ma_count < 2)


eqtl_file <- "Q:/Stagiairs/Bashir Hussein.W/Data/TCGA/BLCA.cis.susie.txt.txt"
library(data.table)
tcga_bladder_eqtl_data <- fread(file = eqtl_file)

sig_eqtls_tcga <- tcga_bladder_eqtl_data %>%
  filter(PIP > 0.5)



ggplot(significant_eqtls, aes(x = gene_id, y = pval_nominal)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Significant eQTLs in Bladder",
       x = "Gene ID",
       y = "Nominal p-value")





