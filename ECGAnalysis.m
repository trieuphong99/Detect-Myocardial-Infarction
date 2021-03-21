function varargout = ECGAnalysis(varargin)
% ECGANALYSIS MATLAB code for ECGAnalysis.fig
%      ECGANALYSIS, by itself, creates a new ECGANALYSIS or raises the existing
%      singleton*.
%
%      H = ECGANALYSIS returns the handle to a new ECGANALYSIS or the handle to
%      the existing singleton*.
%
%      ECGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECGANALYSIS.M with the given input arguments.
%
%      ECGANALYSIS('Property','Value',...) creates a new ECGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECGAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECGAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECGAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @ECGAnalysis_OutputFcn, ...
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

% --- Executes just before ECGAnalysis is made visible.
function ECGAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECGAnalysis (see VARARGIN)

% Choose default command line output for ECGAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clc
clearvars

% UIWAIT makes ECGAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ECGAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecgdata;
global ecg_filtered;
global Rpeaks;
global Swave;
global Qwave;
global Twave;
global Pwave;
global halfRR;
global numberofpeaks;

[filename,path] = uigetfile('.xlsx','Choose exell file to open');
ecgdata = xlsread(strcat(path,filename));
ecgdata = ecgdata';	%   transpose a row into a column
ecgdata(1,:) = [];  %   Delete the first row because that row is numerical order
samplingrate = 1000;
x = 1:1:10000;
axes(handles.d1);
plot(x, ecgdata(1, x), 'g');
axes(handles.d2);
plot(x, ecgdata(2, x), 'g');
axes(handles.d3);
plot(x, ecgdata(3, x), 'g');
axes(handles.aVR);
plot(x, ecgdata(4, x), 'g');
axes(handles.aVL);
plot(x, ecgdata(5, x), 'g');
axes(handles.aVF);
plot(x, ecgdata(6, x), 'g');
axes(handles.V1);
plot(x, ecgdata(7, x), 'g');
axes(handles.V2);
plot(x, ecgdata(8, x), 'g');
axes(handles.V3);
plot(x, ecgdata(9, x), 'g');
axes(handles.V4);
plot(x, ecgdata(10, x), 'g');
axes(handles.V5);
plot(x, ecgdata(11, x), 'g');
axes(handles.V6);
plot(x, ecgdata(12, x), 'g');

HeartRate = 0;
for lead = 1:1:12
  %   Remove lower frequencies
    clear ECG_FreqTrans Rpeaks1 ir1 ir2;
    ECG_FreqTrans=fft(ecgdata(lead,:));
    ECG_FreqTrans(1 : round(length(ECG_FreqTrans)*5/samplingrate))=0; %HPF
    ECG_FreqTrans((end - round(length(ECG_FreqTrans)*5/samplingrate)) : end)=0; %LPF
    %   Back to the Time Domain
    ecg_filtered(lead,:)=real(ifft(ECG_FreqTrans));
    
    %   Detect R peaks
    Rpeaks1 = detectRpeaks(ecg_filtered(lead,:), samplingrate);
    numberofpeaks(lead) = length(Rpeaks1);
%     HeartRate = 60 * samplingrate/((Rpeaks(lead,length(Rpeaks1))-Rpeaks(lead,1))/length(Rpeaks1))+HeartRate
    
	Rpeaks(lead,[1:1:length(Rpeaks1)]) = Rpeaks1 ;
% 	Rpeaks(lead,[1:length(Rpeaks1)]) = Rpeaks1
%     disp(strcat(num2str(lead), '____',num2str(length(Rpeaks(lead,:)))));
    
    halfRR(lead,1) = 1;
    for i=1:1:(length(Rpeaks1)-1)
        halfRR(lead,i+1) = Rpeaks1(i) + round((Rpeaks1(i+1)-Rpeaks1(i))/2);
    end
    halfRR(lead,length(Rpeaks1)+1) = 10000;
    
end

HeartRate = 60 * samplingrate/((Rpeaks(12,length(Rpeaks1))-Rpeaks(12,1))/length(Rpeaks1));
set(handles.allsignal,'visible', 'on');
set(handles.onelead,  'visible', 'on');
set(handles.idpatient,'string', strsplit(filename,'.xlsx'));
% set(handles.heartrate,'string', num2str(abs(HeartRate/12)));
set(handles.heartrate,'string', num2str(abs(HeartRate)));
if HeartRate/12 == Inf | HeartRate/12 == NaN
    msgbox('Try with another ECG signal','SIGNAL IS TOO BAD','error');
end

set(handles.opendiagnostic, 'visible', 'on');
set(handles.dianostictitle, 'visible', 'off');
set(handles.diagnosismenu, 'visible', 'off');
set(handles.rae, 'string', 'N/A');
set(handles.lae, 'string', 'N/A');
set(handles.rvh, 'string', 'N/A');
set(handles.lvh, 'string', 'N/A');
set(handles.cad1, 'string', 'N/A');
set(handles.cad2, 'string', 'N/A');
set(handles.cad3, 'string', 'N/A');
set(handles.cad4, 'string', 'N/A');
set(handles.cad5, 'string', 'N/A');


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in seeallsignal.
function seeallsignal_Callback(hObject, eventdata, handles)
% hObject    handle to seeallsignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of seeallsignal
    


