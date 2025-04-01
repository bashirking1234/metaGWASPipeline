##  Performing eQTL Analysis Using Normalized RNA-seq Counts in R

.libPaths("Q:\\Stagiairs\\Bashir Hussein.W\\R")

## Install librarys

install.packages("MatrixEQTL")
install.packages("vcfR")



expression_data <- read.table("Q:/Stagiairs/Bashir Hussein.W/Data/salmon.merged.gene_counts_scaled.tsv", header = TRUE, row.names = 1)

# Load necessary libraries
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("VariantAnnotation")
install.packages("R.utils")

library(VariantAnnotation)
library(R.utils)
library(httr)
library(MatrixEQTL)
library(data.table)


url <- "https://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/common_all_20180418.vcf.gz"
destfile <- "common_all_20180418.vcf.gz"

response <- GET(url, write_disk(destfile, overwrite = TRUE))

# Check the status of the download
if (status_code(response) == 200) {
  message("Download successful!")
} else {
  message("Download failed with status: ", status_code(response))
}

gunzip("common_all_20180418.vcf.gz", "common_all_20180418.vcf")




vcf_lines <- readLines("common_all_20180418.vcf", n = 20)
print(vcf_lines)


# Ensure the VCF file ends with a newline
system("echo >> common_all_20180418.vcf")

# Read the VCF file, skipping lines until the header is found
vcf <- fread("common_all_20180418.vcf", skip = "#CHROM")

# Save genotype data to a text file
write.table(vcf, file = "genotype_data.txt", sep = "\t", quote = FALSE, col.names = TRUE)

# Verify the saved genotype data
genotype_data <- read.table("genotype_data.txt", header = TRUE, row.names = 1)
head(genotype_data)



























# Read the VCF file, skipping lines until the header is found
vcf <- fread("common_all_20180418.vcf", skip = "#CHROM")

# Save genotype data to a text file
write.table(vcf, file = "genotype_data.txt", sep = "\t", quote = FALSE, col.names = NA)

# Ensure the VCF file ends with a newline
system("echo >> common_all_20180418.vcf")

# Read the VCF file, skipping lines until the header is found
vcf <- fread("common_all_20180418.vcf", skip = "#CHROM")

# Save genotype data to a text file
write.table(vcf, file = "genotype_data.txt", sep = "\t", quote = FALSE, col.names = TRUE)

# Verify the saved genotype data
genotype_data <- read.table("genotype_data.txt", header = TRUE, row.names = 1)
head(genotype_data)






## eqtl 

library(MatrixEQTL)





# Define model
model <- Matrix_eQTL_main(
  snps = SlicedData$new(genotype_data.txt),
  gene = SlicedData$new(expression_data),
  output_file_name = "eQTL_results.txt",
  pvOutputThreshold = 1e-5,
  useModel = modelLINEAR,
  errorCovariance = numeric(),
  verbose = TRUE
)

# View results
print(model$all$eqtls)


