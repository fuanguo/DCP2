function DCP_run(opt,monitor)
mfilePath=mfilename('fullpath');
filesepIndex=regexp(mfilePath,filesep);
DCPPath=mfilePath(1:filesepIndex(length(filesepIndex)-1));
filesepIndex=regexp(opt.inputFile,filesep);
logPath=opt.inputFile(1:filesepIndex(length(filesepIndex)));
timevec=datevec(datestr(now));
year=num2str(timevec(1));
year=year(3:end);
fid=fopen([logPath filesep 'logs' year '_' num2str(timevec(2)) '_' num2str(timevec(3)) '_'...
    num2str(timevec(4)) '_' num2str(timevec(5)) '.txt'],'w');
subFile=dir(opt.inputFile);
if strcmp(subFile(3).name,'.DS_Store')
    subFile(3)=[];
end
if strcmp(opt.sub,'All subjects')
    subIndex=3:length(subFile);
else
    subIndex=eval([opt.sub ';'])+2;
end
for i=subIndex
    if opt.preprocessing.convert==1
        set(monitor,'String',[subFile(i).name ' convertion']);
        %             jobnameDcm=['dcm2nii_' subFile(i).name];
        %             pipeline.(jobnameDcm).command='DCP_dcm2nii(files_in);';
        %             pipeline.(jobnameDcm).files_in=[opt.inputFile filesep subFile(i).name filesep];
        %             pipeline.(jobnameDcm).files_out=[opt.inputFile filesep subFile(i).name filesep];
        %             jobnameMove=['movefile_' subFile(i).name];
        %             pipeline.(jobnameMove).command='DCP_move_file(file_in)';
        %             pipeline.(jobnameMove).files_in=pipeline.(jobnameDcm).files_out;
        %             pipeline.(jobnameMove).files_out=[opt.inputFile filesep subFile(i).name filesep];
        try
            DCP_dcm2nii([opt.inputFile filesep subFile(i).name filesep]);
        catch ErrorInfo
            message=ErrorInfo.message;
            message=strrep(message,'\','\\');
            fprintf(fid,[message '\n']);
            fprintf(fid,[subFile(i).name '''s convertion is failed\n']);
        end
    end
    if opt.preprocessing.eddy==1
        try
            DCP_move_file([opt.inputFile filesep subFile(i).name filesep]);
            dti_file=dir([opt.inputFile filesep subFile(i).name filesep 'DCP_DTI_DATA' filesep '*.nii']);
            t1_file=dir([opt.inputFile filesep subFile(i).name filesep 'DCP_PARCELLATION' filesep '*.nii']);
            if isempty(dti_file) || isempty(t1_file)
                fprintf(fid,[subFile(i).name 'does not have some files.\n']);
            end
        catch ErrorInfo
            message=ErrorInfo.message;
            message=strrep(message,'\','\\');
            fprintf(fid,[message '\n']);
            fprintf(fid,[subFile(i).name '''s convertion is failed\n']);
        end
        set(monitor,'String',[subFile(i).name ' eddycurrent correction']);
        %             jobnameEddy=['eddyCurrent_' subFile(i).name];
        %             pipeline.(jobnameEddy).command='DCP_eddycurrent(files_in);';
        %             if opt.preprocessing.convert==1
        %                 pipeline.(jobnameEddy).files_in=pipeline.(jobnameMove).files_out;
        %             else
        %                 pipeline.(jobnameEddy).files_in=[inputFile filesep subFile(i).name filesep];
        %             end
        %             pipeline.(jobnameEddy).files_out=[opt.inputFile filesep subFile(i).name filesep];
        try
            DCP_eddycurrent([opt.inputFile filesep subFile(i).name filesep]);
            fprintf(fid,[subFile(i).name '''s eddy current correction is done\n']);
        catch ErrorInfo
            message=ErrorInfo.message;
            message=strrep(message,'\','\\');
            fprintf(fid,[message '\n']);
            fprintf(fid,[subFile(i).name '''s eddy current correction is failed\n']);
        end
    end
    if opt.preprocessing.tensorCal==1
        set(monitor,'String',[subFile(i).name ' tensor calculation']);
        %             jobnameTensor=['tensor_' subFile(i).name];
        %             pipeline.(jobnameTensor).command='DCP_calctensor(files_in)';
        %             if opt.preprocessing.eddy==1
        %                 pipeline.(jobnameTensor).files_in=pipeline.(jobnameEddy).files_out;
        %             else
        %                 pipeline.(jobnameTensor).files_in=[inputFile filesep subFile(i).name filesep];
        %             end
        %             pipeline.(jobnameTensor).files_out=[opt.inputFile filesep subFile(i).name filesep];
        try
            DCP_calctensor([opt.inputFile filesep subFile(i).name filesep]);
            fprintf(fid,[subFile(i).name '''s tensor calculation is done\n']);
        catch ErrorInfo
            message=ErrorInfo.message;
            message=strrep(message,'\','\\');
            fprintf(fid,[message '\n']);
            fprintf(fid,[subFile(i).name '''s tensor calculation is failed\n']);
        end
    end
    if opt.tracktography.flag==1
        set(monitor,'String',[subFile(i).name ' tracktography']);
        %             jobnameTrack=['track_' subFile(i).name];
        %             pipeline.(jobnameTrack).command='DCP_tracker(files_in,opt.tracktography)';
        %             pipeline.(jobnameTrack).opt=opt.tracktography;
        %             if opt.preprocessing.tensorCal==1
        %                 pipeline.(jobnameTrack).files_in=pipeline.(jobnameTensor).files_out;
        %             else
        %                 pipeline.(jobnameTrack).filese_in=[inputFile filesep subFile(i).name filesep];
        %             end
        %             pipeline.(jobnameTrack).files_out=[opt.inputFile filesep subFile(i).name filesep];
        try
            DCP_tracker([opt.inputFile filesep subFile(i).name filesep],opt.tracktography);
            track_file=dir([opt.inputFile filesep subFile(i).name filesep 'DCP_DTI_DATA' filesep '*.trk']);
            if isempty(track_file)
                fprintf(fid,[subFile(i).name '''s tracktography is failed\n']);
            else
                fprintf(fid,[subFile(i).name '''s trakctography is done\n']);
            end
        catch ErrorInfo
            message=ErrorInfo.message;
            message=strrep(message,'\','\\');
            fprintf(fid,[message '\n']);
            fprintf(fid,[subFile(i).name '''s tracktography is failed\n']);
        end
    end
    if opt.parcellation.flag==1
        set(monitor,'String',[subFile(i).name ' parcellation']);
        if opt.parcellation.aal==1
            opt.parcellation.atlas=[DCPPath filesep 'templates' filesep 'aal90.nii'];
            %                 jobnameParAAL=['parcellationAAL_' subFile(i).name];
            %                 pipeline.(jobnameParAAL).command='DCP_parcellation(files_in,opt);';
            %                 pipeline.(jobnameParAAL).files_in=pipeline.(jobnameTensor).files_out;
            %                 pipeline.(jobnameParAAL).opt=opt.parcellation;
            %                 pipeline.(jobnameParAAL).files_out=[opt.inputFile filesep subFile(i).name filesep];
            try
                DCP_parcellation([opt.inputFile filesep subFile(i).name filesep],opt.parcellation);
                fprintf(fid,[subFile(i).name '''s parcellation(aal) is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s parcellation(aal) is failed\n']);
            end
        end
        if opt.parcellation.random==1
            opt.parcellation.atlas=[DCPPath filesep 'templates' filesep 'aal1024.nii'];
            %                 jobnameParRandom=['parcellationRandom_' subFile(i).name];
            %                 pipeline.(jobnameParRandom).command='DCP_parcellation(files_in,opt);';
            %                 pipeline.(jobnameParRandom).files_in=pipeline.(jobnameTensor).files_out;
            %                 pipeline.(jobnameParRandom).opt=opt.parcellation;
            %                 pipeline.(jobnameParRandom).files_out=[opt.inputFile filesep subFile(i).name filesep];
            try
                DCP_parcellation([opt.inputFile filesep subFile(i).name filesep],opt.parcellation);
                fprintf(fid,[subFile(i).name '''s parcellation(random1024) is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s parcellation(random1024) is failed\n']);
            end
        end
        if ~isempty(opt.parcellation.otherAtlas)
            opt.parcellation.atlas=opt.parcellation.otherAtlas;
            %                 jobnameParOther=['parcellationOther_' subFile(i).name];
            %                 pipeline.(jobnameParOther).command='DCP_parcellation(files_in,opt);';
            %                 pipeline.(jobnameParOther).files_in=pipeline.(jobnameTensor).files_out;
            %                 pipeline.(jobnameParOther).opt=opt.parcellation;
            %                 pipeline.(jobnameParOther).files_out=[opt.inputFile filesep subFile(i).name filesep];
            try
                DCP_parcellation([opt.inputFile filesep subFile(i).name filesep],opt.parcellation);
                fprintf(fid,[subFile(i).name '''s parcellation(other) is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s parcellation(other) is failed\n']);
            end
        end
    end
    if opt.matrix.flag==1
        set(monitor,'String',[subFile(i).name ' matrix construction']);
        opt.matrix.angle=opt.tracktography.angle;
        opt.matrix.lowFA=opt.tracktography.lowFA;
        opt.matrix.seed=opt.tracktography.seed;
        opt.matrix.nativeCheck=opt.parcellation.nativeCheck;
        if opt.parcellation.aal==1
            opt.matrix.atlas=[DCPPath filesep 'templates' filesep 'aal90.nii'];
            %                 jobnameMatrixAAL=['matrixAAL_' subFile(i).name];
            %                 pipeline.(jobnameMatrixAAL).command='DCP_matrix(files_in1,files_in2,opt);';
            %                 pipeline.(jobnameMatrixAAL).files_in.files{1}=pipeline.(jobnameTrack).files_out;
            %                 pipeline.(jobnameMatrixAAL).files_in.files{2}=pipeline.(jobnameParAAL).files_out;
            %                 pipeline.(jobnameMatrixAAL).opt=opt.matrix;
            try
                DCP_matrix([opt.inputFile filesep subFile(i).name filesep],opt.matrix);
                fprintf(fid,[subFile(i).name '''s matrix construction is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s matrix construction is failed\n']);
            end
        end
        if opt.parcellation.random==1
            opt.matrix.atlas=[DCPPath filesep 'templates' filesep 'aal1024.nii'];
            %                 jobnameMatrixRan=['matrixRan_' subFile(i).name];
            %                 pipeline.(jobnameMatrixRan).command='DCP_matrix(files_in1,files_in2,opt);';
            %                 pipeline.(jobnameMatrixRan).files_in.files{1}=pipeline.(jobnameTrack).files_out;
            %                 pipeline.(jobnameMatrixRan).files_in.files{2}=pipeline.(jobnameParRandom).files_out;
            %                 pipeline.(jobnameMatrixRan).opt=opt.matrix;
            try
                DCP_matrix([opt.inputFile filesep subFile(i).name filesep],opt.matrix);
                fprintf(fid,[subFile(i).name '''s matrix construction is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s matrix construction is failed\n']);
            end
        end
        if ~isempty(opt.parcellation.otherAtlas)
            opt.matrix.atlas=opt.parcellation.otherAtlas;
            %                 jobnameMatrixOther=['matrixOther_' subFile(i).name];
            %                 pipeline.(jobnameMatrixOther).command='DCP_matrix(files_in1,files_in2,opt);';
            %                 pipeline.(jobnameMatrixOther).files_in.files{1}=pipeline.(jobnameTrack).files_out;
            %                 pipeline.(jobnameMatrixOther).files_in.files{2}=pipeline.(jobnameParOther).files_out;
            %                 pipeline.(jobnameMatrixOther).opt=opt.matrix;
            try
                DCP_matrix([opt.inputFile filesep subFile(i).name filesep],opt.matrix);
                fprintf(fid,[subFile(i).name '''s matrix construction is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s matrix construction is failed\n']);
            end
        end
        if opt.parcellation.nativeCheck==1
            opt.matrix.nativeCheck=opt.parcellation.nativeCheck;
            opt.matrix.atlas=[opt.parcellation.nativeEdit filesep subFile(i).name '.nii'];
            %                 jobnameMatrixNative=['matrixNative_' subFile(i).name];
            %                 pipeline.(jobnameMatrixNative).command='DCP_matrix(files_in1,files_in2,opt);';
            %                 pipeline.(jobnameMatrixNative).files_in.files{1}=pipeline.(jobnameTrack).files_out;
            %                 pipeline.(jobnameMatrixNative).files_in.files{2}=[inputFile filesep subFile(i).name filesep];
            %                 pipeline.(jobnameMatrixNative).opt=opt.matrix;
            try
                DCP_matrix([opt.inputFile filesep subFile(i).name filesep],opt.matrix);
                fprintf(fid,[subFile(i).name '''s matrix construction is done\n']);
            catch ErrorInfo
                message=ErrorInfo.message;
                message=strrep(message,'\','\\');
                fprintf(fid,[message '\n']);
                fprintf(fid,[subFile(i).name '''s matrix construction is failed\n']);
            end
        end
    end
end
%     pipeopt.flag_verbose=0;
%     pipeopt.flag_pause=0;
%     pipeopt.path_logs=[logPath filesep 'DCPlogs'];
%     pipeopt.mode=opt.pipeline.type;
%     pipeopt.max_queued=opt.pipeline.maxQueue;
%     pipeopt.qsub_options=opt.pipeline.SGEoption;
%     if ~isempty(pipeline)
%         psom_run_pipeline(pipeline,pipeopt);
%         psom_pipeline_visu(pipeopt.path_logs,'monitor');
%     end
if opt.merge.flag==1
    set(monitor,'String','Results merging');
    %         DCP_merge_matrix(opt);
    try
        DCP_merge_matrix(opt);
        fprintf(fid,'Matrix merging is done\n');
    catch ErrorInfo
        message=ErrorInfo.message;
        message=strrep(message,'\','\\');
        fprintf(fid,[message '\n']);
        fprintf(fid,'Matrix merging is failed\n');
    end
end
fclose(fid);
set(monitor,'String','Finished');
fclose all;
end