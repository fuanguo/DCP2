function DCP_merge_matrix_prob(opt)
path=opt.inputFile;
save_path=opt.merge.outputFile;
sub=dir(path);
atlas_prob=opt.matrix.atlas_prob;
if opt.matrix.fn==1
    for i=1:length(atlas_prob)
        atlas=cell2mat(atlas_prob(i));
        [~,atlasName,~]=fileparts(atlas);
        %mkdir([save_path filesep atlasName]);
        file_name=strcat('p',atlasName,'_dti_',opt.matrix.curvethresh,'_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,'_fn.mat');
        for j=3:length(sub)
            mat=importdata([path filesep sub(j).name filesep 'DCP_MATRIX' filesep file_name]);
            struct=strcat('FNum.',sub(j).name,'=mat;');
            eval(struct);
        end
        struct=strcat('save',32,'''',save_path,'\',atlasName,'_dti_',opt.matrix.curvethresh,...
            '_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,...
        '_FNum.mat''',32,'FNum');
        eval(struct);
    end
end

if opt.matrix.fa==1
    for i=1:length(atlas_prob)
        atlas=cell2mat(atlas_prob(i));
        [~,atlasName,~]=fileparts(atlas);
        %mkdir([save_path filesep atlasName]);
        file_name=strcat('p',atlasName,'_dti_',opt.matrix.curvethresh,'_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,'_fa.mat');
        for j=3:length(sub)
            mat=importdata([path filesep sub(j).name filesep 'DCP_MATRIX' filesep file_name]);
            struct=strcat('FA.',sub(j).name,'=mat;');
            eval(struct);
        end
        struct=strcat('save',32,'''',save_path,'\',atlasName,'_dti_',opt.matrix.curvethresh,...
            '_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,...
        '_FA.mat''',32,'FA');
        eval(struct);
    end
end

if opt.matrix.md==1
    for i=1:length(atlas_prob)
        atlas=cell2mat(atlas_prob(i));
        [~,atlasName,~]=fileparts(atlas);
        %mkdir([save_path filesep atlasName]);
        file_name=strcat('p',atlasName,'_dti_',opt.matrix.curvethresh,'_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,'_md.mat');
        for j=3:length(sub)
            mat=importdata([path filesep sub(j).name filesep 'DCP_MATRIX' filesep file_name]);
            struct=strcat('MD.',sub(j).name,'=mat;');
            eval(struct);
        end
        struct=strcat('save',32,'''',save_path,'\',atlasName,'_dti_',opt.matrix.curvethresh,...
            '_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,...
        '_MD.mat''',32,'MD');
        eval(struct);
    end
end

if opt.matrix.length==1
    for i=1:length(atlas_prob)
        atlas=cell2mat(atlas_prob(i));
        [~,atlasName,~]=fileparts(atlas);
        %mkdir([save_path filesep atlasName]);
        file_name=strcat('p',atlasName,'_dti_',opt.matrix.curvethresh,'_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,'_length.mat');
        for j=3:length(sub)
            mat=importdata([path filesep sub(j).name filesep 'DCP_MATRIX' filesep file_name]);
            struct=strcat('FL.',sub(j).name,'=mat;');
            eval(struct);
        end
        struct=strcat('save',32,'''',save_path,'\',atlasName,'_dti_',opt.matrix.curvethresh,...
            '_',opt.matrix.curveinterval,'_',...
            opt.matrix.bedpostxminf,'_',opt.matrix.tracker,'_',opt.matrix.interpolator,...
        '_',opt.matrix.stepsize,'_',opt.matrix.mintractlength,'_',opt.matrix.maxtractlength,...
        '_FL.mat''',32,'FL');
        eval(struct);
    end
end