% --- Executes on button press in clearaxes.
function clearaxes_Callback(hObject, eventdata, handles)
% hObject    handle to clearaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for lead =1:1:12
    switch lead
        case 1
            axes(handles.d1);
        case 2
            axes(handles.d2);
        case 3
            axes(handles.d3);
        case 4
            axes(handles.aVR);
        case 5
            axes(handles.aVL);
        case 6
            axes(handles.aVF);
        case 7
            axes(handles.V1);
        case 8
            axes(handles.V2);
        case 9
            axes(handles.V3);
        case 10
            axes(handles.V4);
        case 11
            axes(handles.V5);
        case 12
            axes(handles.V6);
    end
    cla reset;
end


% --- Executes on button press in filteredsignal.
function filteredsignal_Callback(hObject, eventdata, handles)
% hObject    handle to filteredsignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecg_filtered;
global halfRR;
seeallsignal = get(handles.seeallsignal, 'value');
for lead =1:1:12
    switch lead
        case 1
            axes(handles.d1);
        case 2
            axes(handles.d2);
        case 3
            axes(handles.d3);
        case 4
            axes(handles.aVR);
        case 5
            axes(handles.aVL);
        case 6
            axes(handles.aVF);
        case 7
            axes(handles.V1);
        case 8
            axes(handles.V2);
        case 9
            axes(handles.V3);
        case 10
            axes(handles.V4);
        case 11
            axes(handles.V5);
        case 12
            axes(handles.V6);
    end
    if seeallsignal == 1
        iter = 1:1:10000;
    else
        iter = halfRR(lead,2):1:halfRR(lead,5);
    end
    cla reset;
    plot(iter, ecg_filtered(lead, iter), 'b');
    hold off
end


%	Finding all peaks and stem them in the axes
function findingpeaks_Callback(hObject, eventdata, handles)
% hObject    handle to findingpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecgdata;
global ecg_filtered;
global Rpeaks;

global Swave;
global Jpoint;

global Qwave;
global QLLeg;
global QRLeg;

global Twave;
global TLLeg;
global TRLeg;

global Pwave;
global PLLeg;
global PRLeg;

global halfRR;
global numberofpeaks;

samplingrate = 1000;
seeallsignal = get(handles.seeallsignal, 'value');

set(handles.opendiagnostic, 'visible', 'off');
set(handles.dianostictitle, 'visible', 'on');
set(handles.diagnosismenu, 'visible', 'on');

for lead = 1:1:12
    switch lead
        case 1
            axes(handles.d1);
        case 2
            axes(handles.d2);
        case 3
            axes(handles.d3);
        case 4
            axes(handles.aVR);
        case 5
            axes(handles.aVL);
        case 6
            axes(handles.aVF);
        case 7
            axes(handles.V1);
        case 8
            axes(handles.V2);
        case 9
            axes(handles.V3);
        case 10
            axes(handles.V4);
        case 11
            axes(handles.V5);
        case 12
            axes(handles.V6);
    end
    
    clear Rpeaks1 Swave1 Qwave1
