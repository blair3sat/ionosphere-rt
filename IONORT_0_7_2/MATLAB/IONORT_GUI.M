function varargout = ionort_gui(varargin)
% IONORT_GUI M-menufile for ionort_gui.fig
%      IONORT_GUI, by itself, creates a new IONORT_GUI or raises the existing
%      singleton*.
%
%      H = IONORT_GUI returns the handle to a new IONORT_GUI or the handle to
%      the existing singleton*.
%
%      IONORT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IONORT_GUI.M with the given input arguments.
%
%      IONORT_GUI('Property','Value',...) creates a new IONORT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ionort_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ionort_gui_OpeningFcn via varargin.
%
%      *See GUI menuoptions on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to about ionort_gui

% Last Modified by GUIDE v2.5 06-Apr-2011 14:51:55

% Path delle librerie / funzioni aggiuntive
path(path, 'lib');
path(path, 'lib\export_fig');
user_string('ghostscript', 'bin\gs\gswin32c.exe');
user_string('pdftops', 'bin\xpdf\pdftops.exe');

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ionort_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ionort_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before ionort_gui is made visible.
function ionort_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ionort_gui (see VARARGIN)

% Choose default command line output for ionort_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ionort_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ionort_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function ionort_gui_1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function latitude_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function latitude_Callback(hObject, eventdata, handles)

latitude = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.latitude = latitude;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function latitudedot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function latitudedot_Callback(hObject, eventdata, handles)

latitudedot = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.latitudedot = latitudedot;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function longitude_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function longitude_Callback(hObject, eventdata, handles)

longitude = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.longitude = longitude;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function longitudedot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function longitudedot_Callback(hObject, eventdata, handles)

longitudedot = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.longitudedot = longitudedot;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function frequency_Callback(hObject, eventdata, handles)

frequency = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.frequency = frequency;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function frequencydot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function frequencydot_Callback(hObject, eventdata, handles)

frequencydot = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.frequencydot = frequencydot;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function elevation_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function elevation_Callback(hObject, eventdata, handles)

elevation = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.elevation = elevation;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function elevationdot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function elevationdot_Callback(hObject, eventdata, handles)

elevationdot = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.elevationdot = elevationdot;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function azimuth_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function azimuth_Callback(hObject, eventdata, handles)

azimuth = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.azimuth = azimuth;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function azimuthdot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function azimuthdot_Callback(hObject, eventdata, handles)

azimuthdot = get(hObject, 'String');

% Save the new latitude value
handles.metricdata.azimuthdot = azimuthdot;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function transmitter_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function transmitter_Callback(hObject, eventdata, handles)

transmitter = get(hObject, 'String');

% Save the new transmitter value
handles.metricdata.transmitter = transmitter;

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function receiver_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function receiver_Callback(hObject, eventdata, handles)

receiver = get(hObject, 'String');

% Save the new receiver value
handles.metricdata.receiver = receiver;

% Update handles structure
guidata(hObject,handles)


% --- Executes on button press in step.
function step_Callback(hObject, eventdata, handles)

step = get(hObject, 'Value');

% Save the new step_in value
handles.step = step;

% Update handles structure
guidata(hObject,handles)


% --- Executes on selection change in step_in.
function step_in_Callback(hObject, eventdata, handles)

step_in = get(hObject, 'Value');

% Save the new step_in value
handles.step_in = step_in;

% Update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function step_in_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_end_Callback(hObject, eventdata, handles)

step_end = get(hObject, 'String');

% Save the new step_end value
handles.metricdata.step_end = step_end;

% Update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function step_end_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_enddot_Callback(hObject, eventdata, handles)

step_enddot = get(hObject, 'String');

% Save the new step_enddot value
handles.metricdata.step_enddot = step_enddot;

% Update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function step_enddot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_step_Callback(hObject, eventdata, handles)

step_step = get(hObject, 'String');

% Save the new step_step value
handles.metricdata.step_step = step_step;

% Update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function step_step_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_stepdot_Callback(hObject, eventdata, handles)

step_stepdot = get(hObject, 'String');

