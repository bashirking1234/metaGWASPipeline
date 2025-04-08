#!/bin/bash
#SBATCH --output=tensorqtl_run.out
#SBATCH --error=tensorqtl_run.err
#SBATCH --time=02:00:00      # Increased time limit to 2 hours
#SBATCH --mem=8G             # Increased memory allocation to 8 GB
#SBATCH --cpus-per-task=1

echo "Starting script..."

# Activate Conda environment
source ~/miniconda3/bin/activate
conda activate tensorqtl_env || { echo "Failed to activate Conda environment"; exit 1; }
echo "Conda environment activated."

# Install R using Conda
echo "Installing R..."
conda install -c conda-forge r-base || { echo "Failed to install R"; exit 1; }
echo "R installed."

# Install required Python packages
echo "Installing required Python packages..."
pip install tensorqtl pandas-plink rpy2 || { echo "Failed to install required Python packages"; exit 1; }
echo "Required Python packages installed."

# Install qvalue library in R with specified CRAN mirror
echo "Installing qvalue library in R..."
Rscript -e 'options(repos = c(CRAN = "https://cran.r-project.org")); if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager"); BiocManager::install("qvalue")' || { echo "Failed to install qvalue library in R"; exit 1; }
echo "qvalue library installed."

# Run TensorQTL in cis mode
echo "Running TensorQTL in cis mode..."
python3 -m tensorqtl GEUVADIS.445_samples.GRCh38.20170504.maf01.filtered.nodup.chr18 \
    GEUVADIS.445_samples.expression.bed.gz output_prefix \
    --covariates GEUVADIS.445_samples.covariates.txt \
    --cis_output output_prefix.cis_qtl.txt.gz \
    --mode cis || { echo "TensorQTL cis mode failed"; exit 1; }
echo "TensorQTL cis mode completed successfully."

# Run TensorQTL in cis_independent mode using the output from cis mode
echo "Running TensorQTL in cis_independent mode..."
python3 -m tensorqtl GEUVADIS.445_samples.GRCh38.20170504.maf01.filtered.nodup.chr18 \
    GEUVADIS.445_samples.expression.bed.gz output_prefix \
    --covariates GEUVADIS.445_samples.covariates.txt \
    --cis_output output_prefix.cis_qtl.txt.gz \
    --mode cis_independent || { echo "TensorQTL cis_independent mode failed"; exit 1; }
echo "TensorQTL cis_independent mode completed successfully."