%     Rpeaks1 = detectRpeaks(ecg_filtered(lead,:), samplingrate);
%     Rpeaks(lead,[1:1:length(Rpeaks1)]) = Rpeaks1 ;

    [Swave1, Jpoint1] = detectSwave(ecgdata(lead,:), ecg_filtered(lead,:), numberofpeaks, Rpeaks(lead,:), halfRR(lead,:));
    Swave(lead,[1:1:length(Swave1)]) = Swave1;
    Jpoint(lead,[1:1:length(Jpoint1)]) = Jpoint1;
    
    QRdistance = 0.08*samplingrate; % binh thuong la 0.04*samplingrate
    [Qwave1, QLLeg1, QRLeg1] = detectQwave(ecgdata(lead,:), ecg_filtered(lead,:), numberofpeaks(lead), Rpeaks(lead,:), Swave1, QRdistance);
    Qwave(lead,[1:1:length(Qwave1)]) = Qwave1;
    QLLeg(lead,[1:1:length(QLLeg1)]) = QLLeg1;
    QRLeg(lead,[1:1:length(QRLeg1)]) = QRLeg1;
    
    [Pwave1, PLLeg1, PRLeg1] = detectPwave(ecgdata(lead,:), numberofpeaks(lead), halfRR(lead,:), Qwave(lead,:));
    Pwave(lead,[1:1:length(Pwave1)]) = Pwave1;
    PLLeg(lead,[1:1:length(PLLeg1)]) = PLLeg1;
    PRLeg(lead,[1:1:length(PRLeg1)]) = PRLeg1;
    
    [Twave1, TLLeg1, TRLeg1] = detectTwave(ecgdata(lead,:), Jpoint(lead,:), numberofpeaks(lead), halfRR(lead,:), Rpeaks(lead,:));
    Twave(lead,[1:1:length(Twave1)]) = Twave1;
    TLLeg(lead,[1:1:length(TLLeg1)]) = TLLeg1;
    TRLeg(lead,[1:1:length(TRLeg1)]) = TRLeg1;
    
    %msgText = getReport(exception);
    
    if seeallsignal == 1
        iter = 1:1:10000;
        iter2 = 1:1:numberofpeaks(lead);
    else
        iter = halfRR(lead,2):1:halfRR(lead,5);
        iter2 = 2:1:4;
    end
    cla reset;
    plot(iter, ecgdata(lead,iter), 'g');
    hold on
    
    %   PLOT R PEAKS
    stem(Rpeaks(lead,iter2),ecgdata(lead,(Rpeaks(lead,iter2))), ':k'); % Ve dinh R
    hold on
    
    %   PLOT S WAVES
    stem(Swave(lead,iter2),ecgdata(lead,(Swave(lead,iter2))), ':r'); % Ve dinh S
    hold on
    
    %   PLOT Q WAVES
    stem(Qwave(lead,iter2),ecgdata(lead,(Qwave(lead,iter2))), ':magenta'); % Ve dinh Q
    hold on
    stem(QLLeg1(iter2),ecgdata(lead,QLLeg1(iter2)), ':*'); % Ve chan trai Q
    hold on
    stem(QRLeg1(iter2),ecgdata(lead,QRLeg1(iter2)), ':*'); % Ve chan trai Q
    hold on
    
    %   PLOT P WAVES
    stem(Pwave(lead,iter2),ecgdata(lead,(Pwave(lead,iter2))), ':d'); % Ve dinh P
    hold on
    stem(PLLeg(lead,iter2),ecgdata(lead,(PLLeg(lead,iter2))), ':*'); % Ve chan trai P
    hold on
    stem(PRLeg(lead,iter2),ecgdata(lead,(PRLeg(lead,iter2))), ':*', 'r'); % Ve chan phai P
    hold on
    
    %   PLOT T WAVES
    stem(Twave(lead,iter2),ecgdata(lead,(Twave(lead,iter2))), ':p', 'r'); % Ve dinh T
    hold on
    stem(TLLeg(lead,iter2),ecgdata(lead,(TLLeg(lead,iter2))), ':*'); % Ve chan trai T
    hold on
    stem(TRLeg(lead,iter2),ecgdata(lead,(TRLeg(lead,iter2))), ':*', 'r'); % Ve chan phai T

    
    hold off
end

set(handles.opendiagnostic, 'visible', 'off');
set(handles.dianostictitle, 'visible', 'on');
set(handles.diagnosismenu, 'visible', 'on');


% --- Executes on button press in filteredoriginal.
function filteredoriginal_Callback(hObject, eventdata, handles)
% hObject    handle to filteredoriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecgdata;
global ecg_filtered;
global halfRR;
seeallsignal = get(handles.seeallsignal, 'value');
for lead =1:1:12
    switch lead
        case 1
            axes(handles.d1);
        case 2
            axes(handles.d2);
        case 3
            axes(handles.d3);
        case 4
            axes(handles.aVR);
        case 5
            axes(handles.aVL);
        case 6
            axes(handles.aVF);
        case 7
            axes(handles.V1);
        case 8
            axes(handles.V2);
        case 9
            axes(handles.V3);
        case 10
            axes(handles.V4);
        case 11
            axes(handles.V5);
        case 12
            axes(handles.V6);
    end
    cla reset;
    if seeallsignal == 1
        iter = 1:1:10000;
    else
        iter = halfRR(lead,2):1:halfRR(lead,5);
    end
    plot(iter, ecgdata(lead, iter), 'g');
    hold on
    plot(iter, ecg_filtered(lead, iter), 'b');
    hold off
end


%	Starting diagnosis
function diagnosismenu_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosismenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diagnosismenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diagnosismenu

global ecgdata;
global Rpeaks;
global Qwave;
global QLLeg;
global QRLeg;
global Swave;
global Jpoint;
global Twave;
global TLLeg;
global TRLeg;
global halfRR;
global PLLeg;
global PRLeg;
global Pwave;

%   Initial global variable for menu = 1 (NHOI MAU TRUOC VA BEN)
global BLRRQduration; BLRRQduration = 0;
global BLRRQamplitude; BLRRQamplitude = 0;
global BLRRQS_Shape; BLRRQS_Shape = 0;
global NBLQduration; NBLQduration = 0;
global NBLQS_Shape; NBLQS_Shape = 0;
global CTBLQamplitude; CTBLQamplitude = 0;
global CTBLQS_Shape; CTBLQS_Shape = 0;
%   Initial global variable for menu = 2 (NHOI MAU SAU VA DUOI)
global BLRRQdurationCAD_Poterior; BLRRQdurationCAD_Poterior = 0;
global NBLQdurationCAD_Poterior; NBLQdurationCAD_Poterior = 0;
global NBLQamplitudeCAD_Poterior; NBLQamplitudeCAD_Poterior = 0;
%   Initial global variable for menu = 3 (DOAN ST CHENH XUONG)
global BLRRSTsegmentConcave; BLRRSTsegmentConcave = 0;
global NBLSTsegmentConcave; NBLSTsegmentConcave = 0;
global CTBLSTsegmentConcave; CTBLSTsegmentConcave = 0;
%   Initial global variable for menu = 4 (DOAN ST CHENH LEN)
global BLRRSTsegmentConvex; BLRRSTsegmentConvex = 0;
%   Initial global variable for menu = 5 (SONG T BENH LY)
global BLRRTwavePathology; BLRRTwavePathology = 0;
global CTBLTwavePathology; CTBLTwavePathology = 0;

