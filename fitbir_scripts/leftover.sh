#!/bin/bash
#SBATCH --time=24:0:0
#SBATCH --nodes=2
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=32000
#SBATCH --job-name=5tt2gmwmi
#SBATCH --partition=short
#to prepare for fiber tracking
	module load singularity
#	SUBJID=`sed "${SLURM_ARRAY_TASK_ID}q;d" /work/cnelab/fitbir/DTI_raw/subj.txt`
	SUBJID=REPLACE

	RAW_DIR=/mnt/DTI_raw/DTI_data/BIDS_merged/sub-${SUBJID}/ses-1/dwi #where the raw DWI data are stored
	RAW_DIR_NS=/work/cnelab/fitbir/DTI_raw/DTI_data/BIDS_merged/sub-${SUBJID}/ses-1/dwi
	FS_DIR=/mnt/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #where the already-run Freesurfer output is stored
	FS_DIR_NS=/work/cnelab/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #non-singularity path to freesurfer folder
	SUBJECTS_DIR=/work/cnelab/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #for freesurfer commands
	PP_DIR=/mnt/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #where the additionally processed data are stored
	PP_DIR_NS=/work/cnelab/fitbir/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #path to_ses-1-processed folder OUTSIDE singularity 
	RF_DIR=/work/cnelab/fitbir/DTI_raw/DTI_data/mrtrix_pp/GROUP-RF
	export SINGULARITY_BIND="/work/cnelab/fitbir:/mnt,/shared/centos7"

	mx=/shared/container_repository/MRtrix/mrtrix3_3.0.4.sif
	MX=/shared/container_repository/MRtrix/mrtrix_ubuntu.sif
	module unload fsl/6.0.0
    module unload freesurfer
    SUBJECTS_DIR=/work/cnelab/fitbir/fMRI_raw/all_data_ses-1/derivatives/freesurfer_7.2.0/ses-1/sub-${SUBJID} #for freesurfer commands
    singularity exec --nv ${MX} 5ttgen -nocrop hsvs ${FS_DIR} ${PP_DIR}/5tt_hsvs.nii.gz #note save as .nii.gz because want to apply transforms to this outside of mrtrix 	
    module load freesurfer
    mri_vol2vol --mov ${PP_DIR_NS}/MEANB0.nii.gz --targ ${PP_DIR_NS}/5tt_hsvs.nii.gz --lta ${PP_DIR_NS}/MEANB02MRIFS.lta --inv --interp nearest --o ${PP_DIR_NS}/5tt_hsvs2MEANB0.nii.gz

	#First a template is optimized with linear registration (rigid and/or affine, both by default), then non-linear registration is used to optimise the template further.
	singularity exec ${mx} mrconvert ${PP_DIR}/5tt_hsvs2MEANB0.nii.gz ${PP_DIR}/5tt_hsvs2MEANB0.mif -force
	singularity exec ${mx} 5tt2gmwmi ${PP_DIR}/5tt_hsvs2MEANB0.mif ${PP_DIR}/gmwmSeed_hsvs2MEANB0.mif -force
    #a 10millions of streamlines will be generated with a threshold of FOD values = 0.06.
	singularity exec ${mx} tckgen -act ${PP_DIR}/5tt_hsvs2MEANB0.mif -backtrack -seed_gmwmi ${PP_DIR}/gmwmSeed_hsvs2MEANB0.mif -nthreads 8 -maxlength 250 -cutoff 0.06 -select 10000000 ${PP_DIR}/WM_FOD_GROUPAVG_RF_NORM.mif ${PP_DIR}/TK_10M.tck -force 
	# this is to generate a file with less streamlines so we can visualize it in mrview
	singularity exec ${mx} tckedit ${PP_DIR}/TK_10M.tck -number 200k ${PP_DIR}/smallerTK_200k.tck -force
    # to make sure the streamlines were proportional of the fiber density between two ROIs
	singularity exec ${mx} tcksift2 -act ${PP_DIR}/5tt_hsvs2MEANB0.mif -out_mu ${PP_DIR}/sift_mu.txt -out_coeffs ${PP_DIR}/sift_coeffs.txt -nthreads 8 ${PP_DIR}/TK_10M.tck ${PP_DIR}/WM_FOD_GROUPAVG_RF_NORM.mif ${PP_DIR}/sift_1M.txt -force
