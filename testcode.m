% clc;
% [filename,path] = uigetfile('.xlsx');
% ecgdata = xlsread(strcat(path,filename));
% ecgdata = ecgdata';     %   transpose a row into a column
% ecgdata(1,:) = [];
% samplingrate = 1000;
% lead = 1;
% for lead =1:1:12
%     %   Remove lower frequencies
%     ECG_FreqTrans(lead,:)=fft(ecgdata(lead,:));
%     ECG_FreqTrans(lead,1 : round(length(ECG_FreqTrans)*5/samplingrate))=0; %HPF
%     ECG_FreqTrans(lead,(end - round(length(ECG_FreqTrans)*5/samplingrate)) : end)=0; %LPF
%     %   Back to the Time Domain
%     ecg_filtered(lead,:)=real(ifft(ECG_FreqTrans(lead,:)));
%     
%     %   Detect R peaks
%     Rpeaks1 = detectRpeaks( ecg_filtered(lead,:), samplingrate);
%       Rpeaks1=Rpeaks(lead,:);
% end
% x = 1:1:10000;
% plot(x, ecgdata(1, x), 'g');
% hold on
% j = 1:1:length(Rpeaks(1,:))
% stem(Rpeaks(1,j), ecgdata(1,Rpeaks(1,j)), ':k');
% hold off


%%  Create a temporary folder and copy an example MATLAB script to it.
% tmp = tempname;
% mkdir(tmp);
% runtmp = fullfile(tmp,'ahihi.txt');
% demodir = fullfile(matlabroot,'toolbox','matlab','demos','buckydem.m');
% copyfile(demodir,runtmp);

clc;
% system('start chrome.exe Information\LAE_LeftAtrialEnlargement.mat');
% abc = fileread('Information\chd.txt');
% abc = importdata('Information\chd.txt');
ab = 'say oh yeah! sky oi';
copyfile 'Information\LAE_LeftAtrialEnlargement.mat' 'ahihi.txt'
fileID = fopen('ahihi.txt','at');
fprintf(fileID,'\n%s', ab);
fclose(fileID);
% dlmwrite('ahihi.txt',strcat('\n ',ab),'delimiter', '', '-append');
% abc = importdata('Information\chd.txt');
pause(1)
winopen('ahihi.txt')
pause(1)
delete('ahihi.txt')

% load D:\Prof_Trinh_Searching\SourceCode_DetectAllPeaksECG\GUI\GUI_BanCopySauBaoCaoNCKH\Information\LAE_LeftAtrialEnlargement.mat




