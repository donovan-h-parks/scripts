#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=01:00:00
#SBATCH --partition=general
#SBATCH --account=a_ace
#SBATCH --job-name=r232_ar53_bootstrap_test
#SBATCH --array=0-3
#SBATCH -o bootstrap_%a.out
#SBATCH -e bootstrap_%a.err

# This sets the script to stop if any errors are encountered
set -e

# Set the input/output paths
FAA_PATH="/home/uqdparks/gtdb/release232/ar53/filtered_msa-test.faa"
TREE_PATH="/home/uqdparks/gtdb/release232/ar53/gtdb_r232_ar53_fasttree-test.tree"
OUT_DIR="/scratch/user/uqdparks/gtdb/release232/ar53/bootstraps-test"

# Create output directories and set it as the current working path
mkdir -p "${OUT_DIR}"
cd "${OUT_DIR}"

# --- SLURM EXECUTION MODIFICATION ---

# Run IQ Tree
# Use -nt $SLURM_CPUS_PER_TASK to tell IQ-TREE to use all CPUs allocated by SBATCH.
# Use --cpu-bind=none to disable SLURM's automatic CPU binding that was causing the error.
srun --cpu-bind=none ~/sw/iqtree-2.4.0/bin/iqtree2 -nt $SLURM_CPUS_PER_TASK \
    -s "${FAA_PATH}" \
    -m LG+C10+F+G \
    -ft "${TREE_PATH}" \
    --prefix "gtdb_r232_ar53.rep${SLURM_ARRAY_TASK_ID}" \
    --bonly 1