menu = get(handles.diagnosismenu, 'value')-1;
    
%  CAD_AlMI - NHOI MAU TRUOC VA BEN [CAD_AnteriorLateralMI]
if menu == 1
    for lead = 1:1:12
        switch lead
            case 1
                axes(handles.d1);
            case 2
                axes(handles.d2);
            case 5
                axes(handles.aVL);
            case 7
                axes(handles.V1);
            case 8
                axes(handles.V2);
            case 9
                axes(handles.V3);
            case 10
                axes(handles.V4);
            case 11
                axes(handles.V5);
            case 12
                axes(handles.V6);
        end
        
        if lead ~= 3 & lead ~= 4 & lead ~= 6
            iter = halfRR(lead,3):1:halfRR(lead,4);
            iterQ = QLLeg(lead,3):1:QRLeg(lead,3);
            iterRS = QRLeg(lead,3):1:Jpoint(lead,3);

            plot(iter, ecgdata(lead, iter), 'g');
            grid on
            hold on
            plot(iterQ, ecgdata(lead, iterQ), 'r');
            hold on
            plot(iterRS, ecgdata(lead, iterRS), 'b');
            xlim([halfRR(lead,3) halfRR(lead,4)]);
            hold off
    %         end

            R_high = ecgdata(lead, Rpeaks(lead, 3));
            R_amplitude = ecgdata(lead, Rpeaks(lead, 3))-ecgdata(lead, QLLeg(lead, 3));
            Q_high = ecgdata(lead, Qwave(lead, 3));
            Q_duration = QRLeg(lead, 3) - QLLeg(lead, 3);
            Q_amplitude = ecgdata(lead, Qwave(lead, 3)) - ecgdata(lead, QLLeg(lead, 3));
            DiagnosisCAD_AnteriorLateralMI(lead, R_high, R_amplitude, Q_high, Q_duration, Q_amplitude);
%             disp(strcat('BLRRQduration = ' ,num2str(BLRRQduration)));
        end
        
    end
    figure('Name','CAD - Nhoi mau truoc va ben','NumberTitle','off')
    text(0.2, 0.9, strcat('\bf BLRRQduration = ' ,num2str(BLRRQduration)));
    text(0.2, 0.8, strcat('\bf BLRRQamplitude = ' ,num2str(BLRRQamplitude)));
    text(0.2, 0.7, strcat('\bf BLRRQS_Shape = ' ,num2str(BLRRQS_Shape)));
    
    text(0.2, 0.55, strcat('\bf NBLQduration = ' ,num2str(NBLQduration)));
    text(0.2, 0.45, strcat('\bf NBLQS_Shape = ' ,num2str(NBLQS_Shape)));
    
    text(0.2, 0.3, strcat('\bf CTBLQduration = ' ,num2str(CTBLQamplitude)));
    text(0.2, 0.2, strcat('\bf CTBLQS_Shape = ' ,num2str(CTBLQS_Shape)));
    
%     disp(strcat('BLRRQduration = ' ,BLRRQduration));
%     disp(strcat('BLRRQamplitude = ' ,BLRRQamplitude));
%     hoho = QS_Shape
    if (numel(BLRRQduration) > 1 | numel(BLRRQamplitude) > 1 | numel(BLRRQS_Shape) >= 5)
        set(handles.cad1, 'string', 'Co Benh');
    elseif numel(NBLQduration) > 1 | numel(NBLQS_Shape) == 4
        set(handles.cad1, 'string', 'Nghi Ngo Benh');
    elseif numel(CTBLQamplitude) > 1 | numel(CTBLQS_Shape) == 3
        set(handles.cad1, 'string', 'Co The Benh');
    else
        set(handles.cad1, 'string', 'Khong Bi Benh');
    end
end

