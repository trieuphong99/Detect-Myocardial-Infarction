%   
%   THESIS:     CORONARY ARTERY DISEASE DIAGNOSIS BASED ON AN ANALYZING WAVEFORM
%               MORPHOLOGY OF THE ELECTROCARDIOGRAM SIGNAL
%
%   Student:    Nguyen Xuan Duong
%               nguyenxuanduong0701@gmail.com
%               K58DA (2013-2017)
%               University of Engineering and Technology - VNU, Hanoi
%               Faculty of Electronics and Telecommunications
%
%              This file is a part of a package that contains a lot of files:
%
%                     1. TESTINGBenhDongMachVanh.m - main script file;
%                     2. ecgdemowinmax.m - window filter script file;
%                     3. dectecPwave.m - sub function script file;
%                     4. dectecQwave.m - sub function script file;
%                     5. dectecSwave.m - (THIS FILE) sub function script file;
%                     6. dectecTwave.m - sub function script file;
%                     7. dataECG - folder contains all ecg data sample;
%                     8. ......

%              To get the package, contact me via email:
%                     nguyenxuanduong0701@gmail.com
%
%              To run this project put all files in the package in Matlab's
%              work directory, click Run in Matlab toolbars or type in
%              Command Window "TESTINGBenhDongMachVanh" then press Enter.
%
%                     >> TESTINGBenhDongMachVanh
%
%              To test this function, load any ecg data file in dataECG
%              folder then type in Command Window:

%                     >> detectSwave(ecg, ECGinTimeDomain, length(Rpeaks)-1, Rpeaks, RSdistance);
%

function [Swave, Jpoint] = detectSwave(data, data_filtered, number_of_peaks, Rpeaks, halfRR)
    findpeaksAfterR = ecgdemowinmax(data_filtered, 101);   %   Draw all peaks after R
    peaksafterR = find(findpeaksAfterR);
    
    for i = 1:1:number_of_peaks
        for ii=i:1:length(peaksafterR)
            if peaksafterR(ii) == Rpeaks(i)
                if ii == length(peaksafterR)
                    afterR = Rpeaks(i)+round((halfRR(i+1)-Rpeaks(i))/3);
                    break;
                end
                afterR=peaksafterR(ii+1);
                break;
            end
        end
        %   if has no peak after R
        if afterR >= halfRR(i+1)
            afterR = Rpeaks(i)+round((halfRR(i+1)-Rpeaks(i))/3);
        end
        %   Initial Swave
        [USELESS, Swave(i)] = min(data([Rpeaks(i):1:afterR])); 
        Swave(i) = Swave(i) + Rpeaks(i) - 1;
        
        %   Determine J point tempotary
        if Swave(i)+70 >= 10000
        [USELESS, Jpoint(i)] = max(data_filtered([Swave(i):1:10000]));
        Jpoint(i) = Swave(i) + Jpoint(i)-1;
        else
        [USELESS, Jpoint(i)] = max(data_filtered([Swave(i):1:Swave(i)+70]));
        Jpoint(i) = Swave(i) + Jpoint(i)-1;
        end
        
        %   Swave detected in data that was Filter
        [USELESS, Swave_filter(i)] = min(data_filtered([Rpeaks(i):1:Jpoint(i)]));
        Swave_filter(i) = Swave_filter(i) + Rpeaks(i) - 1;
        
        %   CORRECTED Swave and Jpoint
        if Swave(i) > Swave_filter(i)+2
            [USELESS, tmp] = max(data([Swave(i):1:Jpoint(i)]));
            Jpoint(i) = Swave(i)+tmp-1;
            
            Swave(i) = Swave_filter(i);
        end
        if abs(Swave_filter(i)-Swave(i)) <= 2   %   Swave(i) == Swave_filter(i) 
            [USELESS, tmp] = max(data([Swave(i):1:Jpoint(i)]));
            Jpoint(i) = Swave(i)+tmp-1;
        end
        if Swave(i) < Swave_filter(i)-2
            Swave(i) = Swave_filter(i);
            [USELESS, Jpoint(i)] = max(data_filtered([Swave(i):1:Swave(i)+70]));
            Jpoint(i) = Swave(i) + Jpoint(i)-1;
        end
    end
    if numel(Swave) < number_of_peaks
        Swave(number_of_peaks) = Rpeaks(number_of_peaks);    %   Them de ve
    end
end

%   RSdistance is the interval in that we determine minimum value => Swave

% %% DETECT S WAVE
%     % song S la song sau nhat cua phuc bo QRS, thoi gian QRS < 0.1s
%     % Doan QR tam 0.04s do do chon 1 cua so khoang rong 0.06 tinh tu song R
%     % sau do tim min cua cua so do, ket qua thu dc chinh la song S.
%     % Song S la song am, dung sau song R
% % Detect S wave ends here