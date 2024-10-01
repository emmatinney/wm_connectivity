#!/bin/bash
#SBATCH --time=24:0:0
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=24000
#SBATCH --job-name=aparc2aseg
#SBATCH --partition=short

export FREESURFER_HOME=$HOME/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
module load freesurfer

export SUBJECTS_DIR=/work/cnelab/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1
export GCS=/work/cnelab/code/wm_connectivity_related_code/gcs
export ATLAS=/work/cnelab/code/wm_connectivity_related_code/Schaefer/fsaverage/label
subj=REPLACE

#while read subj

#do
 # to perform this you will have to make sure the annot file is in everyone's folder
	mri_aparc2aseg --s sub-${subj} --o $SUBJECTS_DIR/sub-${subj}/mri/sf400_7.mgz --annot Schaefer2018_400Parcels_17Networks_order
	


#done < subj.txt

module load singularity
mx=/shared/container_repository/MRtrix/mrtrix3_3.0.4.sif
export SINGULARITY_BIND="/work/cnelab:/mnt,/shared/centos7"
SUBJID=REPLACE
FS_DIR=/mnt/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #where the already-run Freesurfer output is stored
FS_DIR_NS=/work/cnelab/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #non-singularity path to freesurfer folder
PP_DIR=/mnt/fitbir/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #where the additionally processed data are stored
PP_DIR_NS=/work/cnelab/fitbir/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #path to_ses-1-processed folder OUTSIDE singularity 
GCS=/mnt/code/wm_connectivity_related_code/gcs
ATLAS=/mnt/code/wm_connectivity_related_code/Schaefer
SUBJID=REPLACE

# this is to convert the labels to a format that MRtrix can read 
singularity exec ${mx} labelconvert -force ${FS_DIR}/mri/sf400_7.mgz ${ATLAS}/project2individual/Schaefer2018_400Parcels_17Networks_order_LUT.txt ${ATLAS}/Schaefer2018_400Parcels_17Networks_order.txt  ${PP_DIR}/sf400_17_conv.mif

singularity exec ${mx} tck2connectome -force -symmetric -zero_diagonal -scale_invnodevol -tck_weights_in ${PP_DIR}/sift_1M.txt ${PP_DIR}/TK_10M.tck ${PP_DIR}/sf400_17_conv.mif ${PP_DIR}/sf400_17.csv -out_assignment ${PP_DIR}/assignments_sf400_17_parcels.txt