%   CAD_PiMI - NHOI MAU SAU VA DUOI [CAD_PosteriorInferiorMI]
if menu == 2
    for lead = 3:3:6
        switch lead
            case 3
                axes(handles.d3);
            case 6
                axes(handles.aVF);
        end
        
        if lead == 3 | lead == 6
            iter = halfRR(lead,3):1:halfRR(lead,4);
            iterQ = QLLeg(lead,3):1:QRLeg(lead,3);

            plot(iter, ecgdata(lead, iter), 'g');
            grid on
            hold on
            plot(iterQ, ecgdata(lead, iterQ), 'r');
            xlim([halfRR(lead,3) halfRR(lead,4)]);
            hold off
            
            Q_duration = QRLeg(lead, 3) - QLLeg(lead, 3);
            Q_amplitude = ecgdata(lead, Qwave(lead, 3)) - ecgdata(lead, QLLeg(lead, 3));
            DiagnosisCAD_PosteriorInferiorMI(lead, Q_duration, Q_amplitude);
        end
    end
    
    figure('Name','CAD - Nhoi mau sau va duoi','NumberTitle','off')
    text(0.2, 0.9, strcat('\bf BLRRQdurationCAD_Poterior = ' ,num2str(BLRRQdurationCAD_Poterior)));
    text(0.2, 0.6, strcat('\bf NBLQdurationCAD_Poterior = ' ,num2str(NBLQdurationCAD_Poterior)));
    text(0.2, 0.5, strcat('\bf NBLQamplitudeCAD_Poterior = ' ,num2str(NBLQamplitudeCAD_Poterior)));
    
    if numel(BLRRQdurationCAD_Poterior) > 1
        set(handles.cad2, 'string', 'Co Benh');
    elseif numel(NBLQdurationCAD_Poterior) > 1 | numel(NBLQamplitudeCAD_Poterior) > 1
        set(handles.cad2, 'string', 'Nghi Ngo Benh');
    else
        set(handles.cad2, 'string', 'Khong Bi Benh');
    end
end

