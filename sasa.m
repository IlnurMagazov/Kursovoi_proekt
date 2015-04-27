function varargout = sasa(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sasa_OpeningFcn, ...
                   'gui_OutputFcn',  @sasa_OutputFcn, ...
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
% --- Executes just before sasa is made visible.
function sasa_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sasa (see VARARGIN)
% Choose default command line output for sasa
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes sasa wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = sasa_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in inform.
function inform_Callback(hObject, eventdata, handles)
% hObject    handle to inform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inform % объявляем глобально.         
[nombre direc]=uigetfile('*.xlsx','inform'); % делаем путь с помощью функции uigetfile.
inform=strcat(direc,nombre); % имя файла, который вызываем.
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inform 
M=xlsread(inform); % открываем экселевский файл с помощью xlsread.
Signal=M(:,1);
FftL=length(Signal);       % Количество линий Фурье спектра. Равно количеству отчетов сигнала
%% Спектральное представление сигнала
FftS=abs(fft(Signal,FftL));% Амплитуды преобразования Фурье сигнала
FftS=2*FftS./FftL;% Нормировка спектра по амплитуде
Fd=str2double(get(handles.edit2,'String')); %частота дискретизации которую я выдумал а может и не выдумал; %частота дискретизации которую я выдумал а может и не выдумал
F=0:Fd/FftL:Fd/2-1/FftL;% Массив частот вычисляемого спектра Фурье
axes(handles.axes2)
plot(F,FftS(1:length(F)));
ylabel('Амплитуда'); % подписываем ось Амплитуд.   
xlabel('Частота, Гц');
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inform 
M=xlsread(inform); % открываем экселевский файл с помощью xlsread.
Signal=M(:,1);
FftL=length(Signal);       % Количество линий Фурье спектра. Равно количеству отчетов сигнала

%% Спектральное представление сигнала
FftS=fft(Signal,FftL);     % Получени спектра по ДПФ (или БПФ, по возможности)
FftS=FftS.*conj(FftS)/FftL;% FftS - спектральная плотность мощности
FftS=FftS(1:(FftL/2));
%% Построение графиков сигнала и спектра
axes(handles.axes1)
plot(Signal);    
ylabel('Амплитуда'); % подписываем ось Амплитуд.   
xlabel('Условное время');
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inform 
M=xlsread(inform); % открываем экселевский файл с помощью xlsread.
Signal=M(:,1);
FftL=length(Signal); % Количество линий Фурье спектра. Равно количеству отчетов сигнала

%% Спектральное представление сигнала
FftS=fft(Signal,FftL);     % Получени спектра по ДПФ (или БПФ, по возможности)
FftS=FftS.*conj(FftS)/FftL;% FftS - спектральная плотность мощности
FftS=FftS(1:(FftL/2));     % Берем половину спектра

%% Нормировка по масимальному значению
FftS=FftS./max(FftS);    
%% Построение графика сигнала и нормированного спектра
Fd=str2double(get(handles.edit2,'String')); %частота дискретизации которую я выдумал а может и не выдумал
F=0:Fd/FftL:Fd/2-1/FftL;% Массив частот вычисляемого спектра Фурье      
axes(handles.axes3)
plot(F,FftS(1:length(F)));    
ylabel('Амплитуда'); % подписываем ось Амплитуд.   
xlabel('Частота, Гц');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla (handles.axes1,'reset') % стираем нарисованные графики. 
cla (handles.axes2,'reset') 
cla (handles.axes3,'reset')
set(handles.edit2,'String',[])
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inform 
M=xlsread(inform); % открываем экселевский файл с помощью xlsread.
Signal=M(:,1);
FftL=length(Signal);% Количество линий Фурье спектра. Равно количеству отчетов сигнала

%% Спектральное представление сигнала
FftS=fft(Signal,FftL);     % Получени спектра по ДПФ (или БПФ, по возможности)
FftS=FftS.*conj(FftS)/FftL;% FftS - спектральная плотность мощности
FftS=FftS(1:(FftL/2));     % Берем половину спектра
Fd=str2double(get(handles.edit2,'String')); %частота дискретизации которую я выдумал а может и не выдумал; %частота дискретизации которую я выдумал а может и не выдумал
F=0:Fd/FftL:Fd/2-Fd/FftL;    %Массив частот вычисляемого спектра Фурье
%% Нормировка по масимальному значению
FftS=FftS./max(FftS);   
%% Определение несущих частот по спектру сигнала
minpks=0.05;    %определяем минимальное значение пиков, ниже которых пиики не берем 
distance=5;     %определяем минимальное расстояние между пиками
[pks,locs] = findpeaks(FftS,'MINPEAKHEIGHT',minpks,'MINPEAKDISTANCE',distance);%выводит пики амплидуд синусодит и значения частот при которых они достигаются
%pks - значение пика, locs - значение частоты
freequency=locs.*(Fd/FftL);
set(handles.uitable1,'data',freequency);
