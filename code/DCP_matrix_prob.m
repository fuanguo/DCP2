function DCP_matrix_prob(subFile,opt)
for k=1:length(opt.atlas_prob)
    atlas=cell2mat(opt.atlas_prob(k));
    [~,atlasName,~]=fileparts(atlas);
    if exist(strcat(subFile,'DCP_MATRIX'))==0
        mkdir(strcat(subFile,'DCP_MATRIX'));
    end
    file_name=strcat('p',atlasName,'_dti_',opt.curvethresh,'_',opt.curveinterval,'_',...
            opt.bedpostxminf,'_',opt.tracker,'_',opt.interpolator,...
        '_',opt.stepsize,'_',opt.mintractlength,'_',opt.maxtractlength);
    if opt.fn==1
        command_fn=strcat('docker run --rm -v',32,subFile,...
        ':/data docker_camino bash -c "source /etc/profile&&cd data&&conmat -inputfile DCP_DTI_DATA/camino_bedpost_track_post',...
        32,'-targetfile DCP_PARCELLATION/w',atlasName,'.nii -outputroot DCP_MATRIX/',file_name,'_fn"');
        [status,cmdout] = system(command_fn);
        fn=importdata(strcat(subFile,'DCP_MATRIX\',file_name,'_fnsc.csv'));
        fn_data=fn.data;
        if(size(fn_data,1))==116
            fn_data=fn_data(1:90,1:90);
        end
        eval(strcat('save',32,subFile,'DCP_MATRIX\',file_name,'_fn.mat',32,'fn_data'));
        fp=fopen(strcat(subFile,'DCP_MATRIX\',file_name,'_fn.txt'),'w');
        for i=1:length(fn_data)
            fprintf(fp,'%f ',fn_data(i,:));
            fprintf(fp,'\r\n');
        end
        fclose(fp);
    end
    if opt.fa==1
        command_fa=strcat('docker run --rm -v',32,subFile,...
        ':/data docker_camino bash -c "source /etc/profile&&cd data&&conmat -inputfile DCP_DTI_DATA/camino_bedpost_track_post',...
        32,'-targetfile DCP_PARCELLATION/w',atlasName,'.nii -scalarfile',32,'DCP_DTI_DATA/dti_fa.nii',...
        32,'-outputroot DCP_MATRIX/',file_name,'_fa"');
        [status,cmdout] = system(command_fa);
        fa=importdata(strcat(subFile,'DCP_MATRIX\',file_name,'_fats.csv'));
        fa_data=fa.data;
        if(size(fa_data,1))==116
            fa_data=fa_data(1:90,1:90);
        end
        eval(strcat('save',32,subFile,'DCP_MATRIX\',file_name,'_fa.mat',32,'fa_data'));
        fp=fopen(strcat(subFile,'DCP_MATRIX\',file_name,'_fa.txt'),'w');
        for i=1:length(fa_data)
            fprintf(fp,'%f ',fa_data(i,:));
            fprintf(fp,'\r\n');
        end
        fclose(fp);
    end
    if opt.md==1
        command_md=strcat('docker run --rm -v',32,subFile,...
        ':/data docker_camino bash -c "source /etc/profile&&cd data&&conmat -inputfile DCP_DTI_DATA/camino_bedpost_track_post',...
        32,'-targetfile DCP_PARCELLATION/w',atlasName,'.nii -scalarfile',32,'DCP_DTI_DATA/dti_adc.nii',...
        32,'-outputroot DCP_MATRIX/',file_name,'_md"');
        [status,cmdout] = system(command_md);
        md=importdata(strcat(subFile,'DCP_MATRIX\',file_name,'_mdts.csv'));
        md_data=md.data;
        if(size(md_data,1))==116
            md_data=md_data(1:90,1:90);
        end
        eval(strcat('save',32,subFile,'DCP_MATRIX\',file_name,'_md.mat',32,'md_data'));
        fp=fopen(strcat(subFile,'DCP_MATRIX\',file_name,'_md.txt'),'w');
        for i=1:length(md_data)
            fprintf(fp,'%f ',md_data(i,:));
            fprintf(fp,'\r\n');
        end
        fclose(fp);
    end
    if opt.length==1
        command_fl=strcat('docker run --rm -v',32,subFile,...
        ':/data docker_camino bash -c "source /etc/profile&&cd data&&conmat -inputfile DCP_DTI_DATA/camino_bedpost_track_post',...
        32,'-targetfile DCP_PARCELLATION/w',atlasName,'.nii -tractstat length -outputroot DCP_MATRIX/',file_name,'_length"');
        [status,cmdout] = system(command_fl);
        fl=importdata(strcat(subFile,'DCP_MATRIX\',file_name,'_lengthts.csv'));
        fl_data=fl.data;
        if(size(fl_data,1))==116
            fl_data=fl_data(1:90,1:90);
        end
        eval(strcat('save',32,subFile,'DCP_MATRIX\',file_name,'_length.mat',32,'fl_data'));
        fp=fopen(strcat(subFile,'DCP_MATRIX\',file_name,'_length.txt'),'w');
        for i=1:length(fl_data)
            fprintf(fp,'%f ',fl_data(i,:));
            fprintf(fp,'\r\n');
        end
        fclose(fp);
    end
end