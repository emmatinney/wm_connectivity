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

	PP_DIR=/mnt/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #where the additionally processed data are stored
	PP_DIR_NS=/work/cnelab/fitbir/DTI_raw/DTI_data/mrtrix_pp/${SUBJID} #path to_ses-1-processed folder OUTSIDE singularity 
	export SINGULARITY_BIND="/work/cnelab/fitbir:/mnt,/shared/centos7"

	mx=/shared/container_repository/MRtrix/mrtrix3_3.0.4.sif
	
	singularity exec ${mx} tcksift2 -act ${PP_DIR}/5tt_hsvs2MEANB0.mif -out_mu ${PP_DIR}/sift_mu.txt -out_coeffs ${PP_DIR}/sift_coeffs.txt -nthreads 8 ${PP_DIR}/TK_10M.tck ${PP_DIR}/WM_FOD_GROUPAVG_RF_NORM.mif ${PP_DIR}/sift_1M.txt -force