% Save the new step_enddot value
handles.metricdata.step_stepdot = step_stepdot;

% Update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function step_stepdot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -----------
% --- RUN ---
% -----------
function run_Callback(hObject, eventdata, handles)

h = hObject(1); % Get the caller's handle.
col = get(h,'backg');  % Get the background color of the figure.
set(h,'backg',[1 0 0]) % Change color of button.

global default

default.main.tlat = num2str( radians( str2double( strcat( handles.metricdata.latitude, '.', handles.metricdata.latitudedot) ) ), '%1.8f' );
default.main.tlon = num2str( radians( str2double( strcat( handles.metricdata.longitude, '.', handles.metricdata.longitudedot) ) ), '%1.8f' );
default.main.fbeg = char( strcat( handles.metricdata.frequency, '.', handles.metricdata.frequencydot ) );
default.main.elbeg = num2str( radians( str2double( strcat( handles.metricdata.elevation, '.', handles.metricdata.elevationdot) ) ), '%1.8f' );
default.main.azbeg = num2str( radians( str2double( strcat( handles.metricdata.azimuth, '.', handles.metricdata.azimuthdot) ) ), '%1.8f' );
default.main.xmtrh = num2str( str2double( handles.metricdata.transmitter ) );
default.main.rcvrh = num2str( str2double( handles.metricdata.receiver ) );
if ( handles.step == 1 )
    switch handles.step_in
        case 2
            default.main.fend = char( strcat( handles.metricdata.step_end, '.', handles.metricdata.step_enddot ) );
            default.main.fstep = char( strcat( handles.metricdata.step_step, '.', handles.metricdata.step_stepdot ) );
			default.main.elend = num2str( 0, '%1.8f' );
			default.main.elstep = num2str( 0, '%1.8f' );
			default.main.azend = num2str( 0, '%1.8f' );
			default.main.azstep = num2str( 0, '%1.8f' );
		case 3
            default.main.fend = num2str( 0, '%1.8f' );
			default.main.fstep = num2str( 0, '%1.8f' );
            default.main.elend = num2str( radians( str2double( strcat( handles.metricdata.step_end, '.', handles.metricdata.step_enddot) ) ), '%1.8f' );
            default.main.elstep = num2str( radians( str2double( strcat( handles.metricdata.step_step, '.', handles.metricdata.step_stepdot) ) ), '%1.8f' );
			default.main.azend = num2str( 0, '%1.8f' );
			default.main.azstep = num2str( 0, '%1.8f' );
        case 4
			default.main.fend = num2str( 0, '%1.8f' );
			default.main.fstep = num2str( 0, '%1.8f' );
			default.main.elend = num2str( 0, '%1.8f' );
			default.main.elstep = num2str( 0, '%1.8f' );
            default.main.azend = num2str( radians( str2double( strcat( handles.metricdata.step_end, '.', handles.metricdata.step_enddot) ) ), '%1.8f' );
            default.main.azstep = num2str( radians( str2double( strcat( handles.metricdata.step_step, '.', handles.metricdata.step_stepdot) ) ), '%1.8f' );
    end
else
    default.main.fend = num2str( 0, '%1.8f' );
    default.main.fstep = num2str( 0, '%1.8f' );
    default.main.elend = num2str( 0, '%1.8f' );
    default.main.elstep = num2str( 0, '%1.8f' );
    default.main.azend = num2str( 0, '%1.8f' );
    default.main.azstep = num2str( 0, '%1.8f' );
end

if ( strcmp(get( get( handles.ray, 'SelectedObject' ), 'tag' ), 'ray_extra') == 1 ) 
    ionort_ray = '-1';
else
    ionort_ray = '1';
end

default.main.ray = ionort_ray;

% Results reset
set(findobj('Tag', 'result_latitude'), 'String', '-' );
set(findobj('Tag', 'result_longitude'), 'String', '-' );
set(findobj('Tag', 'result_apogee'), 'String', '-' );
set(findobj('Tag', 'result_groupdelay'), 'String', '-' );
set(findobj('Tag', 'result_grouppath'), 'String', '-' );
set(findobj('Tag', 'result_plasmafreq'), 'String', '-' );

