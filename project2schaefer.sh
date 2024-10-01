#!/bin/bash
export FREESURFER_HOME=$HOME/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh


export SUBJECTS_DIR=/work/cbhlab/BIDS_PreventAD/freesurfer
export GCS=/work/cbhlab/Meishan/Atlases/Schaefer/gcs
export ATLAS=/work/cbhlab/Meishan/Atlases/Schaefer

while read subj

do
# this is to get parcellation in individual space
	mri_surf2surf \
	--srcsubject fsaverage \
	--trgsubject $subj \
	--hemi lh \
	--sval-annot $ATLAS/lh.Schaefer2018_400Parcels_7Networks_order.annot \
	--tval $SUBJECTS_DIR/$subj/FREESURFER/label/lh.Schaefer2018_400Parcels_7Networks_order.annot

	mri_surf2surf \
	--srcsubject fsaverage \
	--trgsubject $subj \
	--hemi rh \
	--sval-annot $ATLAS/rh.Schaefer2018_400Parcels_7Networks_order.annot  \
	--tval $SUBJECTS_DIR/$subj/FREESURFER/label/rh.Schaefer2018_400Parcels_7Networks_order.annot 
	
	mris_ca_label -l $SUBJECTS_DIR/${subj}/label/lh.cortex.label \
  	${subj}  lh $SUBJECTS_DIR/${subj}/surf/lh.sphere.reg \
  	$GCS/lh.Schaefer2018_400Parcels_17Networks.gcs \
  	$SUBJECTS_DIR/${subj}/label/lh.Schaefer2018_400Parcels_17Networks_order.annot
	
	cp  $SUBJECTS_DIR/${subj}/label/lh.Schaefer2018_400Parcels_17Networks_order.annot /scratch/ai.me/data/${subj}/FREESURFER/label/

	mris_ca_label -l $SUBJECTS_DIR/${subj}/label/rh.cortex.label \
  	${subj}  rh $SUBJECTS_DIR/${subj}/surf/rh.sphere.reg \
  	$GCS/rh.Schaefer2018_400Parcels_17Networks.gcs \
 	$SUBJECTS_DIR/${subj}/label/rh.Schaefer2018_400Parcels_17Networks_order.annot
	
	cp $SUBJECTS_DIR/${subj}/label/rh.Schaefer2018_400Parcels_17Networks_order.annot /scratch/ai.me/data/${subj}/FREESURFER/label
/

done < sublist_QC.txt
