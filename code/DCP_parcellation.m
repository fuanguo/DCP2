function DCP_parcellation(subFile,opt,pi)
  if pi==1
    DCP_bet([subFile filesep 'DCP_DTI_DATA' filesep 'dti_b0.nii'], opt.B0, [subFile filesep 'DCP_PARCELLATION'],1);
  else
      bedpostX=dir(strcat(subFile,'*.bedpostX'));
      bedpostx_path=bedpostX(1).name;
      
      mkdir(strcat(subFile,'DCP_DTI_DATA'));
      copyfile(strcat(subFile,bedpostx_path,'\nodif_brain.nii.gz'),strcat(subFile,'DCP_DTI_DATA\dti_b0.nii.gz'));
      copyfile(strcat(subFile,bedpostx_path,'\dti_FA.nii.gz'),strcat(subFile,'DCP_DTI_DATA\dti_fa.nii.gz'));
      copyfile(strcat(subFile,bedpostx_path,'\dti_MD.nii.gz'),strcat(subFile,'DCP_DTI_DATA\dti_adc.nii.gz'));
      gunzip(strcat(subFile,'DCP_DTI_DATA\dti_b0.nii.gz'));
      gunzip(strcat(subFile,'DCP_DTI_DATA\dti_fa.nii.gz'));
      gunzip(strcat(subFile,'DCP_DTI_DATA\dti_adc.nii.gz'));
      
      mkdir(strcat(subFile,'DCP_PARCELLATION'));
      t1_file=dir(strcat(subFile,'T1\co*.nii'));
      copyfile(strcat(subFile,'T1\',t1_file(1).name),strcat(subFile,'DCP_PARCELLATION\T1.nii'));
      
      copyfile(strcat(subFile,bedpostx_path,'\nodif_brain.nii.gz'),strcat(subFile,'DCP_PARCELLATION\bet_dti_b0.nii.gz'));
      copyfile(strcat(subFile,bedpostx_path,'\nodif_brain_mask.nii.gz'),strcat(subFile,'DCP_PARCELLATION\bet_dti_b0_mask.nii.gz'));
      gunzip(strcat(subFile,'DCP_PARCELLATION\bet_dti_b0_mask.nii.gz'));
      gunzip(strcat(subFile,'DCP_PARCELLATION\bet_dti_b0.nii.gz'));
  end
  DCP_bet([subFile filesep 'DCP_PARCELLATION' filesep 'T1.nii'], opt.T1, [subFile filesep 'DCP_PARCELLATION'],0);
  if pi==1
      DCP_reorient([subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']);
      DCP_reorient([subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']);
  end
  VG=spm_vol([subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']);
  VF=spm_vol([subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']);
  mfilePath=mfilename('fullpath');
  filesepIndex=regexp(mfilePath,filesep);
  parentPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
 
%  if strcmp(opt.spm,'spm8')
%     job.eoptions.cost_fun='nmi';eoptions.sep=[4,2];
%     job.eoptions.tol=[ 0.0200,0.0200,0.0200,0.0010,0.0010,0.0010,0.0100,0.0100,0.0100,0.0010,0.0010,0.0010];
%     job.eoptions.fwhm=[7,7];
%     job.roptions.interp=1;job.roptions.wrap=[0,0,0];job.roptions.mask=0;job.roptions.prefix='r';
%     job.ref={[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']};
%     job.source= {[subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']};
%     job.other={[]};
%     spm_run_coreg_estwrite(job);
%  else
    load([parentPath filesep 'cfg' filesep 'CorJob12.mat']);
    matlabbatch{1, 1}.spm.spatial.coreg.estwrite.ref={[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']};
    matlabbatch{1, 1}.spm.spatial.coreg.estwrite.source= {[subFile filesep 'DCP_PARCELLATION' filesep 'bet_T1.nii']};
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
%  end
 mask_T1([subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii'],[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'])
%  if strcmp(opt.spm,'spm8')
%     normaliseJob.subj.source={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii']};
%     normaliseJob.subj.wtsrc='';
%     normaliseJob.eoptions.template={[opt.template]};
%     normaliseJob.eoptions.weight='';
%     normaliseJob.eoptions.smosrc=8;
%     normaliseJob.eoptions.smoref=0;
%     normaliseJob.eoptions.regtype='mni';
%     normaliseJob.eoptions.cutoff=25;
%     normaliseJob.eoptions.nits=16;
%     normaliseJob.eoptions.reg=1;
%     spm_run_normalise_estimate(normaliseJob);
%  else
%     load([parentPath filesep 'cfg' filesep 'NorJob12.mat']);
%     matlabbatch{1, 1}.spm.tools.oldnorm.est.subj.source={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii']};
%     matlabbatch{1, 1}.spm.tools.oldnorm.est.eoptions.template={[opt.template]};
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch;
    load([parentPath filesep 'cfg' filesep 'segNorm12.mat']);
    matlabbatch{1, 1}.spm.spatial.preproc.channel.vols={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii']};
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
%  end

%  if strcmp(opt.spm,'spm8')
%     load([parentPath filesep 'cfg' filesep 'defJob.mat']);
%     defJob.comp{1,1}.inv.comp{1,1}.sn2def.matname={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1_sn.mat']};
%     defJob.comp{1,1}.inv.space={[subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']};
%     defJob.fnames={atlas};
%     defJob.savedir.saveusr={[subFile filesep 'DCP_PARCELLATION' filesep]};
%     defJob.interp=0;
%     spm_defs(defJob);
%  else
%      load([parentPath filesep 'cfg' filesep 'defJob12.mat']);
%      matlabbatch{1, 1}.spm.util.defs.comp{1, 1}.inv.comp{1, 1}.sn2def.matname={[subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1_sn.mat']};
%      matlabbatch{1, 1}.spm.util.defs.comp{1, 1}.inv.space={[subFile 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']};
%      matlabbatch{1, 1}.spm.util.defs.out{1, 1}.pull.savedir.saveusr={[subFile filesep 'DCP_PARCELLATION' filesep]};
%      matlabbatch{1, 1}.spm.util.defs.out{1, 1}.pull.fnames={atlas};
%      spm_jobman('run',matlabbatch);
%      clear matlabbatch;
    load([parentPath filesep 'cfg' filesep 'Nor_w_Job12.mat']);
    matlabbatch{1, 1}.spm.spatial.normalise.write.subj.def={[subFile 'DCP_PARCELLATION' filesep 'iy_rbet_T1.nii']};
    hd=spm_vol([subFile 'DCP_PARCELLATION' filesep 'bet_dti_b0.nii']);
    mat=hd.mat;
    dim=hd.dim;
    for i=1:3
        for j=1:3
            if mat(i,j)*mat(i,4)>0
                if mat(i,4)>0
                    array_min(j,i)=1;
                    array_max(j,i)=dim(j);
                else
                    array_min(j,i)=dim(j);
                    array_max(j,i)=1;
                end
            else
                if mat(i,4)>0
                    array_min(j,i)=dim(j);
                    array_max(j,i)=1;
                else
                    array_min(j,i)=1;
                    array_max(j,i)=dim(j);
                end
            end
        end
        array_min(4,i)=1;
        array_max(4,i)=1;
    end
    b_min=round(mat*array_min);
    b_max=round(mat*array_max);
   for i=1:3
       vox(i)=sqrt(mat(i,1)^2+mat(i,2)^2+mat(i,3)^2);
       bb(1,i)=b_min(i,i);
       bb(2,i)=b_max(i,i);
   end
    
%     for i=1:3
%         vox(i)=abs(hd.mat(i,i));
%         if bb(1,i)>0
%             temp=bb(1,i);
%             bb(1,i)=bb(2,i);
%             bb(2,i)=temp;
%         end
% %         bb(1,i)=floor(bb(1,i));
% %         bb(2,i)=ceil(bb(2,i));
%     end
    matlabbatch{1, 1}.spm.spatial.normalise.write.woptions.bb=bb;
    matlabbatch{1, 1}.spm.spatial.normalise.write.woptions.vox=vox;
    for i=1:length(opt.atlas)
        atlas=cell2mat(opt.atlas(i));
        
        matlabbatch{1, 1}.spm.spatial.normalise.write.subj.resample={atlas};
        
        spm_jobman('run',matlabbatch);
        [ImagePath, FileName, extname] = fileparts(which('DCP.m'));
        [~,atlasName,~]=fileparts(atlas);
        
        movefile([ImagePath filesep 'templates' filesep 'w' atlasName '.nii'],[subFile filesep 'DCP_PARCELLATION']);

    %  end
     %[~,atlasName,~]=fileparts(atlas);
%       NormalizeCHk([subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii'],...
%           [subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'],...
%           [subFile filesep 'DCP_PARCELLATION' filesep 'T1_b0.tiff']);
%       NormalizeCHk([subFile filesep 'DCP_PARCELLATION' filesep 'w' atlasName '.nii'],...
%           [subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'],...
%           [subFile filesep 'DCP_PARCELLATION' filesep 'w' atlasName '_b0.tiff']);
    %  delete([subFile filesep 'DCP_PARCELLATION' filesep '*_dti_b0*.nii']);
    end
    
    clear matlabbatch;
    load([parentPath filesep 'cfg' filesep 'ResliceJob12.mat']);
    for i=1:length(opt.atlas)
        atlas=cell2mat(opt.atlas(i));
        [~,atlasName,~]=fileparts(atlas);
         matlabbatch{1, 1}.spm.spatial.coreg.write.ref={strcat(subFile,'DCP_PARCELLATION\bet_dti_b0.nii,1')};
         matlabbatch{1, 1}.spm.spatial.coreg.write.source={strcat(subFile,'DCP_PARCELLATION\w',atlasName,'.nii,1')};
         spm_jobman('run',matlabbatch);
        delete([subFile,'DCP_PARCELLATION' filesep 'w' atlasName '.nii']);
        movefile([subFile,'DCP_PARCELLATION' filesep 'rw' atlasName '.nii'],[subFile,'DCP_PARCELLATION' filesep 'w' atlasName '.nii']);
        NormalizeCHk([subFile filesep 'DCP_PARCELLATION' filesep 'rbet_T1.nii'],...
          [subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'],...
          [subFile filesep 'DCP_PARCELLATION' filesep 'T1_b0.tiff']);
        NormalizeCHk([subFile filesep 'DCP_PARCELLATION' filesep 'w' atlasName '.nii'],...
          [subFile filesep 'DCP_PARCELLATION' filesep 'bet_dti_b0_mask.nii'],...
          [subFile filesep 'DCP_PARCELLATION' filesep 'w' atlasName '_b0.tiff']);
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
function NormalizeCHk(sourceFile, overlayFile, TIFFile)
ch2_hdr=spm_vol(sourceFile);
ch2_vol=spm_read_vols(ch2_hdr);
maxlim = max(ch2_hdr.dim)+2;
s1 = zeros(ch2_hdr.dim(2),ch2_hdr.dim(3));
s2 = zeros(ch2_hdr.dim(1),ch2_hdr.dim(3));
s3 = zeros(ch2_hdr.dim(1),ch2_hdr.dim(2));    
s1(1:ch2_hdr.dim(2),1:ch2_hdr.dim(3)) = ch2_vol(floor(ch2_hdr.dim(1)/2),:,:);
s2(1:ch2_hdr.dim(1),1:ch2_hdr.dim(3)) = ch2_vol(:,floor(ch2_hdr.dim(2)/2),:);
s3(1:ch2_hdr.dim(1),1:ch2_hdr.dim(2)) = ch2_vol(:,:,floor(ch2_hdr.dim(3)/2));
% c_view_u=ch2_vol(:,ceil(end/2),:);
% c_view_u=squeeze(c_view_u)';
% c_view_u=c_view_u(end:-1:1,:);
% c_view_u=c_view_u./max(c_view_u(:))*255;
    
% s_view_u=ch2_vol(ceil(end/2),:,:);
% s_view_u=squeeze(s_view_u)';
% s_view_u=s_view_u(end:-1:1,:);
% s_view_u=s_view_u./max(s_view_u(:))*255;

% a_view_u=ch2_vol(:,:,ceil(end/2));
% a_view_u=squeeze(a_view_u)';
% a_view_u=a_view_u(end:-1:1,:);
% a_view_u=a_view_u./max(a_view_u(:))*255;
    
ABCGs1 =getABCgrayimage(s1);
ABCGs2 =getABCgrayimage(s2);
ABCGs3 =getABCgrayimage(s3);
ABCGsall = zeros(maxlim,maxlim*3);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(3)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(3)/2)),1:ch2_hdr.dim(2)) = rot90(ABCGs1);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(3)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(3)/2)),maxlim+1:maxlim+ch2_hdr.dim(1)) = rot90(ABCGs2);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(2)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(2)/2)),2*maxlim+1:2*maxlim+ch2_hdr.dim(1))  = rot90(ABCGs3);
underlay=repmat(ABCGsall, [1, 1, 3]);

mean_hdr=spm_vol(overlayFile);
mean_vol=spm_read_vols(mean_hdr);

maxlim = max(mean_hdr.dim)+2;
s1 = zeros(mean_hdr.dim(2),mean_hdr.dim(3));
s2 = zeros(mean_hdr.dim(1),mean_hdr.dim(3));
s3 = zeros(mean_hdr.dim(1),mean_hdr.dim(2));    
s1(1:mean_hdr.dim(2),1:mean_hdr.dim(3)) = mean_vol(floor(mean_hdr.dim(1)/2),:,:);
s2(1:mean_hdr.dim(1),1:mean_hdr.dim(3)) = mean_vol(:,floor(mean_hdr.dim(2)/2),:);
s3(1:mean_hdr.dim(1),1:mean_hdr.dim(2)) = mean_vol(:,:,floor(mean_hdr.dim(3)/2));
% c_view_o=mean_vol(:,ceil(end/2),:);
% c_view_o=squeeze(c_view_o)';
% c_view_o=c_view_o(end:-1:1,:);
% c_view_o=c_view_o./max(c_view_o(:))*255;
        
% s_view_o=mean_vol(ceil(end/2),:,:);
% s_view_o=squeeze(s_view_o)';
% s_view_o=s_view_o(end:-1:1,:);
% s_view_o=s_view_o./max(s_view_o(:))*255;
        
% a_view_o=mean_vol(:,:,ceil(end/2));
% a_view_o=squeeze(a_view_o)';
% a_view_o=a_view_o(end:-1:1,:);
% a_view_o=a_view_o./max(a_view_o(:))*255;
        
ABCGs1 =getABCgrayimage(s1);
ABCGs2 =getABCgrayimage(s2);
ABCGs3 =getABCgrayimage(s3);
ABCGsall = zeros(maxlim,maxlim*3);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(3)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(3)/2)),1:ch2_hdr.dim(2)) = rot90(ABCGs1);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(3)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(3)/2)),maxlim+1:maxlim+ch2_hdr.dim(1)) = rot90(ABCGs2);
ABCGsall(floor((maxlim/2)-(ch2_hdr.dim(2)/2))+1:floor((maxlim/2)+(ch2_hdr.dim(2)/2)),2*maxlim+1:2*maxlim+ch2_hdr.dim(1))  = rot90(ABCGs3);
overlay=repmat(ABCGsall, [1, 1, 3]);
overlay(:,:,2:3)=overlay(:,:,2:3)/1.5;
%outputimg=imresize(imadd_(underlay./2,overlay./2),2);
outputimg=imresize(((underlay./2)+(overlay./2)),2);
        
imwrite(outputimg, TIFFile);
end

function new_mat=imadd_(mat1,mat2)
new_mat=mat1;
for i=1:size(mat1,1)
    for j=1:size(mat1,2)
        for k=1:size(mat1,3)
            new_mat(i,j,k)=mat1(i,j,k)+mat2(i,j,k);
        end
    end
end
end


function ABCGvolume =getABCgrayimage(volume)
	Result =volume;
	%Save Maping Image parameters, Auto balance 20070911 revised, 20070914 revised for Statistical map which has negative values	
	%Revise first
	Result(isnan(Result)) =0;
	Result(isinf(Result)) =0;
	%Begin computation, the following two lines are time-consuming up to 4.6 seconds!!!
	%But after replacing AConfig with Result, then their speed rocketed to 0.2 seconds!!!
	%Attention!!! Dawnwei.Song, 20070914
	theMaxVal=max(Result(:));
	theMinVal=min(Result(:));
	if theMaxVal>theMinVal,
		nBins=255;
		%Special processing just for very common images! 20071212
		if (theMaxVal<257) && (theMinVal>=0) && (theMaxVal-theMinVal>100), %not statistic map
			theSum =histc(Result(:), 1:ceil(theMaxVal));		
		else
			theSum =histc(Result(:), theMinVal:(theMaxVal-theMinVal)/254:theMaxVal);		
		end
		theSum =cumsum(theSum);
		theCdf =theSum/theSum(end);
        FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
        if FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=7*1000+3    %YAN Chao-Gan, 101025. Fixed a bug when displaying in MATLAB 2010.
		%if rest_misc('GetMatlabVersion')>=7.3
			idxSatMin =find(theCdf>0.01, 1, 'first');
			idxSatMax =find(theCdf>=0.99, 1, 'first');			
		else
			idxSatMin =find(theCdf>0.01);
			idxSatMin =idxSatMin(1);
			idxSatMax =find(theCdf>=0.99);
			idxSatMax =idxSatMax(1);
		end	
		if idxSatMin==idxSatMax, idxSatMin =1; end	%20070919, For mask file's display
		theSatMin =(idxSatMin-1)/(nBins-1) *(theMaxVal-theMinVal) +theMinVal;
		theSatMax =(idxSatMax-1)/(nBins-1) *(theMaxVal-theMinVal) +theMinVal;	
	elseif theMaxVal==theMinVal,
		theSatMin =theMaxVal;
		theSatMax =theMaxVal;
	else
    end
	ABCGvolume =volume;
	if theSatMin<theSatMax,
		ABCGvolume(find(ABCGvolume<theSatMin)) =theSatMin;
		ABCGvolume(find(ABCGvolume>theSatMax)) =theSatMax;
		ABCGvolume =(ABCGvolume -theSatMin)/(theSatMax - theSatMin);
	elseif theSatMin==theSatMax,
		ABCGvolume(:) =0.01;
	else
		error('ASatMin>ASatMax ???');
    end
end