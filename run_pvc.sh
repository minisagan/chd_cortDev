#!/bin/zsh

dataset=dHCP
dwidir=/data2/Recon07data/${dataset}/ShardRecon04
T2dir=/data2/Recon07data/${dataset}/derivatives
diffFolder=/data2/Recon07data/${dataset}

subject_list="/home/sma22/Desktop/Recon07/${dataset}/sub_ses_ga_pma_new.txt"

while read subjid sesid ga pma; do
    echo "Processing subject: ${subjid}, session: ${sesid}, GA: ${ga}, PMA: ${pma}"

    mkdir -p ${T2dir}/sub-${subjid}/ses-${sesid}/anat/PVC
    mkdir -p ${dwidir}/sub-${subjid}/ses-${sesid}/PVC

    #for metric in fa md ; do
    for metric in NDI ODI ; do
    #u8pdate dwi image native for ndi and odi 
        for hemi in left right; do
	    #this is actually the metric? 
            #dwi_image_native="${dwidir}/sub-${subjid}/ses-${sesid}/${metric}.nii.gz"
            dwi_image_native="${dwidir}/sub-${subjid}/ses-${sesid}/Diffusion/diff-1.3E-3/dMRI/AMICO/NODDI/fit_${metric}.nii.gz"
            pve_toblerone="${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native/sub-${subjid}_ses-${sesid}_pve.nii.gz"
            dwi_mask_native="${dwidir}/sub-${subjid}/ses-${sesid}/reconmask.nii.gz"
            t2dwi_mat="${diffFolder}/xfms/sub-${subjid}_ses-${sesid}_str2diff.mat"
            t2_image="${T2dir}/sub-${subjid}/ses-${sesid}/anat/sub-${subjid}_ses-${sesid}_T2w_restore_brain.nii.gz"
            native_surf="${T2dir}/sub-${subjid}/ses-${sesid}/anat/Native"
            pvc_dir="${T2dir}/sub-${subjid}/ses-${sesid}/anat/PVC"
            dwi_surf_dir="${dwidir}/sub-${subjid}/ses-${sesid}/PVC"
            surf_transf="${diffFolder}/surface_processing/surface_transforms/surface_transforms"
            
            template_spheres="/data1/dHCP/dhcpSym_template/week-40_hemi-${hemi}_space-dhcpSym_dens-32k_sphere.surf.gii"
            bad_vertex_rois="${dwidir}/sub-${subjid}/ses-${sesid}/PVC"

            # Print missing files for debugging
            for file in "$dwi_image_native" "$pve_toblerone" "$dwi_mask_native" "$t2dwi_mat" "$t2_image" "$template_spheres"; do
                if [[ ! -f "$file" ]]; then
                    echo "Missing file: $file"
                fi
            done

            # Skip if any required file is missing
            if [[ ! -f "$dwi_image_native" || ! -f "$pve_toblerone" || ! -f "$dwi_mask_native" || ! -f "$t2dwi_mat" || ! -f "$t2_image" || ! -f "$template_spheres" ]]; then
                echo "Skipping ${subjid} ${metric} ${hemi} due to missing files."
                continue
            fi

            # Run Python script
            python /home/sma22/Desktop/Recon07/scripts/run_pvc.py \
                "sub-${subjid}_ses-${sesid}" \
                "${metric}" \
                "${dwi_image_native}" \
                "${pve_toblerone}" \
                "${dwi_mask_native}" \
                "${t2dwi_mat}" \
                "${t2_image}" \
                "${native_surf}" \
                "${pvc_dir}" \
                "${dwi_surf_dir}" \
                "${surf_transf}" \
                "${template_spheres}" \
                "${bad_vertex_rois}"

        done
    done
done < "${subject_list}"


