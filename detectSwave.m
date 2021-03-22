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
