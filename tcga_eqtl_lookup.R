.libPaths("Q:\\Stagiairs\\Bashir Hussein.W\\R")

library(data.table)

# Load the metaGWAS data
metaGWAS_file_path <- "path/to/your/file"
metaGWAS_data <- fread(metaGWAS_file_path, sep = "\t", header = TRUE)

# Extract chromosome and position from MarkerName column
metaGWAS_data[, c("Chr", "Position") := tstrsplit(MarkerName, "[:]", keep = c(1, 2))]
metaGWAS_data[, Chr := sub("chr", "", Chr)]
metaGWAS_data[, Position := as.integer(Position)]

# Filtering on the metaGWAS data
library(dplyr)
# metaGWAS_data <- metaGWAS_data %>%
# filter(`P-value`< 0.10)

# Load the TCGA data
tcga_file_path <- "path/to/your/file"
tcga_eqtl <- fread(tcga_file_path, sep = "\t", header = TRUE)

# Ensure both columns are of the same type
metaGWAS_data[, Chr := as.character(Chr)]
tcga_eqtl[, Chr := as.character(Chr)]

# Check for common values between the datasets
common_values <- merge(metaGWAS_data[, .(Chr, Position)], tcga_eqtl[, .(Chr, Position)], by = c("Chr", "Position"))
print("Common values between metaGWAS_data and tcga_eqtl:")
print(common_values)

# Merge the datasets based on the Position and Chr columns
merged_data_tcga <- merge(tcga_eqtl, metaGWAS_data[, .(MarkerName, Chr, Position)], by = c("Chr", "Position"), all.x = TRUE)

# Rename the MarkerName column to MarkerName_metaGWAS
setnames(merged_data_tcga, "MarkerName", "MarkerName_metaGWAS")

# Reorder columns to place MarkerName_metaGWAS next to Variant
setcolorder(merged_data_tcga, c("Cancer_type", "Gene_name", "RS_id", "Variant", "Chr", "MarkerName_metaGWAS", "Position", "Credible_Set", "Credible_Set_Size", "PIP"))

# Filter out rows with NA in MarkerName_metaGWAS
filtered_merged_data_tcga <- merged_data_tcga[!is.na(MarkerName_metaGWAS)]

# Save the filtered merged data to a new file
fwrite(filtered_merged_data_tcga, "filtered_merged_data.tbl", sep = "\t")

# Display the first few rows of the filtered merged data
head(filtered_merged_data_tcga)
