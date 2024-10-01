#!/bin/bash
#SBATCH --time=24:0:0
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=24000
#SBATCH --job-name=aparc2aseg
#SBATCH --partition=short
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ai.me@northeastern.edu
export FREESURFER_HOME=$HOME/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh


export SUBJECTS_DIR=/work/cbhlab/BIDS_PreventAD/freesurfer
export GCS=/work/cbhlab/Meishan/Atlases/Schaefer/gcs


while read subj

do
 # to perform this you will have to make sure the annot file is in everyone's folder
	mri_aparc2aseg --s ${subj} --o $SUBJECTS_DIR/${subj}/mri/sf400_7.mgz --annot Schaefer2018_400Parcels_17Networks_order
	
	cp $SUBJECTS_DIR/${subj}/mri/sf400_7.mgz  /scratch/ai.me/data/${subj}/FREESURFER/mri


done < sublist_QC.txt