%   CAD_STegmentWereConcave - DOAN ST CHENH XUONG
if menu == 3
    for lead = 1:1:12
        switch lead
            case 1
                axes(handles.d1);
            case 2
                axes(handles.d2);
            case 3
                axes(handles.d3);
            case 4
                axes(handles.aVR);
            case 5
                axes(handles.aVL);
            case 6
                axes(handles.aVF);
            case 7
                axes(handles.V1);
            case 8
                axes(handles.V2);
            case 9
                axes(handles.V3);
            case 10
                axes(handles.V4);
            case 11
                axes(handles.V5);
            case 12
                axes(handles.V6);
        end
        
        iter = halfRR(lead,3):1:halfRR(lead,4);
        
        plot(iter, ecgdata(lead, iter), 'g');
        grid on
        hold on
        plot([Jpoint(lead,3):TLLeg(lead,3)], ecgdata(lead, [Jpoint(lead,3):TLLeg(lead,3)]), 'r');
        hold on
        plot([TLLeg(lead,3):TRLeg(lead,3)], ecgdata(lead, [TLLeg(lead,3):TRLeg(lead,3)]), 'b');
        hold on
        stem(Twave(lead,3),ecgdata(lead,Twave(lead,3)), ':r');
        hold on
        plot([Jpoint(lead,3):1:halfRR(lead,4)], ecgdata(lead,Jpoint(lead,3)), 'k');
        xlim([halfRR(lead,3) halfRR(lead,4)]);
        hold off
        
        DiagnosisCAD_STsegmentConcave(lead, ecgdata(lead,:), Jpoint(lead,3), TLLeg(lead,3));
    end
    
    if numel(BLRRSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Co Benh');
    elseif numel(NBLSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Nghi Ngo benh');
    elseif numel(CTBLSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Co The Bi Benh');
    else
        set(handles.cad3, 'string', 'Khong Bi Benh');
    end
    
    figure('Name','CAD_STegmentWereConcave - DOAN ST CHENH XUONG','NumberTitle','off')
    text(0.2, 0.9, strcat('\bf BLRRSTsegmentConcave = ' ,num2str(BLRRSTsegmentConcave)));
    text(0.2, 0.6, strcat('\bf NBLSTsegmentConcave = ' ,num2str(NBLSTsegmentConcave)));
    text(0.2, 0.3, strcat('\bf CTBLSTsegmentConcave = ' ,num2str(CTBLSTsegmentConcave)));
end

%   CAD1 - Doan ST chenh len (convex ST)
if menu == 4
    for lead = 1:1:12
        switch lead
            case 1
                axes(handles.d1);
            case 2
                axes(handles.d2);
            case 3
                axes(handles.d3);
            case 4
                axes(handles.aVR);
            case 5
                axes(handles.aVL);
            case 6
                axes(handles.aVF);
            case 7
                axes(handles.V1);
            case 8
                axes(handles.V2);
            case 9
                axes(handles.V3);
            case 10
                axes(handles.V4);
            case 11
                axes(handles.V5);
            case 12
                axes(handles.V6);
        end
        
        iter = halfRR(lead,3):1:halfRR(lead,4);
        
        plot(iter, ecgdata(lead, iter), 'g');
        grid on
        hold on
        plot([Jpoint(lead,3):TLLeg(lead,3)], ecgdata(lead, [Jpoint(lead,3):TLLeg(lead,3)]), 'r');
        hold on
        plot([TLLeg(lead,3):TRLeg(lead,3)], ecgdata(lead, [TLLeg(lead,3):TRLeg(lead,3)]), 'b');
        hold on
        stem(Twave(lead,3),ecgdata(lead,Twave(lead,3)), ':r');
        hold on
        plot([Jpoint(lead,3):1:halfRR(lead,4)], ecgdata(lead,Jpoint(lead,3)), 'k');
        xlim([halfRR(lead,3) halfRR(lead,4)]);
        hold off
        
        DiagnosisCAD_STsegmentConvex(lead, ecgdata(lead,:), Jpoint(lead,3), TLLeg(lead,3));
    end
    
    if numel(BLRRSTsegmentConvex) > 1
        set(handles.cad4, 'string', 'Co Benh');
    else
        set(handles.cad4, 'string', 'Khong Bi Benh');
    end
    
    figure('Name','CAD - Doan ST chenh len (convex ST)','NumberTitle','off')
    text(0.2, 0.9, strcat('\bf BLRRSTsegmentConvex = ' ,num2str(BLRRSTsegmentConvex)));
end

%   CAD1 - Song T
if menu == 5
    for lead = 1:1:12
        switch lead
            case 1
                axes(handles.d1);
            case 2
                axes(handles.d2);
            case 3
                axes(handles.d3);
            case 4
                axes(handles.aVR);
            case 5
                axes(handles.aVL);
            case 6
                axes(handles.aVF);
            case 7
                axes(handles.V1);
            case 8
                axes(handles.V2);
            case 9
                axes(handles.V3);
            case 10
                axes(handles.V4);
            case 11
                axes(handles.V5);
            case 12
                axes(handles.V6);
        end
        
        iter = halfRR(lead,3):1:halfRR(lead,4);
        plot(iter, ecgdata(lead, iter), 'g');
        grid on
        hold on
        plot([TLLeg(lead,3):TRLeg(lead,3)], ecgdata(lead, [TLLeg(lead,3):TRLeg(lead,3)]), 'r');
        hold on
        stem(Twave(lead,3),ecgdata(lead,Twave(lead,3)), ':p');
        xlim([halfRR(lead,3) halfRR(lead,4)]);
        hold off
        
        DiagnosisCAD_TwavesPathology(lead, ecgdata(lead,:), Twave(lead,3), TLLeg(lead,3), TRLeg(lead,3));
    end
    
    if numel(BLRRTwavePathology) > 1
        set(handles.cad5, 'string', 'Co Benh');
    elseif numel(CTBLTwavePathology) > 1
        set(handles.cad5, 'string', 'Co The Bi Benh');
    else
        set(handles.cad5, 'string', 'Khong Bi Benh');
    end
    
    figure('Name','CAD - Song T benh Ly','NumberTitle','off')
    text(0.2, 0.9, strcat('\bf BLRRTwavePathology = ' ,num2str(BLRRTwavePathology)));
    text(0.2, 0.5, strcat('\bf CTBLTwavePathology = ' ,num2str(CTBLTwavePathology)));
end

%   All DISEASE
if menu == 6
    %  CAD_AlMI - NHOI MAU TRUOC VA BEN [CAD_AnteriorLateralMI]
%     global BLRRQduration; BLRRQduration = 0;
%     global BLRRQamplitude; BLRRQamplitude = 0;
%     global BLRRQS_Shape; BLRRQS_Shape = 0;
%     
%     global NBLQduration; NBLQduration = 0;
%     global NBLQS_Shape; NBLQS_Shape = 0;
%     
%     global CTBLQamplitude; CTBLQamplitude = 0;
%     global CTBLQS_Shape; CTBLQS_Shape = 0;
    
    for lead = 1:1:12
        if lead ~= 3 & lead ~= 4 & lead ~= 6
            R_high = ecgdata(lead, Rpeaks(lead, 3));
            R_amplitude = ecgdata(lead, Rpeaks(lead, 3))-ecgdata(lead, QLLeg(lead, 3));
            Q_high = ecgdata(lead, Qwave(lead, 3));
            Q_duration = QRLeg(lead, 3) - QLLeg(lead, 3);
            Q_amplitude = ecgdata(lead, Qwave(lead, 3)) - ecgdata(lead, QLLeg(lead, 3));
            DiagnosisCAD_AnteriorLateralMI(lead, R_high, R_amplitude, Q_high, Q_duration, Q_amplitude);
%             disp(strcat('BLRRQduration = ' ,num2str(BLRRQduration)));
        end
    end
    if (numel(BLRRQduration) > 1 | numel(BLRRQamplitude) > 1 | numel(BLRRQS_Shape) >= 5)
        set(handles.cad1, 'string', 'Co Benh');
    elseif numel(NBLQduration) > 1 | numel(NBLQS_Shape) == 4
        set(handles.cad1, 'string', 'Nghi Ngo Benh');
    elseif numel(CTBLQamplitude) > 1 | numel(CTBLQS_Shape) == 3
        set(handles.cad1, 'string', 'Co The Benh');
    else
        set(handles.cad1, 'string', 'Khong Bi Benh');
    end
    %   CAD_PiMI - NHOI MAU SAU VA DUOI [CAD_PosteriorInferiorMI]
%     global BLRRQdurationCAD_Poterior; BLRRQdurationCAD_Poterior = 0;
%     
%     global NBLQdurationCAD_Poterior; NBLQdurationCAD_Poterior = 0;
%     global NBLQamplitudeCAD_Poterior; NBLQamplitudeCAD_Poterior = 0;
    for lead = 3:3:6
        if lead == 3 | lead == 6
            Q_duration = QRLeg(lead, 3) - QLLeg(lead, 3);
            Q_amplitude = ecgdata(lead, Qwave(lead, 3)) - ecgdata(lead, QLLeg(lead, 3));
            DiagnosisCAD_PosteriorInferiorMI(lead, Q_duration, Q_amplitude);
        end
    end
    if numel(BLRRQdurationCAD_Poterior) > 1
        set(handles.cad2, 'string', 'Co Benh');
    elseif numel(NBLQdurationCAD_Poterior) > 1 | numel(NBLQamplitudeCAD_Poterior) > 1
        set(handles.cad2, 'string', 'Nghi Ngo Benh');
    else
        set(handles.cad2, 'string', 'Khong Bi Benh');
    end
    %   CAD_STegmentWereConcave - DOAN ST CHENH XUONG
%     global BLRRSTsegmentConcave; BLRRSTsegmentConcave = 0;
%     global NBLSTsegmentConcave; NBLSTsegmentConcave = 0;
%     global CTBLSTsegmentConcave; CTBLSTsegmentConcave = 0;
    for lead = 1:1:12
        DiagnosisCAD_STsegmentConcave(lead, ecgdata(lead,:), Jpoint(lead,3), TLLeg(lead,3));
    end
    if numel(BLRRSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Co Benh');
    elseif numel(NBLSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Nghi Ngo benh');
    elseif numel(CTBLSTsegmentConcave) > 1
        set(handles.cad3, 'string', 'Co The Bi Benh');
    else
        set(handles.cad3, 'string', 'Khong Bi Benh');
    end
    %   CAD1 - Doan ST chenh len (convex ST)
%     global BLRRSTsegmentConvex; BLRRSTsegmentConvex = 0;
    for lead = 1:1:12
        DiagnosisCAD_STsegmentConvex(lead, ecgdata(lead,:), Jpoint(lead,3), TLLeg(lead,3));
    end
    if numel(BLRRSTsegmentConvex) > 1
        set(handles.cad4, 'string', 'Co Benh');
    else
        set(handles.cad4, 'string', 'Khong Bi Benh');
    end
    %   CAD1 - Song T
%     global BLRRTwavePathology; BLRRTwavePathology = 0;
%     global CTBLTwavePathology; CTBLTwavePathology = 0;
    for lead = 1:1:12
        DiagnosisCAD_TwavesPathology(lead, ecgdata(lead,:), Twave(lead,3), TLLeg(lead,3), TRLeg(lead,3));
    end
    if numel(BLRRTwavePathology) > 1
        set(handles.cad5, 'string', 'Co Benh');
    elseif numel(CTBLTwavePathology) > 1
        set(handles.cad5, 'string', 'Co The Bi Benh');
    else
        set(handles.cad5, 'string', 'Khong Bi Benh');
    end
end

% --- Executes during object creation, after setting all properties.
function diagnosismenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagnosismenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in originalsignal.
function originalsignal_Callback(hObject, eventdata, handles)
% hObject    handle to originalsignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecgdata;
global halfRR;
seeallsignal = get(handles.seeallsignal, 'value');
for lead =1:1:12
    switch lead
        case 1
            axes(handles.d1);
        case 2
            axes(handles.d2);
        case 3
            axes(handles.d3);
        case 4
            axes(handles.aVR);
        case 5
            axes(handles.aVL);
        case 6
            axes(handles.aVF);
        case 7
            axes(handles.V1);
        case 8
            axes(handles.V2);
        case 9
            axes(handles.V3);
        case 10
            axes(handles.V4);
        case 11
            axes(handles.V5);
        case 12
            axes(handles.V6);
    end
    cla reset;
    if seeallsignal == 1
        iter = 1:1:10000;
    else
        iter = halfRR(lead,2):1:halfRR(lead,5);
    end
    plot(iter, ecgdata(lead, iter), 'g');
    hold off
end


% --- Executes during object creation, after setting all properties.
function allsignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to allsignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in plotwithpeaks.
function plotwithpeaks_Callback(hObject, eventdata, handles)
% hObject    handle to plotwithpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotwithpeaks


%	Draw only one lead or all lead in figure (not in axes)
function chooselead_Callback(hObject, eventdata, handles)
% hObject    handle to chooselead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooselead contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooselead
global ecgdata;
global ecg_filtered;
global halfRR;
global Rpeaks;
global Twave;
global Jpoint;
global numberofpeaks;
chooselead = get(handles.chooselead, 'value')-1;
plotwithpeaks = get(handles.plotwithpeaks, 'value');
plotwithfiltered = get(handles.plotwithfiltered, 'value');

%   Draw all lead
if chooselead == 13
    for lead=1:1:12
        
        if numberofpeaks(lead) > 4    %   if finding more than 4 Rpeaks
            iter = halfRR(lead, 2):1:halfRR(lead, 5);
            iter2 = 2:1:4;
        else
            iter = 1:1:10000;
            if numberofpeaks(lead) == 0
                iter2 = 0;
            else
            iter2 = 1:1:numberofpeaks(lead);
            end
        end
        
        
        ECG_FreqTrans=fft(ecgdata(lead,:));
        ECG_FreqTrans(1 : round(length(ECG_FreqTrans)*5/1000))=0; %HPF
        ECG_FreqTrans((end - round(length(ECG_FreqTrans)*5/1000)) : end)=0; %LPF
        %   Back to the Time Domain
        filtered=real(ifft(ECG_FreqTrans));
        
        winsize = round(0.5*(Rpeaks(lead, 4)-Rpeaks(lead,3))-100)
        timmax = ecgdemowinmax(ecgdata(lead, :), winsize);   %   Draw all peaks after R
        maxindex = find(timmax);
        
        minindex = minwindowfilter(ecgdata(lead, :), winsize);   %   Draw all peaks after R
        
        [Twave1, TLLeg1, TRLeg1] = detectTwave(ecgdata(lead,:), Jpoint(lead,:), numberofpeaks(lead), halfRR(lead,:), Rpeaks(lead,:))
        
        figure(lead);
        switch lead
            case 1
                set(lead, 'Name', 'DI');
            case 2
                set(lead, 'Name', 'DII');
            case 3
                set(lead, 'Name', 'DIII');
            case 4
                set(lead, 'Name', 'aVR');
            case 5
                set(lead, 'Name', 'aVL');
            case 6
                set(lead, 'Name', 'aVF');
            case 7
                set(lead, 'Name', 'V1');
            case 8
                set(lead, 'Name', 'V2');
            case 9
                set(lead, 'Name', 'V3');
            case 10
                set(lead, 'Name', 'V4');
            case 11
                set(lead, 'Name', 'V5');
            case 12
                set(lead, 'Name', 'V6');
        end
        
%         plot(iter, ecgdata(lead, iter), 'g');
        plot([1:10000], ecgdata(lead, [1:10000]), 'g');
        hold on
        plot([1:10000], filtered([1:10000]), 'b');
        hold on
        stem(Twave1, ecgdata(lead, Twave1), ':*');
        text(Twave1, ecgdata(lead, Twave1),'T','color','r','Fontsize',12);
        
        stem(TLLeg1, ecgdata(lead, TLLeg1), ':p');
        stem(TRLeg1, ecgdata(lead, TRLeg1), ':p');
%         stem(maxindex([1:numel(maxindex)]), ecgdata(lead, maxindex([1:numel(maxindex)])), 'k');
%         stem(minindex([1:numel(minindex)]), ecgdata(lead, minindex([1:numel(minindex)])), 'r');
        hold on
        plot([Jpoint(lead, 3):halfRR(lead, 4)], ecgdata(lead, Jpoint(lead, 3)), 'k');
        xlim([halfRR(lead, 2) halfRR(lead, 5)]);
    end
end

if chooselead ~= 13 & chooselead > 0   %   If chosing only one lead to draw
    
if numberofpeaks(chooselead) > 4    %   if finding more than 4 Rpeaks
    iter = halfRR(chooselead, 2):1:halfRR(chooselead, 5);
    iter2 = 2:1:4;
else
    iter = 1:1:10000;
    if numberofpeaks(chooselead) == 0
        iter2 = 0;
    else
        iter2 = 1:1:numberofpeaks(chooselead);
    end
end

figure(chooselead);

% iter = halfRR(chooselead-1, 2):1:halfRR(chooselead-1, 5);
% iter2 = 2:1:4;

for lead =1:1:12
    if chooselead == lead
        plot(iter, ecgdata(chooselead, iter), 'g');
        
        %   stem all peak if tick in the plot with peaks box
        if plotwithpeaks == 1
            hold on
            stem(Rpeaks(chooselead,iter2), ecgdata(chooselead,Rpeaks(chooselead, iter2)), 'k');
        end
        
        %   plot filtered signal if tick in the plot with filtered box
        if plotwithfiltered == 1
            hold on
            plot(iter, ecg_filtered(chooselead, iter), 'b');
        end
        break;
    end
end
end     %   if chooselead > 0



% --- Executes during object creation, after setting all properties.
function chooselead_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooselead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotwithfiltered.
function plotwithfiltered_Callback(hObject, eventdata, handles)
% hObject    handle to plotwithfiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotwithfiltered


% --- Executes on button press in moreinfor.
function moreinfor_Callback(hObject, eventdata, handles)
% hObject    handle to moreinfor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('www.fet.uet.vnu.edu.vn/en/department-of-micro-electro-mechanical-systems-and-micro-systems.html');
