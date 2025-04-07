.libPaths("Q:\\Stagiairs\\Bashir Hussein.W\\R")

library(data.table)


# Load the metaGWAS data
metaGWAS_file_path <- "path/to/your/file"
metaGWAS_data <- fread(metaGWAS_file_path, sep = "\t", header = TRUE)

# Filtering on the metaGWAS data
library(dplyr)
# metaGWAS_data <- metaGWAS_data %>%
# filter(`P-value`< 0.10)


# Extract chromosome and position from MarkerName column
metaGWAS_data[, c("Chr", "Position") := tstrsplit(MarkerName, "[:]", keep = c(1, 2))]
metaGWAS_data[, Chr := sub("chr", "", Chr)]
metaGWAS_data[, Position := as.integer(Position)]

# Load the GTEx data
tar_file <- "path/to/your/file"
untar(tar_file, exdir = "path/to/your/exit/directory"
bladder_eqtl_file <- "path/to/your/gtexfile"
gtex_eqtl <- fread(file = bladder_eqtl_file)

# Extract chromosome and position from variant_id column
gtex_eqtl[, c("Chr", "Position") := tstrsplit(variant_id, "_", keep = c(1, 2))]
gtex_eqtl[, Chr := sub("chr", "", Chr)]
gtex_eqtl[, Position := as.integer(Position)]


# Ensure both columns are of the same type
metaGWAS_data[, Chr := as.character(Chr)]
gtex_eqtl[, Chr := as.character(Chr)]

# Check for unique values in Chr and Position columns
print("Unique values in metaGWAS_data:")
print(unique(metaGWAS_data[, .(Chr, Position)]))
print("Unique values in gtex_eqtl:")
print(unique(gtex_eqtl[, .(Chr, Position)]))

# Check for common values between the datasets
common_values <- merge(metaGWAS_data[, .(Chr, Position)], gtex_eqtl[, .(Chr, Position)], by = c("Chr", "Position"))
print("Common values between metaGWAS_data and gtex_eqtl:")
print(common_values)

# Merge the datasets based on the Position and Chr columns
merged_data_gtex <- merge(gtex_eqtl, metaGWAS_data[, .(MarkerName, Chr, Position)], by = c("Chr", "Position"), all.x = TRUE)

# Rename the MarkerName column to MarkerName_metaGWAS
setnames(merged_data_gtex, "MarkerName", "MarkerName_metaGWAS")

# Reorder columns to place MarkerName_metaGWAS next to variant_id
setcolorder(merged_data_gtex, c("gene_id", "gene_name", "biotype", "gene_chr", "gene_start", "gene_end", "strand", "num_var", "beta_shape1", "beta_shape2", "true_df", "pval_true_df", "variant_id", "Chr", "MarkerName_metaGWAS", "Position", "tss_distance", "variant_pos", "ref", "alt", "num_alt_per_site", "rs_id_dbSNP155_GRCh38p13", "ma_samples", "ma_count", "af", "pval_nominal", "slope", "slope_se", "pval_perm", "pval_beta", "qval", "pval_nominal_threshold", "afc", "afc_se"))

# Filter out rows with NA in MarkerName_metaGWAS
filtered_merged_data_gtex <- merged_data_gtex[!is.na(MarkerName_metaGWAS)]

# Save the filtered merged data to a new file
fwrite(filtered_merged_data_gtex, "filtered_merged_data_gtex.tbl", sep = "\t")

# Display the first few rows of the filtered merged data
head(filtered_merged_data_gtex)
