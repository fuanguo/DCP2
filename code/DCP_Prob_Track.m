function DCP_Prob_Track(subFile,opt)
if(opt.flag==1)
    DCP_BedpostX(subFile);
end
bedpostX=dir(strcat(subFile,'*.bedpostX'));
bedpostx_path=bedpostX(1).name;
%for i=1:length(bedpostx_path)
%    if bedpostx_path(i)=='\'
%        bedpostx_path(i)='/';
%    end
%end
curvethresh=opt.curvethresh;
curveinterval=opt.curveinterval;
bedpostxminf=opt.bedpostxminf;
stepsize=opt.stepsize;
tracker_type=opt.tracker_type;
interpolator_type=opt.interpolator_type;
mintractlength=opt.mintractlength;
maxtractlength=opt.maxtractlength;
switch upper(tracker_type)
    case 1
        tracker='fact';
    case 2
        tracker='euler';
    case 3
        tracker='rk4';
end
switch upper(interpolator_type)
    case 1
        interpolator='nn';
    case 2
        interpolator='prob_nn';
    case 3
        interpolator='linear';
    case 4
        interpolator='tend';
    case 5
        interpolator='tend_prob_nn';
    case 6
        interpolator='dwi_linear';
end

% command_bet=strcat('docker run --rm -v',32,subFile,...
%     ':/data fsl_camino bash -c "cd data&&mkdir DCP_DTI_DATA/seed_file&&bet /data/DCP_PARCELLATION/T1.nii DCP_DTI_DATA/seed_file/T1_brain.nii.gz',...
%     '&&fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -b -o /data/DCP_DTI_DATA/seed_file/T1_brain.nii.gz"');
% [status,cmdout] = system(command_bet);
% command_get_mat=strcat('docker run --rm -v',32,subFile,':/data fsl_camino bash -c "cd data&&flirt -in',32,...
%     '/data/',bedpostx_path,'/nodif_brain.nii.gz -ref /data/DCP_DTI_DATA/seed_file/T1_brain.nii.gz -omat /data/DCP_DTI_DATA/seed_file/dti_to_t1.mat',...
%     '&&convert_xfm -omat /data/DCP_DTI_DATA/seed_file/t1_to_dti.mat -inverse /data/DCP_DTI_DATA/seed_file/dti_to_t1.mat',...
%     '&&flirt -in /data/DCP_DTI_DATA/seed_file/T1_brain_pve_2.nii.gz -ref',32,'/data/',bedpostx_path,'/nodif_brain.nii.gz',...
%     32,'-applyxfm -init /data/DCP_DTI_DATA/seed_file/t1_to_dti.mat -out /data/DCP_DTI_DATA/seed_file/wm_mask_dti.nii.gz"');
% [status,cmdout] = system(command_get_mat);

hd=spm_vol([subFile 'DCP_PARCELLATION' filesep 'c2rbet_T1.nii']);
data=spm_read_vols(hd);
for i=1:size(data,1)
    for j=1:size(data,2)
        for k=1:size(data,3)
            if(data(i,j,k)<0.2)
                data(i,j,k)=0;
            else
                data(i,j,k)=1;
            end
        end
    end
end
hd.fname=[subFile 'DCP_DTI_DATA' filesep 'wm_mask_dti.nii'];
spm_write_vol(hd,data);
% command_track=strcat('docker run --rm -v',32,subFile,...
%     ':/data fsl_camino bash -c "source /etc/profile&&cd data&&track -inputmodel bedpostx_dyad',...
%     32,'-curvethresh',32,curvethresh,32,'-curveinterval',32,curveinterval,32,'-bedpostxminf',32,bedpostxminf,...
%     32,' -header',32,'/data/',bedpostx_path,'/nodif_brain.nii.gz -seedfile /data/DCP_DTI_DATA/seed_file/',...
%     'wm_mask_dti.nii.gz -bedpostxdir /data/',bedpostx_path,32,'-tracker',32,tracker,32,'-interpolator',...
%     32,interpolator,32,'-stepsize',32,stepsize,32,'-outputfile /data/DCP_DTI_DATA/camino_bedpost_track"');
command_track=strcat('docker run --rm -v',32,subFile,...
    ':/data docker_camino bash -c "source /etc/profile&&cd data&&track -inputmodel bedpostx_dyad',...
    32,'-curvethresh',32,curvethresh,32,'-curveinterval',32,curveinterval,32,'-bedpostxminf',32,bedpostxminf,...
    32,' -header',32,'/data/',bedpostx_path,'/nodif_brain.nii.gz -seedfile /data/DCP_DTI_DATA/',...
    'wm_mask_dti.nii -bedpostxdir /data/',bedpostx_path,32,'-tracker',32,tracker,32,'-interpolator',...
    32,interpolator,32,'-stepsize',32,stepsize,32,'-outputfile /data/DCP_DTI_DATA/camino_bedpost_track"');
[status,cmdout] = system(command_track);
command_procstreamlines=strcat('docker run --rm -v',32,subFile,...
    ':/data docker_camino bash -c "source /etc/profile&&cd data',...
    '&&procstreamlines -inputfile /data/DCP_DTI_DATA/camino_bedpost_track',...
    32,'-mintractlength',32,mintractlength,32,'-maxtractlength',...
    32,maxtractlength,32,'-header /data/',bedpostx_path,...
    '/nodif_brain.nii.gz > /data/DCP_DTI_DATA/camino_bedpost_track_post"');
[status,cmdout] = system(command_procstreamlines);
