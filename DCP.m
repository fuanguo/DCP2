function varargout = DCP(varargin)
% DCP MATLAB code for DCP.fig
%      DCP, by itself, creates a new DCP or raises the existing
%      singleton*.
%
%      H = DCP returns the handle to a new DCP or the handle to
%      the existing singleton*.
%
%      DCP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCP.M with the given input arguments.
%
%      DCP('Property','Value',...) creates a new DCP or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DCP

% Last Modified by GUIDE v2.5 27-May-2018 22:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DCP_OpeningFcn, ...
                   'gui_OutputFcn',  @DCP_OutputFcn, ...
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

% --- Executes just before DCP is made visible.
function DCP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCP (see VARARGIN)

% Choose default command line output for DCP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);
opt=DCP_defaultOpt();
DCP_load(handles, opt);

% UIWAIT makes DCP wait for user response (see UIRESUME)
% uiwait(handles.DCP);


% --- Outputs from this function are returned to the command line.
function varargout = DCP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.density = density;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new volume value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mass = handles.metricdata.density * handles.metricdata.volume;
set(handles.mass, 'String', mass);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% Update handles structure
guidata(handles.DCP, handles);


% --- Executes on button press in networkConstruction.
function networkConstruction_Callback(hObject, eventdata, handles)
% hObject    handle to networkConstruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in networkAnalysis.
function networkAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to networkAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function inputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to inputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputEdit as text
%        str2double(get(hObject,'String')) returns contents of inputEdit as a double


% --- Executes during object creation, after setting all properties.
function inputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputBtn.
function inputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to inputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputFile=uigetdir;
if (inputFile==0)
    set(handles.inputEdit,'String','Please select input file.');
else
    set(handles.inputEdit,'String',inputFile);
end




function queueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to queueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of queueEdit as text
%        str2double(get(hObject,'String')) returns contents of queueEdit as a double


% --- Executes during object creation, after setting all properties.
function queueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to queueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in preprocessBtn.
function preprocessBtn_Callback(hObject, eventdata, handles)
% hObject    handle to preprocessBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in trackBtn.
function trackBtn_Callback(hObject, eventdata, handles)
% hObject    handle to trackBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in parcelBtn.
function parcelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to parcelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in matrixBtn.
function matrixBtn_Callback(hObject, eventdata, handles)
% hObject    handle to matrixBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function outputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to outputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputEdit as text
%        str2double(get(hObject,'String')) returns contents of outputEdit as a double


% --- Executes during object creation, after setting all properties.
function outputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputBtn.
function outputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to outputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outputFile=uigetdir();
if (outputFile==0)
    set(handles.outputEdit,'String','Please select output file.');
else
    set(handles.outputEdit,'String',outputFile);
end


% --- Executes on selection change in subType.
function subType_Callback(hObject, eventdata, handles)
% hObject    handle to subType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subType
type=get(handles.subType, 'Value');
if type==3
    set(handles.SGEoption,'Visible','on');
else
    set(handles.SGEoption,'Visible','off');
end
% --- Executes during object creation, after setting all properties.
function subType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SGEoption_Callback(hObject, eventdata, handles)
% hObject    handle to SGEoption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SGEoption as text
%        str2double(get(hObject,'String')) returns contents of SGEoption as a double


% --- Executes during object creation, after setting all properties.
function SGEoption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SGEoption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function subEdit_Callback(hObject, eventdata, handles)
% hObject    handle to subEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subEdit as text
%        str2double(get(hObject,'String')) returns contents of subEdit as a double


% --- Executes during object creation, after setting all properties.
function subEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opt=DCP_defaultOpt();
DCP_load(handles, opt);


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opt=DCP_readOpt(handles);
[flag, errorMsg]=DCP_checkOpt(opt);
if flag
    DCP_run(opt);
else
    errordlg(errorMsg,'error');
end



% --- Executes on button press in TrackCheck.
function TrackCheck_Callback(hObject, eventdata, handles)
% hObject    handle to TrackCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TrackCheck


% --- Executes on button press in ParCheck.
function ParCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ParCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ParCheck


% --- Executes on button press in MatrixCheck.
function MatrixCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MatrixCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MatrixCheck


% --- Executes on button press in MergeCheck.
function MergeCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MergeCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MergeCheck


% --- Executes on button press in LenCheck.
function LenCheck_Callback(hObject, eventdata, handles)
% hObject    handle to LenCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LenCheck


% --- Executes on button press in MDCheck.
function MDCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MDCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MDCheck


% --- Executes on button press in FACheck.
function FACheck_Callback(hObject, eventdata, handles)
% hObject    handle to FACheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FACheck


% --- Executes on button press in FNCheck.
function FNCheck_Callback(hObject, eventdata, handles)
% hObject    handle to FNCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FNCheck



function Temedit_Callback(hObject, eventdata, handles)
% hObject    handle to Temedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Temedit as text
%        str2double(get(hObject,'String')) returns contents of Temedit as a double


% --- Executes during object creation, after setting all properties.
function Temedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TemBtn.
function TemBtn_Callback(hObject, eventdata, handles)
% hObject    handle to TemBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[template, path]=uigetfile('*.nii');
if (template)==0
    set(handles.Temedit,'String','Please select template');
else
    set(handles.Temedit,'String',[path template])