%
ionort_model = get( get( handles.model,'SelectedObject' ), 'tag' );

% 
ionort( default, ionort_model );

% Now reset the button features.
set(h,'backg',col)


% --- RESET
function reset_Callback(hObject, eventdata, handles)

h = findobj('Tag','az');
cla(h,'reset');

% Update handles structure
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

global default

default = fetchIniData('DATA_default.ini');

tlat = degrees( str2double( default.main.tlat ) );
tlon = degrees( str2double( default.main.tlon ) );
elbeg = degrees( str2double( default.main.elbeg ) );
azbeg = degrees( str2double( default.main.azbeg ) );
xmtrh = str2double( default.main.xmtrh );
rcvrh = str2double( default.main.rcvrh );
fend = str2double( default.main.fend );
fstep = str2double( default.main.fstep );
elend = degrees( str2double( default.main.elend ) );
elstep = degrees( str2double( default.main.elstep ) );
azend = degrees( str2double( default.main.azend ) );
azstep = degrees( str2double( default.main.azstep ) );
ray = str2double( default.main.ray );

latitudeparts = regexp( num2str(tlat, '%2.4f'), '\.', 'split' );
longitudeparts = regexp( num2str(tlon, '%3.4f'), '\.', 'split' );
frequencyparts = regexp( default.main.fbeg, '\.', 'split' );
elevationparts = regexp( num2str(elbeg, '%2.1f'), '\.', 'split' );
azimuthparts = regexp( num2str(azbeg, '%3.1f'), '\.', 'split' );
transmitterparts = num2str(xmtrh, '%3.0f');
receiverparts = num2str(rcvrh, '%3.0f');
endfrequencyparts = regexp( num2str(fend, '%2.1f'), '\.', 'split' );
stepfrequencyparts = regexp( num2str(fstep, '%2.1f'), '\.', 'split' );
endelevationparts = regexp( num2str(elend, '%2.1f'), '\.', 'split' );
stepelevationparts = regexp( num2str(elstep, '%2.1f'), '\.', 'split' );
endazimuthparts = regexp( num2str(azend, '%3.1f'), '\.', 'split' );
stepazimuthparts = regexp( num2str(azstep, '%3.1f'), '\.', 'split' );

handles.metricdata.latitude = latitudeparts(1);
handles.metricdata.latitudedot = latitudeparts(2);
handles.metricdata.longitude = longitudeparts(1);
handles.metricdata.longitudedot = longitudeparts(2);
handles.metricdata.frequency = frequencyparts(1);
handles.metricdata.frequencydot = frequencyparts(2);
handles.metricdata.elevation = elevationparts(1);
handles.metricdata.elevationdot = elevationparts(2);
handles.metricdata.azimuth = azimuthparts(1);
handles.metricdata.azimuthdot = azimuthparts(2);
handles.metricdata.transmitter = transmitterparts;
handles.metricdata.receiver = receiverparts;
handles.metricdata.step_end = '0';
handles.metricdata.step_enddot = '0';
handles.metricdata.step_step = '0';
handles.metricdata.step_stepdot = '0';

set( handles.latitude, 'String', handles.metricdata.latitude );
set( handles.latitudedot, 'String', handles.metricdata.latitudedot );
set( handles.longitude, 'String', handles.metricdata.longitude );
set( handles.longitudedot, 'String', handles.metricdata.longitudedot );
set( handles.frequency, 'String', handles.metricdata.frequency );
set( handles.frequencydot, 'String', handles.metricdata.frequencydot );
set( handles.elevation, 'String', handles.metricdata.elevation );
set( handles.elevationdot, 'String', handles.metricdata.elevationdot );
set( handles.azimuth, 'String', handles.metricdata.azimuth );
set( handles.azimuthdot, 'String', handles.metricdata.azimuthdot );
set( handles.transmitter, 'String', handles.metricdata.transmitter );
set( handles.receiver, 'String', handles.metricdata.receiver );

