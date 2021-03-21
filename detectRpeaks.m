function Rpeaks = detectRpeaks(ecg_filtered, samplingrate)    
    
    %   Filter - first pass
    WindowSize = floor(samplingrate * 285 / 1000);
    AllRpeaks=ecgdemowinmax(ecg_filtered, WindowSize);
%     checkT = ecgdemowinmax(ecg_filtered, 101);   %   Draw all peaks after R
%     indexcheckT = find(checkT);
%     
%     checkpeak = ecgdemowinmax(data, 251);   %   Draw all peaks after R
%     indexcheckpeak = find(checkpeak);
%     
%     mincheck = minwindowfilter(data, 251);
    
    %   Scale ecg
    PeaksScaling=AllRpeaks/(max(AllRpeaks)/7);    %scale cac dinh thanh tung gtri voi 7 khoang
    check = PeaksScaling;
    %   Filter by threshold filter
    for i = 1:1:length(PeaksScaling)
        if PeaksScaling(i) < 4
            PeaksScaling(i) = 0;
        else
            PeaksScaling(i)=1;
        end
    end
    Rpeaks_tmp = find(PeaksScaling);
%
    %   Returns minimum distance between two peaks to redetect R peaks
    if length(Rpeaks_tmp) < 2
        %   If detected only 1 R peak or not detected R peak
        distance = 650;
    else
        %   If detected more than 1 R peak
        distance=Rpeaks_tmp(2)-Rpeaks_tmp(1);
        for i=1:1:length(Rpeaks_tmp)-1
            if Rpeaks_tmp(i+1)-Rpeaks_tmp(i)<distance 
                distance=Rpeaks_tmp(i+1)-Rpeaks_tmp(i);
            end
        end
    end
%
    % Optimize filter window size
    QRdistance=floor(0.04*samplingrate);
    if rem(QRdistance,2)==0
        QRdistance=QRdistance+1;
    end
    WindowSize=2*distance-QRdistance;
    
    % Filter - second pass
    AllRpeaks2 = ecgdemowinmax(ecg_filtered, WindowSize);
    PeaksScaling2=AllRpeaks2/(max(AllRpeaks2)/7);
    for i=1:1:length(PeaksScaling2)
        if PeaksScaling2(i)<4
            PeaksScaling2(i)=0;
        else
            PeaksScaling2(i)=1;
        end
    end
    Rpeaks = find(PeaksScaling2);
end