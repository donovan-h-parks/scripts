#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=330G
#SBATCH --time=144:00:00
#SBATCH --partition=general
#SBATCH --account=a_ace
#SBATCH --job-name=r232_ar53_bootstrap
#SBATCH --array=20-39
#SBATCH -o bootstrap_%a.out
#SBATCH -e bootstrap_%a.err

# This sets the script to stop if any errors are encountered
# i.e. it will not run any further commands on error.
set -e

# Set the input/output paths
FAA_PATH="/home/uqdparks/gtdb/release232/ar53/filtered_msa.faa"
TREE_PATH="/home/uqdparks/gtdb/release232/ar53/gtdb_r232_ar53_fasttree.tree"
OUT_DIR="/scratch/user/uqdparks/gtdb/release232/ar53/bootstraps"

# Create output directories and set it as the current working path
mkdir -p "${OUT_DIR}"
cd "${OUT_DIR}"

# Run IQ Tree
# Note: SLURM_ARRAY_TASK_ID is the array batch number (auto generated) from SBATCH --array=0-99
srun --cpu-bind=none ~/sw/iqtree-2.4.0/bin/iqtree2 -nt $SLURM_CPUS_PER_TASK \
    -s "${FAA_PATH}" \
    -m LG+C10+F+G \
    -ft "${TREE_PATH}" \
    --prefix "gtdb_r232_ar53.rep${SLURM_ARRAY_TASK_ID}" \
    --bonly 1
