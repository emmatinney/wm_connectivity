#!/bin/bash

cd /scratch/ai.me/data/CONN_analysis

for i in {1..154}

do 
	mat=$(sed -n $i'p' mat_list_HCP_func.txt) 
	id=$(sed -n $i'p' /scratch/ai.me/data/scripts/sublist_QC.txt)
	cp $mat /work/cbhlab/Meishan/CR_DTI/PAD_DTI_CR/2020scan/SC_FC/fc/${id}_fc_HCPMMP.mat

done 
