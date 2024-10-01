# Connectome-based analysis after preprocessing in MRtrix3
## Lots of steps were from Andy's brain book: https://andysbrainbook.readthedocs.io/en/latest/MRtrix/MRtrix_Course

1. Make sure you have all the preprocessed files and QC-ed
   5tt_hsvs2MEANB0.mif
   WM_FOD_NORM.mif

2. Run seed.boundary.script   
   Purpose of this is to define grey matter boundary to prepare for fiber tracking

3. Run tracking.fiber.script
   This is for fiber tracking for the whole brain; 

4. Run sift.adjtrk.script
   This is to further refine the streamlines incase of bias in specific bundle

5. Create connectome 
* if you wanted to use the default atlas from FREESURFER, you can simply follow along Andy's brain book tutorial. The following steps are examples for using alternating parcellations (In this case I used Schaefer 400_7)

6. run schaefer2vol.sh # this is to create a schaefer-version in individual volume space

7. run create.connectome.sbatch # this is to create the matrixes of your connectome!

