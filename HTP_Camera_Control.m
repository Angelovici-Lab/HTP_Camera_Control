function varargout = HTP_Camera_Control(varargin)
% HTP_CAMERA_CONTROL MATLAB code for HTP_Camera_Control.fig
%      HTP_CAMERA_CONTROL, by itself, creates a new HTP_CAMERA_CONTROL or raises the existing
%      singleton*.
%
%      H = HTP_CAMERA_CONTROL returns the handle to a new HTP_CAMERA_CONTROL or the handle to
%      the existing singleton*.
%
%      HTP_CAMERA_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HTP_CAMERA_CONTROL.M with the given input arguments.
%
%      HTP_CAMERA_CONTROL('Property','Value',...) creates a new HTP_CAMERA_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HTP_Camera_Control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HTP_Camera_Control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HTP_Camera_Control

% Last Modified by GUIDE v2.5 03-Nov-2017 14:28:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HTP_Camera_Control_OpeningFcn, ...
                   'gui_OutputFcn',  @HTP_Camera_Control_OutputFcn, ...
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


% --- Executes just before HTP_Camera_Control is made visible.
function HTP_Camera_Control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HTP_Camera_Control (see VARARGIN)

% Choose default command line output for HTP_Camera_Control
handles.output = hObject;

% include java read 2D code library
javaaddpath('.\core-3.3.0.jar');
javaaddpath('.\javase-3.3.0.jar');

% dialog box that gathers user ID
user_id = inputdlg('Enter student login ID: ', 'Input Student Login ID');
user_id = user_id{1};