if any(fstep)
    set( handles.step_in, 'Value', 2 );
    handles.metricdata.step_end = endfrequencyparts(1);
    handles.metricdata.step_enddot = endfrequencyparts(2);
    handles.metricdata.step_step = stepfrequencyparts(1);
    handles.metricdata.step_stepdot = stepfrequencyparts(2);
end

if any(elstep)
    set( handles.step_in, 'Value', 3 );
    handles.metricdata.step_end = endelevationparts(1);
    handles.metricdata.step_enddot = endelevationparts(2);
    handles.metricdata.step_step = stepelevationparts(1);
    handles.metricdata.step_stepdot = stepelevationparts(2);
end

if any(azstep)
    set( handles.step_in, 'Value', 4 );
    handles.metricdata.step_end = endazimuthparts(1);
    handles.metricdata.step_enddot = endazimuthparts(2);
    handles.metricdata.step_step = stepazimuthparts(1);
    handles.metricdata.step_stepdot = stepazimuthparts(2);
end

if any(fstep) | any(azstep) | any(elstep) 
    set( handles.step, 'Value', 1 );
    set( handles.step_end, 'String', handles.metricdata.step_end );
    set( handles.step_enddot, 'String', handles.metricdata.step_enddot );
    set( handles.step_step, 'String', handles.metricdata.step_step );
    set( handles.step_stepdot, 'String', handles.metricdata.step_stepdot );
end

if ray > 0
    set(handles.ray_ordinary,'Value',1);
else
    set(handles.ray_extra,'Value',1);
end

% Update handles structure
guidata(handles.figure1, handles);

% Focus 3D
h = findobj('Tag', 'earth');
set(gcf,'CurrentAxes', h);

% Creazione del globo terrestre
earth;

view([90 0]);

% Controlli 3D
cameratoolbar('Show');

% Focus sul 2D
h = findobj('Tag','az');
set(gcf,'CurrentAxes',h);

% Etichette assi
xlabel('Ground Range [km]','fontweight','b');
ylabel('Altitude [km]','fontweight','b');


% --- Executes on button press in step_no.
function step_no_Callback(hObject, eventdata, handles)
% hObject    handle to step_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step_no


% --- Executes on button press in step_frequency.
function step_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to step_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step_frequency


% --- Executes on button press in step_elevation.
function step_elevation_Callback(hObject, eventdata, handles)
% hObject    handle to step_elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step_elevation


% --- Executes on button press in step_azimuth.
function step_azimuth_Callback(hObject, eventdata, handles)
% hObject    handle to step_azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step_azimuth


% --------------------------------------------------------------------
function menufile_Callback(hObject, eventdata, handles)
% hObject    handle to menufile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuoptions_Callback(hObject, eventdata, handles)
% hObject    handle to menuoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuhelp_Callback(hObject, eventdata, handles)
% hObject    handle to menuhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in chapman_nf.
function chapman_nf_Callback(hObject, eventdata, handles)
% hObject    handle to chapman_nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chapman_nf


% --- Executes on button press in chapman_wf.
function chapman_wf_Callback(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chapman_wf

% --- Executes on button press in chapman_wf.
function ray_ordinary_Callback(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chapman_wf

% --- Executes on button press in chapman_wf.
function ray_extra_Callback(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chapman_wf

% --- Executes during object creation, after setting all properties.
function chapman_nf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chapman_nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function chapman_wf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function ray_ordinary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function ray_extra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chapman_wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function frame1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% EXPORT 2D EPS
function export_2dplot2eps_Callback(hObject, eventdata, handles)

h = findobj('Tag','az');
set(gcf,'CurrentAxes',h);
set(gcf, 'Color', 'none'); % Sets figure background
fileName = inputdlg('Please enter the file name');
directoryName = uigetdir('','Please select a folder to save to');
filePath = fullfile(directoryName,fileName{1});
export_fig(h, filePath, '-eps');
warndlg('File saved');

% EXIT
function exit_Callback(hObject, eventdata, handles)

close(handles.figure1);


% ABOUT
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;


% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



