function varargout = Guide_Proyecto(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Guide_Proyecto_OpeningFcn, ...
    'gui_OutputFcn',  @Guide_Proyecto_OutputFcn, ...
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


% --- Executes just before Guide_Proyecto is made visible.
function Guide_Proyecto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Guide_Proyecto (see VARARGIN)

% Choose default command line output for Guide_Proyecto
global Conectar_ESP;
global stream_on;
global a;
global IN1;
global IN2;
global ENA;
global IN3;
global IN4;
global ENB;
IN1 = 'D2';
IN2 = 'D3';
ENA = 'D4';
IN3 = 'D5';
IN4 = 'D6';
ENB = 'D7';
import cv2.*;
Conectar_ESP = false;
stream_on = false;
a = arduino
disp('ESP 32 Conectada');
configurePin(a, IN1, 'DigitalOutput');
configurePin(a, IN2, 'DigitalOutput');
configurePin(a, ENA, 'PWM');
configurePin(a, IN3, 'DigitalOutput');
configurePin(a, IN4, 'DigitalOutput');
configurePin(a, ENB, 'PWM');

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Guide_Proyecto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Guide_Proyecto_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Boton_Adelante.
function Boton_Adelante_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Adelante (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Adelante')
movimiento(1,1);

% --- Executes on button press in Boton_Izquierda.
function Boton_Izquierda_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Izquierda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movimiento(2,1);

% --- Executes on button press in Boton_Atras.
function Boton_Atras_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Atras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movimiento(2,2);

% --- Executes on button press in Boton_Derecha.
function Boton_Derecha_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Derecha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movimiento(1,2);

% --- Executes on button press in Comando_Voz.
function Comando_Voz_Callback(hObject, eventdata, handles)
% hObject    handle to Comando_Voz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load RedAudio.mat
recObj = audiorecorder(8000,16,1,1);
set(handles.Comando_Voz,'string','Inicializando Micro');
disp('Inicializando Micro');
recordblocking(recObj,2);
n=1;

for k=1:1:n
    %   set(handles.Comando_Control_Voz,'string','Presione ENTER para grabar');
    %   b=input('Presione ENTER para grabar');
    disp('Hable');
    set(handles.Comando_Voz,'string','Hable');
    recordblocking(recObj,3);
    disp('Silencio');
    set(handles.Comando_Voz,'string','Silencio');
    y = getaudiodata(recObj);
    MF=mfcc(y,8000);
    RtaVoz=sim(RedVoz,MF(:))
    for i = 1:length(RtaVoz)
        if RtaVoz(i) >= 0.75 && RtaVoz(i) <= 1
            switch i
                case 1
                    set(handles.Comando_Voz,'string','Adelante');
                    movimiento(1,1);
                case 2
                    set(handles.Comando_Voz,'string','Atras');
                    movimiento(2,2);

                case 3
                    set(handles.Comando_Voz,'string','Izquierda');
                    movimiento(2,1);
                case 4
                    set(handles.Comando_Voz,'string','Derecha');
                    movimiento(1,2);
                case 5
                    set(handles.Comando_Voz, 'string', '180');
                    movimiento(1,2);

            end
        end
    end
    pause(1);
    set(handles.Comando_Voz,'string','Control Voz');
end


% --- Executes on button press in Control_Camara.
function Control_Camara_Callback(hObject, eventdata, handles)
% hObject    handle to Control_Camara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stream_on;
disp(stream_on)
if stream_on == false
  % Start the stream
  ipcam_url = 'http://192.168.10.22/240x240.mjpeg';
  ipcam_handle = ipcam(ipcam_url);
  stream_on = true;
else
  % Stop the stream
  stream_on = false;
  clear frame;
  clear ipcam_handle
end
while stream_on

  frame = snapshot(ipcam_handle);
  imshow(frame,'Parent',handles.Ver_Camara);
  [msg,~,loc] = readBarcode(frame);
  disp(msg)
end


function movimiento(Sentido1,Sentido2)
global a;
global IN1;
global IN2;
global ENA;
global IN3;
global IN4;
global ENB;
switch Sentido1
    case 1
        M1 = IN1;
        S1 = 1;
    case 2
        M1 = IN2;
        S1 = 1;
    case 0
        M1 = IN1;
        S1 = 0;
end
switch Sentido2
    case 1
        M2 = IN3;
        S2 = 1;
    case 2
        M2 = IN4;
        S2 = 1;
    case 0
        M2 = IN3
        S2 = 0;

end

writePWMDutyCycle(a, ENA, 1);
writePWMDutyCycle(a, ENB, 1);
writeDigitalPin(a, M1, S1);
writeDigitalPin(a, M2, S2);

pause(1);

writeDigitalPin(a, IN1, 0);
writeDigitalPin(a, IN2, 0);
writePWMDutyCycle(a, ENA, 0);
writeDigitalPin(a, IN3, 0);
writeDigitalPin(a, IN4, 0);
writePWMDutyCycle(a, ENB, 0);
disp('detenido')





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global a;
clear a;
disp('ESP 32 Desconectada')
delete(hObject);
clear all;


% --- Executes on button press in Conectar_ESP.
% function Conectar_ESP_Callback(hObject, eventdata, handles)
% % % hObject    handle to Conectar_ESP (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% global Conectar_ESP;
% global a;
% global IN1;
% global IN2;
% global ENA;
% global IN3;
% global IN4;
% global ENB;
% IN1 = 'D27';
% IN2 = 'D26';
% ENA = 'D14';
% IN3 = 'D32';
% IN4 = 'D33';
% ENB = 'D33';
% Conectar_ESP = ~Conectar_ESP;
% if Conectar_ESP == true
%     set(handles.Conectar_ESP, 'String', 'Conectando...');
%     a = arduino
%     disp('ESP 32 Conectada');
%     set(handles.Conectar_ESP, 'BackgroundColor', '0.47 0.67 0.19');
%     set(handles.Conectar_ESP, 'String', 'Conectado');
%     pause(1);
%     set(handles.Conectar_ESP, 'BackgroundColor', '0.94 0.94 0.94');
%     configurePin(a, IN1, 'DigitalOutput');
%     configurePin(a, IN2, 'DigitalOutput');
%     configurePin(a, ENA, 'PWM');
%     configurePin(a, IN3, 'DigitalOutput');
%     configurePin(a, IN4, 'DigitalOutput');
%     configurePin(a, ENB, 'PWM');
% else
%     clear a
%     clear arduino_object ;
%     if ~isempty(instrfind({'Port'}, {'COM3'}))
%         fclose(instrfind({'Port'}, {'COM3'}));
%         delete(instrfind({'Port'}, {'COM3'}));
%     end
%     disp('ESP 32 Desconectada');
%     set(handles.Conectar_ESP, 'BackgroundColor', '0.64 0.08 0.18');
%     set(handles.Conectar_ESP, 'String', 'ESP 32 Desconectada');
%     pause(1);
%     set(handles.Conectar_ESP, 'BackgroundColor', '0.94 0.94 0.94');
%     set(handles.Conectar_ESP, 'String', 'Conectar ESP32');
% end
