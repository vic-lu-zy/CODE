function varargout = spectrogram_gui(varargin)
% SPECTROGRAM_GUI MATLAB code for spectrogram_gui.fig
%      SPECTROGRAM_GUI, by itself, creates a new SPECTROGRAM_GUI or raises the existing
%      singleton*.
%
%      H = SPECTROGRAM_GUI returns the handle to a new SPECTROGRAM_GUI or the handle to
%      the existing singleton*.
%
%      SPECTROGRAM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTROGRAM_GUI.M with the given input arguments.
%
%      SPECTROGRAM_GUI('Property','Value',...) creates a new SPECTROGRAM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrogram_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrogram_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrogram_gui

% Last Modified by GUIDE v2.5 29-Jul-2014 16:23:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrogram_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrogram_gui_OutputFcn, ...
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


% --- Executes just before spectrogram_gui is made visible.
function spectrogram_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrogram_gui (see VARARGIN)

[lfp_filename,lfp_path] = uigetfile;
cd(lfp_path)
handles.lfp_data = load(lfp_filename);
% Choose default command line output for spectrogram_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spectrogram_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spectrogram_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_figure.
function save_figure_Callback(hObject, eventdata, handles)
% hObject    handle to save_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in choose_file.
function choose_file_Callback(hObject, eventdata, handles)
% hObject    handle to choose_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spect_filename = uigetfile;
handles.spect_data = load(spect_filename);

function trial_number_Callback(hObject, eventdata, handles)
% hObject    handle to trial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_number as text
%        str2double(get(hObject,'String')) returns contents of trial_number as a double


% --- Executes during object creation, after setting all properties.
function trial_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channel_number_Callback(hObject, eventdata, handles)
% hObject    handle to channel_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channel_number as text
%        str2double(get(hObject,'String')) returns contents of channel_number as a double


% --- Executes during object creation, after setting all properties.
function channel_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_range_Callback(hObject, eventdata, handles)
% hObject    handle to time_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_range as text
%        str2double(get(hObject,'String')) returns contents of time_range as a double


% --- Executes during object creation, after setting all properties.
function time_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [lfp, spect] = update_figures

