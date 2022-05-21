function DCP_Network_Analysis(opt)
[global_mode,nodal_mode]=getmode(opt);
input_path=get(opt.input_matrix_path,'string');
net_file=dir(input_path);
for k=3:length(net_file)
    [~,fileName,~]=fileparts(net_file(k).name);
    output_path=get(opt.output_path,'string');
    output_path=strcat(output_path,'\',fileName);
    mkdir(output_path);
    input_file_path=[input_path filesep net_file(k).name];
    InputS=get_inputS(input_file_path);
    AList=cellfun(@(S) S.Alias, InputS, 'UniformOutput', false);
    %output_path='D:\software\MIAP1_1\MIAP1_1\NeworkAnalysis\test';
    OutputMatList=cellfun(@(a) fullfile(output_path, a, 'RealNet.mat'),...
        AList, 'UniformOutput', false);
    %OutputFile='H:\miap\function_test\result\re.mat';
    Mat=cellfun(@(S) S.Mat, InputS, 'UniformOutput', false);
    %AList=cellfun(@(S) S.Alias, InputS, 'UniformOutput', false);
    %mat=cell2mat(mat(1));
    SType=1;
    %TType=get(opt.threshold_method,'value');
    TType=2;
    %Thres=get(opt.threshold,'string');
    %Thres=s2d(Thres);
    Thres=2;
    %NType=2-get(opt.type_binary,'value');
    NType=2;
    %RandNum=str2double(get(opt.random_network_number,'string'));
    RandNum=100;
    AUCInterval=0;
    if numel(Thres)>1
        AUCInterval=Thres(2)-Thres(1);
    end
    cellfun(@(mat, out)...
        DCP_getThresMat(mat, out, SType, TType, Thres, NType),...
        Mat, OutputMatList,...
        'UniformOutput', false);
    RandNetList=cellfun(@(S) '', OutputMatList, 'UniformOutput', false);
    if ~isempty(global_mode)
        RandNetList=cellfun(@(a) fullfile(output_path, a, 'RandNet.mat'),...
            AList, 'UniformOutput', false);
        cellfun(@(in, out)...
            DCP_RUN_GenRandNet(in, out, NType, RandNum),...
            OutputMatList, RandNetList,...
            'UniformOutput', false);
    end
    %Mode=["Nodal_ClustCoeff";"Nodal_ShortestPath";"Nodal_Efficiency";...
            %"Nodal_BetweennessCentrality";"Nodal_DegreeCentrality";"Nodal_LocalEfficiency"];
    for i=1:length(global_mode)
        modename=global_mode{i};
        OutputList=cellfun(@(a) fullfile(output_path, a, strcat(modename,'.mat')),...
                        AList, 'UniformOutput', false);
        struct=strcat('cellfun(@(in, rnd, out) ',modename,'(in, rnd, out, NType, AUCInterval),OutputMatList, RandNetList, OutputList,''UniformOutput'', false);');
        eval(struct);
        filepath=[output_path filesep modename];
        mkdir(filepath);
        Metrics_Merge(OutputList, filepath);
    end
    for i=1:length(nodal_mode)
        modename=nodal_mode{i};
        OutputList=cellfun(@(a) fullfile(output_path, a, strcat(modename,'.mat')),...
                        AList, 'UniformOutput', false);
        struct=strcat('cellfun(@(in, out) ',modename,'(in, out, NType, AUCInterval),OutputMatList, OutputList,''UniformOutput'', false);');
        eval(struct);
        filepath=[output_path filesep modename];
        mkdir(filepath);
        Metrics_Merge(OutputList, filepath);
    end
    rm_path=cellfun(@(a) fullfile(output_path, a),...
        AList, 'UniformOutput', false);
    %cellfun(@(path) file_rm(path),rm_path,'UniformOutput', false);
end

function [global_mode,nodal_mode]=getmode(handles)
global_mode=strings(0,0);
nodal_mode=strings(0,0);
%handles = guihandles(object_handle);
global_list=["Global_SmallWorld";"Global_Efficiency";"Global_RichClub"];
nodal_list=["Nodal_ClustCoeff";"Nodal_ShortestPath";"Nodal_Efficiency";...
    "Nodal_BetweennessCentrality";"Nodal_DegreeCentrality";"Nodal_LocalEfficiency"];
g_count=0;
n_count=0;
for i=1:length(global_list)
    %get(handles.type_binary,'value');
    flag=0;
    instruct=strcat('flag=get(handles.',global_list{i},',''value'');');
    eval(instruct);
    if flag==1
        g_count=g_count+1;
        global_mode(g_count,1)=strcat('DCP_',global_list(i));
    end
end
for i=1:length(nodal_list)
    %get(handles.type_binary,'value');
    flag=0;
    instruct=strcat('flag=get(handles.',nodal_list{i},',''value'');');
    eval(instruct);
    if flag==1
        n_count=n_count+1;
        nodal_mode(n_count,1)=strcat('DCP_',nodal_list(i));
    end
end

function file_rm(path)
rmdir(path,'s');

function s=s2d(str)
index=find(str==',');
pre=1;
for i=1:length(index)
    s(i)=str2double(str(pre:(index(i)-1)));
    pre=index(i)+1;
end
s(i+1)=str2double(str(pre:end));
if isempty(index)
    s=str2double(str);
end
function [InputS]=get_inputS(input_path)
mat=load(input_path);
input_mat_name=char(fieldnames(mat));
mat=mat.(char(fieldnames(mat)));
fieds=fieldnames(mat);
for i=1:length(fieds)
    sub.File=input_path;
    sub.Type='S';
    sub.Size=size(mat.(char(fieds(i))));
    sub.Lab=strcat(input_mat_name,char(fieds(i)));
    sub.Alias=strcat(input_mat_name,char(fieds(i)));
    sub.GrpID=1;
    sub.Mat=mat.(char(fieds(i)));
    InputS(i,1)={sub};
    clear sub;
end