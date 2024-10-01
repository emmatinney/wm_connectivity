#!/bin/bash
#SBATCH --time=24:0:0
#SBATCH --nodes=2
#SBATCH --mem-per-cpu=32000
#SBATCH --job-name=MRtrix_CR_createConnectome
#SBATCH --partition=short
# Outputs -----------------------------
#SBATCH --error=%x.%A-%a.err
#SBATCH --array=1-154%50
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ai.me@northeastern.edu

module load singularity
export SINGULARITY_BIND="/scratch/ai.me/data:/mnt,/shared/centos7"
mx=/shared/container_repository/MRtrix/mrtrix3_3.0.4.sif


subject_name=`sed "${SLURM_ARRAY_TASK_ID}q;d" sublist_QC.txt`
FS_DIR=/mnt/${subject_name}/FREESURFER 
FS_DIR_NS=/scratch/ai.me/data/${subject_name}/FREESURFER 
PP_DIR=/mnt/preprocessed_data/${subject_name}
PP_DIR_NS=/scratch/ai.me/data/preprocessed_data/${subject_name}
SF=/mnt/Schaefer
SF_NS=/scratch/ai.me/data/Schaefer
# this is to convert the labels to a format that MRtrix can read 
singularity exec ${mx} labelconvert -force ${FS_DIR}/mri/sf400_7.mgz ${SF}/project2individual/Schaefer2018_400Parcels_17Networks_order_LUT.txt ${SF}/Schaefer2018_400Parcels_17Networks_order.txt  ${PP_DIR}/sf400_17_conv.mif

singularity exec ${mx} tck2connectome -force -symmetric -zero_diagonal -scale_invnodevol -tck_weights_in ${PP_DIR}/sift_1M.txt ${PP_DIR}/TK_10M.tck ${PP_DIR}/sf400_17_conv.mif ${PP_DIR}/sf400_17.csv -out_assignment ${PP_DIR}/assignments_sf400_17_parcels.csv


