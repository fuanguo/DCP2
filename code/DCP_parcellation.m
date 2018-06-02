function DCP_parcellation(subFile,opt)
  DCP_bet([subFile filesep 'DCP_DTI_DATA' filesep 'dti_b0.nii'], opt.B0, [subFile filesep 'DCP_PARCELLATION'],1);
  DCP_bet([subFile filesep 'DCP_PARCELLATION' filesep 'T1.nii'], opt.T1, [subFile filesep 'DCP_PARCELLATION'],0);
  VG=spm_vol([subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']);
  VF=spm_vol([subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']);
 job.eoptions.cost_fun='nmi';eoptions.sep=[4,2];
 job.eoptions.tol=[ 0.0200,0.0200,0.0200,0.0010,0.0010,0.0010,0.0100,0.0100,0.0100,0.0010,0.0010,0.0010];
 job.eoptions.fwhm=[7,7];
 job.roptions.interp=1;job.roptions.wrap=[0,0,0];job.roptions.mask=0;job.roptions.prefix='r';
 job.ref={[subFile filesep 'DCP_DTI_DATA' filesep 'dti_b0.nii']};
 job.source= {[subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']};
 job.other={[]};
 if strcmp(opt.spm,'spm8')
    spm_run_coreg_estwrite(job);
 else
    spm_run_coreg(job);
 end
 mask_T1([subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii'],[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'])
 normaliseJob.subj.source={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii']};
 normaliseJob.subj.wtsrc='';
 normaliseJob.eoptions.template={[opt.template]};
 normaliseJob.eoptions.weight='';
 normaliseJob.eoptions.smosrc=8;
 normaliseJob.eoptions.smoref=0;
 normaliseJob.eoptions.regtype='mni';
 normaliseJob.eoptions.cutoff=25;
 normaliseJob.eoptions.nits=16;
 normaliseJob.eoptions.reg=1;
 if strcmp(opt.spm,'spm8')
    spm_run_normalise_estimate(normaliseJob);
 else
    spm_run_normalise(normaliseJob);
 end
 mfilePath=mfilename('fullpath');
 filesepIndex=regexp(mfilePath,filesep);
 parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
 if strcmp(opt.spm,'spm8')
     load([parentPath filesep 'cfg' filesep 'defJob.mat']);
     defJob.comp{1,1}.inv.comp{1,1}.sn2def.matname={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1_sn.mat']};
     defJob.comp{1,1}.inv.space={[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii,1']};
     defJob.fnames={opt.atlas};
     defJob.savedir.saveusr={[subFile filesep 'DCP_PARCELLATION' filesep]};
     defJob.interp=0;
     spm_defs(defJob);
 else
     spm12_deformations([subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1_sn.mat'],...
         [subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii'],opt.atlas,...
         [subFile filesep 'DCP_PARCELLATION' filesep]);
 end
end
function mask_T1(rT1File, maskFile)
    rT1 = spm_vol(rT1File);
    rT1_vol = spm_read_vols(rT1);
    mask = spm_vol(maskFile);
    mask_vol = spm_read_vols(mask);
    for i=1:rT1.dim(1),
        for j=1:rT1.dim(2),
            for k=1:rT1.dim(3),
                if mask_vol(i, j, k)==0,
                    rT1_vol(i, j, k)=0;
                end
            end
        end
    end
    rT1 = spm_write_vol(rT1, rT1_vol);
return
end
function spm12_deformations(matname,space,fname,saveusr)
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname = {matname};
matlabbatch{1}.spm.util.defs.comp{1}.inv.space = {space};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {fname};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {saveusr};
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'w';
spm_jobman('run',matlabbatch);
end