end



function bB0Edit_Callback(hObject, eventdata, handles)
% hObject    handle to bB0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bB0Edit as text
%        str2double(get(hObject,'String')) returns contents of bB0Edit as a double


% --- Executes during object creation, after setting all properties.
function bB0Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bB0Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bT1Edit_Callback(hObject, eventdata, handles)
% hObject    handle to bT1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bT1Edit as text
%        str2double(get(hObject,'String')) returns contents of bT1Edit as a double


% --- Executes during object creation, after setting all properties.
function bT1Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bT1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AALCheck.
function AALCheck_Callback(hObject, eventdata, handles)
% hObject    handle to AALCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AALCheck


% --- Executes on button press in RandomCheck.
function RandomCheck_Callback(hObject, eventdata, handles)
% hObject    handle to RandomCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomCheck



function Atlasedit_Callback(hObject, eventdata, handles)
% hObject    handle to Atlasedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Atlasedit as text
%        str2double(get(hObject,'String')) returns contents of Atlasedit as a double


% --- Executes during object creation, after setting all properties.
function Atlasedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Atlasedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AtlasBtn.
function AtlasBtn_Callback(hObject, eventdata, handles)
% hObject    handle to AtlasBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[atlas, path]=uigetfile('*.nii');
if (atlas==0)
    set(handles.Atlasedit,'String','Please select atlas.');
else
    set(handles.Atlasedit,'String',[path atlas]);
end



function nativeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nativeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nativeEdit as text
%        str2double(get(hObject,'String')) returns contents of nativeEdit as a double


% --- Executes during object creation, after setting all properties.
function nativeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nativeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nativeBnt.
function nativeBnt_Callback(hObject, eventdata, handles)
% hObject    handle to nativeBnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nativeAtlas=uigetdir();
if (nativeAtlas~=0)
    set(handles.nativeEdit,'String',nativeAtlas);
end



function lFAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lFAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lFAEdit as text
%        str2double(get(hObject,'String')) returns contents of lFAEdit as a double


% --- Executes during object creation, after setting all properties.
function lFAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lFAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hFAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to hFAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hFAEdit as text
%        str2double(get(hObject,'String')) returns contents of hFAEdit as a double


% --- Executes during object creation, after setting all properties.
function hFAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hFAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AngleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to AngleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AngleEdit as text
%        str2double(get(hObject,'String')) returns contents of AngleEdit as a double


% --- Executes during object creation, after setting all properties.
function AngleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AngleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SeedEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SeedEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SeedEdit as text
%        str2double(get(hObject,'String')) returns contents of SeedEdit as a double


% --- Executes during object creation, after setting all properties.
function SeedEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SeedEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InvertPop.
function InvertPop_Callback(hObject, eventdata, handles)
% hObject    handle to InvertPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InvertPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InvertPop


% --- Executes during object creation, after setting all properties.
function InvertPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InvertPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SwapPop.
function SwapPop_Callback(hObject, eventdata, handles)
% hObject    handle to SwapPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SwapPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SwapPop


% --- Executes during object creation, after setting all properties.
function SwapPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SwapPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ConvertCheck.
function ConvertCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ConvertCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ConvertCheck


% --- Executes on button press in EddyCheck.
function EddyCheck_Callback(hObject, eventdata, handles)
% hObject    handle to EddyCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EddyCheck


% --- Executes on button press in TenCalCheck.
function TenCalCheck_Callback(hObject, eventdata, handles)
% hObject    handle to TenCalCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TenCalCheck


% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path]=uiputfile('*.mat', 'Save configure', 'DCPopt.mat');
if ischar(file)
    savename=fullfile(path, file)
    opt=DCP_readOpt(handles);
    save(savename, 'opt');
    msgbox('Configuration Saved!')
end


% --- Executes on button press in LoadBtn.
function LoadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]=uigetfile('*.mat', 'Pcik configuration');
if ischar(file)
    load(fullfile(path, file));
    DCP_load(handles, opt);
end


% --- Executes on button press in NativeCheck.
function NativeCheck_Callback(hObject, eventdata, handles)
% hObject    handle to NativeCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nativeSpace=get(handles.NativeCheck,'Value');
if nativeSpace==1
    set(handles.nativeEdit,'Visible','On');
    set(handles.nativeBnt,'Visible','On');
else
    set(handles.nativeEdit,'Visible','Off');
    set(handles.nativeBnt,'Visible','Off');
end
% Hint: get(hObject,'Value') returns toggle state of NativeCheck


% --- Executes on button press in SPM8.
function SPM8_Callback(hObject, eventdata, handles)
% hObject    handle to SPM8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SPM8Value=get(handles.SPM8,'value');
if SPM8Value==0
    set(handles.SPM8,'value',0);
    set(handles.SPM12,'value',1);
else
    set(handles.SPM8,'value',1);
    set(handles.SPM12,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of SPM8


% --- Executes on button press in SPM12.
function SPM12_Callback(hObject, eventdata, handles)
% hObject    handle to SPM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SPM12Value=get(handles.SPM12,'value');
if SPM12Value==0
    set(handles.SPM12,'value',0);
    set(handles.SPM8,'value',1);
else
    set(handles.SPM12,'value',1);
    set(handles.SPM8,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of SPM12
