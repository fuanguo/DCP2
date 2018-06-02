function varargout = parcellation(varargin)
% PARCELLATION MATLAB code for parcellation.fig
%      PARCELLATION, by itself, creates a new PARCELLATION or raises the existing
%      singleton*.
%
%      H = PARCELLATION returns the handle to a new PARCELLATION or the handle to
%      the existing singleton*.
%
%      PARCELLATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARCELLATION.M with the given input arguments.
%
%      PARCELLATION('Property','Value',...) creates a new PARCELLATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parcellation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parcellation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parcellation

% Last Modified by GUIDE v2.5 22-Mar-2018 07:54:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parcellation_OpeningFcn, ...
                   'gui_OutputFcn',  @parcellation_OutputFcn, ...
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


% --- Executes just before parcellation is made visible.
function parcellation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parcellation (see VARARGIN)

% Choose default command line output for parcellation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes parcellation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = parcellation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in parCheck.
function parCheck_Callback(hObject, eventdata, handles)
% hObject    handle to parCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of parCheck



function temEdit_Callback(hObject, eventdata, handles)
% hObject    handle to temEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temEdit as text
%        str2double(get(hObject,'String')) returns contents of temEdit as a double


% --- Executes during object creation, after setting all properties.
function temEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in temBtn.
function temBtn_Callback(hObject, eventdata, handles)
% hObject    handle to temBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