% initialize an image processor 
imageProcessor = ImageProcessor([], [], []);
imageProcessor = imageProcessor.setSavePath('D:\Image_data\');

%DFK AFUJ003-M12 camera input
streaming_obj1 = videoinput('winvideo', 1, 'RGB32_3872x2764');
streaming_obj2 = videoinput('winvideo', 2, 'RGB32_3872x2764');
streaming_obj3 = videoinput('winvideo', 3, 'RGB32_3872x2764');

% Select the source to use for acquisition.
set(streaming_obj1, 'SelectedSourceName', 'input1');
set(streaming_obj2, 'SelectedSourceName', 'input1');
set(streaming_obj3, 'SelectedSourceName', 'input1');

% View the properties for the selected video source object.
streaming_src_obj1 = getselectedsource(streaming_obj1);
get(streaming_src_obj1);
streaming_src_obj2 = getselectedsource(streaming_obj2);
get(streaming_src_obj2);
streaming_src_obj3 = getselectedsource(streaming_obj3);
get(streaming_src_obj3);

% get camera resolution
streaming_vidRes1 = streaming_obj1.VideoResolution;
streaming_vidRes2 = streaming_obj2.VideoResolution;
streaming_vidRes3 = streaming_obj3.VideoResolution;

% get camera's bands (color)
streaming_nBands1 = streaming_obj1.NumberOfBands;
streaming_nBands2 = streaming_obj2.NumberOfBands;
streaming_nBands3 = streaming_obj3.NumberOfBands;

% display setting and preview
streaming_axes1 = image(zeros(streaming_vidRes1(2), streaming_vidRes1(1), streaming_nBands1), 'Parent', handles.streaming1);
streaming_axes2 = image(zeros(streaming_vidRes2(2), streaming_vidRes2(1), streaming_nBands2), 'Parent', handles.streaming2);
streaming_axes3 = image(zeros(streaming_vidRes3(2), streaming_vidRes3(1), streaming_nBands3), 'Parent', handles.streaming3);
preview(streaming_obj1, streaming_axes1);
preview(streaming_obj2, streaming_axes2);
preview(streaming_obj3, streaming_axes3);
pause(1);

% transfer streaming objects to handles
handles.streaming_obj1 = streaming_obj1;
handles.streaming_obj2 = streaming_obj2;
handles.streaming_obj3 = streaming_obj3;
handles.imageProcessor = imageProcessor;
handles.user_id = user_id;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HTP_Camera_Control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HTP_Camera_Control_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in snapButton.
function snapButton_Callback(hObject, eventdata, handles)
% hObject    handle to snapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get objects from handles
streaming_obj1 = handles.streaming_obj1;
streaming_obj2 = handles.streaming_obj2;
streaming_obj3 = handles.streaming_obj3;
imageProcessor = handles.imageProcessor;
user_id = handles.user_id;

% set streaming object to be in RGB mode
set(streaming_obj1, 'ReturnedColorSpace', 'RGB');
set(streaming_obj2, 'ReturnedColorSpace', 'RGB');
set(streaming_obj3, 'ReturnedColorSpace', 'RGB');

% get a snapshot and convert the image into datatype double
image_frame1_dist = getsnapshot(streaming_obj1);
image_frame2_dist = getsnapshot(streaming_obj2);
image_frame3_dist = getsnapshot(streaming_obj3);

%undistort all images using lensdistort(image, undistort_coefficient)
image_frame1 = lensdistort(image_frame1_dist, -0.16);
image_frame2 = lensdistort(image_frame2_dist, -0.1);
image_frame3 = lensdistort(image_frame3_dist, -0.2);

% get experiment name and round number
expName = get(handles.expNameText, 'string');

imageProcessor = imageProcessor.setExperimentName(expName);
imageProcessor = imageProcessor.setLeftSideImage(image_frame1);
imageProcessor = imageProcessor.setTopImage(image_frame2);
imageProcessor = imageProcessor.setRightSideImage(image_frame3);
[image_sframe1, image_sframe2, image_sframe3, image_sframe4] = imageProcessor.leftCamCrop();
[image_stframe5, image_stframe6, image_stframe7, image_stframe8, image_stframe9, image_stframe10, image_stframe11, image_stframe12] = imageProcessor.topCamCrop();
[image_sframe13, image_sframe14, image_sframe15, image_sframe16] = imageProcessor.rightCamCrop();
imageProcessor = imageProcessor.scanUPCA();
imageProcessor = imageProcessor.saveImagesUsingUPCA();

% show picture on the axes
imshow(image_sframe1, 'Parent', handles.image1);
imshow(image_sframe2, 'Parent', handles.image2);
imshow(image_sframe3, 'Parent', handles.image3);
imshow(image_sframe4, 'Parent', handles.image4);
imshow(image_stframe5, 'Parent', handles.image5);
imshow(image_stframe6, 'Parent', handles.image6);
imshow(image_stframe7, 'Parent', handles.image7);
imshow(image_stframe8, 'Parent', handles.image8);
imshow(image_stframe9, 'Parent', handles.image9);
imshow(image_stframe10, 'Parent', handles.image10);
imshow(image_stframe11, 'Parent', handles.image11);
imshow(image_stframe12, 'Parent', handles.image12);
imshow(image_sframe13, 'Parent', handles.image13);
imshow(image_sframe14, 'Parent', handles.image14);
imshow(image_sframe15, 'Parent', handles.image15);
imshow(image_sframe16, 'Parent', handles.image16);

function expNameText_Callback(hObject, eventdata, handles)
% hObject    handle to expNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expNameText as text
%        str2double(get(hObject,'String')) returns contents of expNameText as a double


% --- Executes during object creation, after setting all properties.
function expNameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roundNumberText_Callback(hObject, eventdata, handles)
% hObject    handle to roundNumberText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roundNumberText as text
%        str2double(get(hObject,'String')) returns contents of roundNumberText as a double


% --- Executes during object creation, after setting all properties.
function roundNumberText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roundNumberText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trayNumberText_Callback(hObject, eventdata, handles)
% hObject    handle to trayNumberText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trayNumberText as text
%        str2double(get(hObject,'String')) returns contents of trayNumberText as a double


% --- Executes during object creation, after setting all properties.
function trayNumberText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trayNumberText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
