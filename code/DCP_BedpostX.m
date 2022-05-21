function DCP_BedpostX(subFile)
bedpostx_path=strcat(subFile,'Bedpost_File');
if exist(bedpostx_path,'dir')==0
    mkdir(bedpostx_path);
end
copyfile([subFile 'DCP_DTI_DATA' filesep 'bval'],[bedpostx_path filesep 'bvals']);
copyfile([subFile 'DCP_DTI_DATA' filesep 'bvec'],[bedpostx_path filesep 'bvecs']);
copyfile([subFile 'DCP_DTI_DATA' filesep 'eddy_DATA_4D.nii.gz'],[bedpostx_path filesep 'data.nii.gz']);
copyfile([subFile 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'],[bedpostx_path filesep 'nodif_brain_mask.nii']);
command=strcat('docker run --rm -v',32,subFile,':/data forsaint/mnp-fsl bash -c "cd data&&bedpostx ./Bedpost_File -model 1"');
[status,cmdout] = system(command);

end