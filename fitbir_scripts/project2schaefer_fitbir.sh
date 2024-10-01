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
# this is to get parcellation in individual space
	mri_surf2surf \
	--srcsubject fsaverage \
	--trgsubject sub-${subj} \
	--hemi lh \
	--sval-annot $ATLAS/lh.Schaefer2018_400Parcels_7Networks_order.annot \
	--tval $SUBJECTS_DIR/sub-${subj}/label/lh.Schaefer2018_400Parcels_7Networks_order.annot

	mri_surf2surf \
	--srcsubject fsaverage \
	--trgsubject sub-${subj} \
	--hemi rh \
	--sval-annot $ATLAS/rh.Schaefer2018_400Parcels_7Networks_order.annot  \
	--tval $SUBJECTS_DIR/sub-${subj}/label/rh.Schaefer2018_400Parcels_7Networks_order.annot 
	
	mris_ca_label -l $SUBJECTS_DIR/sub-${subj}/label/lh.cortex.label \
  	sub-${subj}  lh $SUBJECTS_DIR/sub-${subj}/surf/lh.sphere.reg \
  	$GCS/lh.Schaefer2018_400Parcels_17Networks.gcs \
  	$SUBJECTS_DIR/sub-${subj}/label/lh.Schaefer2018_400Parcels_17Networks_order.annot
	
	cp  $SUBJECTS_DIR/sub-${subj}/label/lh.Schaefer2018_400Parcels_17Networks_order.annot /${SUBJECTS_DIR}/sub-${subj}/label/

	mris_ca_label -l $SUBJECTS_DIR/sub-${subj}/label/rh.cortex.label \
    sub-${subj}  rh $SUBJECTS_DIR/sub-${subj}/surf/rh.sphere.reg \
  	$GCS/rh.Schaefer2018_400Parcels_17Networks.gcs \
 	$SUBJECTS_DIR/sub-${subj}/label/rh.Schaefer2018_400Parcels_17Networks_order.annot
	
	cp $SUBJECTS_DIR/sub-${subj}/label/rh.Schaefer2018_400Parcels_17Networks_order.annot /${SUBJECTS_DIR}/sub-${subj}/label/
/

#done < subj.txt
