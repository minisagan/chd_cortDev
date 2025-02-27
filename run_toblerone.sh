#!/bin/zsh 

dataset=CHD
dwidir=/data2/Recon07data/${dataset}/ShardRecon04
T2dir=/data2/Recon07data/${dataset}/derivatives 
diffFolder=/data2/Recon07data/${dataset}

subject_list="/home/sma22/Desktop/Recon07/${dataset}/sub_ses_ga_pma_new.txt"

while read subjid sesid ga pma; do
    echo "Processing subject: ${subjid}, session: ${sesid}, GA: ${ga}, PMA: ${pma}"
    python /home/sma22/Desktop/Recon07/scripts/run_toblerone.py \
        "${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native/sub-${subjid}_ses-${sesid}_left_white.surf.gii" \
        "${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native/sub-${subjid}_ses-${sesid}_left_pial.surf.gii" \
        "${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native/sub-${subjid}_ses-${sesid}_right_white.surf.gii" \
        "${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native/sub-${subjid}_ses-${sesid}_right_pial.surf.gii" \
        "${dwidir}/sub-${subjid}/ses-${sesid}/postmc_dstriped-dwi.nii.gz" \
        "${diffFolder}/xfms/sub-${subjid}_ses-${sesid}_str2diff.mat" \
        "${T2dir}/sub-${subjid}/ses-${sesid}/anat/sub-${subjid}_ses-${sesid}_T2w_restore_brain.nii.gz" \
        "${T2dir}"
done < "${subject_list}"
