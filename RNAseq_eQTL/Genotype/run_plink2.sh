#!/bin/bash

# Job name:
#SBATCH --job-name=plink2_job
# Output file:
#SBATCH --output=plink2_job.out
# Error file:
#SBATCH --error=plink2_job.err
# Time limit:
#SBATCH --time=01:00:00
# Number of nodes:
#SBATCH --nodes=1
# Number of tasks per node:
#SBATCH --ntasks-per-node=1
# Memory per node:
#SBATCH --mem=4G

# Activate Conda environment
source ~/miniconda3/bin/activate
conda activate venv

# Navigate to the directory containing the VCF file
cd /mnt/home1/bashirh/SNP/

# Create the output directory if it doesn't exist
mkdir -p /mnt/home1/bashirh/genotype/output_dir

# Run the plink2 command with the specified output directory
plink2 --output-chr chrM --vcf /mnt/home1/bashirh/SNP/urolife_nbcs2_samen_chr1.dose.vcf.gz --out /mnt/home1/bashirh/genotype/output_dir/gen_chr1_data
