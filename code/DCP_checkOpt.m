function [flag, errorMsg]=DCP_checkOpt(opt)
    subject=dir(opt.inputFile);
    if length(subject)>2
        [flag,sub]=DCP_checkInput(opt.inputFile,opt.sub);
    else
        flag=1;
    end
    if flag
        [flag, errorMsg]=DCP_checkPara(opt);
    else
        errorMsg=[sub.name '''s data missing'];
    end
end
function [flag,mSub]=DCP_checkInput(inputFile,subIndex)
    sub=dir(inputFile);
    
        if strcmp(sub(3).name, '.DS_Store')
            sub(3)=[];
        end
        if strcmp(subIndex,'All subjects')
            index=3:length(sub);
        else
            index=eval([subIndex ';'])+2;
        end
        numsub=zeros(1,length(index));
        for i=1:length(index)

            allFiles=dir([inputFile filesep sub(index(i)).name]);
            if strcmp(allFiles(3).name,'.DS_Store')
                allFiles(3)=[];
            end
            numsub(i)=length(allFiles)-2;
        end
        missingSub=find(numsub<max(numsub));
        if isempty(missingSub)
            flag=true;
            mSub=[];
        else
            flag=true;
        mSub=[];
            %flag=false;
            %mSub=sub(index(missingSub(1)));
        end
    
end
function [flag, errorMsg]=DCP_checkPara(opt)
    flag=true; errorMsg=[];
    if opt.tracktography.lowFA>=1 || opt.tracktography.lowFA<0
        flag=false;
        errorMsg='Lower FA musb be in [0,1)';
    end
    if opt.tracktography.highFA>1 || opt.tracktography.highFA<0 ...
            || opt.tracktography.highFA<opt.tracktography.lowFA
        flag=false;
        errorMsg='higher FA musb be in [0,1] and less than lower FA';
    end
    if opt.parcellation.T1>1 || opt.parcellation.T1<0 || opt.parcellation.B0>1 || opt.parcellation.B0<0
        flag=false;
        errorMsg='The parameter of bet must be in [0,1]';
    end
end