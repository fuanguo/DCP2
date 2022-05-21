function varargout = DCP_NetworkAnalysis(varargin)
% DCP_NETWORKANALYSIS MATLAB code for DCP_NetworkAnalysis.fig
%      DCP_NETWORKANALYSIS, by itself, creates a new DCP_NETWORKANALYSIS or raises the existing
%      singleton*.
%
%      H = DCP_NETWORKANALYSIS returns the handle to a new DCP_NETWORKANALYSIS or the handle to
%      the existing singleton*.
%
%      DCP_NETWORKANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCP_NETWORKANALYSIS.M with the given input arguments.
%
%      DCP_NETWORKANALYSIS('Property','Value',...) creates a new DCP_NETWORKANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCP_NetworkAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCP_NetworkAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DCP_NetworkAnalysis

% Last Modified by GUIDE v2.5 10-Jun-2021 21:13:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DCP_NetworkAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @DCP_NetworkAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DCP_NetworkAnalysis is made visible.
function DCP_NetworkAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCP_NetworkAnalysis (see VARARGIN)

% Choose default command line output for DCP_NetworkAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DCP_NetworkAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DCP_NetworkAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_matrix_path_Callback(hObject, eventdata, handles)
% hObject    handle to input_matrix_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_matrix_path as text
%        str2double(get(hObject,'String')) returns contents of input_matrix_path as a double


% --- Executes during object creation, after setting all properties.
function input_matrix_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_matrix_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_matrix.
function input_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to input_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,~]=uigetfile(path,'请选择文件');
input_matrix=strcat(PathName,FileName);
set(handles.input_matrix_path,'string',input_matrix);
guidata(hObject,handles);


function output_path_Callback(hObject, eventdata, handles)
% hObject    handle to output_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_path as text
%        str2double(get(hObject,'String')) returns contents of output_path as a double


% --- Executes during object creation, after setting all properties.
function output_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ouput.
function ouput_Callback(hObject, eventdata, handles)
% hObject    handle to ouput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outpath=uigetdir(path,'请选择文件');
set(handles.output_path,'string',outpath);
guidata(hObject,handles);

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%guidata(hObject, handles);
[global_mode,nodal_mode]=getmode(handles);
input_path=get(handles.input_matrix_path,'string');
output_path=get(handles.output_path,'string');
InputS=get_inputS(input_path);
AList=cellfun(@(S) S.Alias, InputS, 'UniformOutput', false);
%output_path='D:\software\MIAP1_1\MIAP1_1\NeworkAnalysis\test';
OutputMatList=cellfun(@(a) fullfile(output_path, a, 'RealNet.mat'),...
    AList, 'UniformOutput', false);
%OutputFile='H:\miap\function_test\result\re.mat';
Mat=cellfun(@(S) S.Mat, InputS, 'UniformOutput', false);
%AList=cellfun(@(S) S.Alias, InputS, 'UniformOutput', false);
%mat=cell2mat(mat(1));
SType=1;
TType=get(handles.threshold_method,'value');
%Thres=str2double(get(handles.threshold,'string'));
Thres=get(handles.threshold,'string');
Thres=s2d(Thres);
NType=2-get(handles.type_binary,'value');
RandNum=str2double(get(handles.random_network_number,'string'));
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




% --- Executes on button press in Nodal_ClustCoeff.
function Nodal_ClustCoeff_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_ClustCoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_ClustCoeff


% --- Executes on button press in Nodal_ShortestPath.
function Nodal_ShortestPath_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_ShortestPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_ShortestPath


% --- Executes on button press in Nodal_Efficiency.
function Nodal_Efficiency_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_Efficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_Efficiency


% --- Executes on button press in Nodal_BetweennessCentrality.
function Nodal_BetweennessCentrality_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_BetweennessCentrality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_BetweennessCentrality


% --- Executes on button press in Nodal_DegreeCentrality.
function Nodal_DegreeCentrality_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_DegreeCentrality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_DegreeCentrality


% --- Executes on button press in Nodal_LocalEfficiency.
function Nodal_LocalEfficiency_Callback(hObject, eventdata, handles)
% hObject    handle to Nodal_LocalEfficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Nodal_LocalEfficiency


% --- Executes on button press in Global_SmallWorld.
function Global_SmallWorld_Callback(hObject, eventdata, handles)
% hObject    handle to Global_SmallWorld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Global_SmallWorld


% --- Executes on button press in Global_Efficiency.
function Global_Efficiency_Callback(hObject, eventdata, handles)
% hObject    handle to Global_Efficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Global_Efficiency


% --- Executes on button press in Global_Assortativity.
function Global_Assortativity_Callback(hObject, eventdata, handles)
% hObject    handle to Global_Assortativity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Global_Assortativity


% --- Executes on button press in Global_RichClub.
function Global_RichClub_Callback(hObject, eventdata, handles)
% hObject    handle to Global_RichClub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Global_RichClub



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in type_binary.
function type_binary_Callback(hObject, eventdata, handles)
binaryValue=get(handles.type_binary,'value');
if binaryValue==0
    set(handles.type_weighted,'value',1);
    set(handles.type_binary,'value',0);
else
    set(handles.type_binary,'value',1);
    set(handles.type_weighted,'value',0);
end
% hObject    handle to type_binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_binary


% --- Executes on button press in type_weighted.
function type_weighted_Callback(hObject, eventdata, handles)
weightedValue=get(handles.type_binary,'value');
if weightedValue==0
    set(handles.type_weighted,'value',0);
    set(handles.type_binary,'value',1);
else
    set(handles.type_binary,'value',0);
    set(handles.type_weighted,'value',1);
end
% hObject    handle to type_weighted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_weighted
function [global_mode,nodal_mode]=getmode(handles)
global_mode=strings(0,0);
nodal_mode=strings(0,0);
%handles = guihandles(object_handle);
global_list=["Global_SmallWorld";"Global_Efficiency";"Global_Assortativity";"Global_RichClub"];
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



function random_network_number_Callback(hObject, eventdata, handles)
% hObject    handle to random_network_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of random_network_number as text
%        str2double(get(hObject,'String')) returns contents of random_network_number as a double


% --- Executes during object creation, after setting all properties.
function random_network_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to random_network_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in threshold_method.
function threshold_method_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns threshold_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from threshold_method


% --- Executes during object creation, after setting all properties.
function threshold_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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
