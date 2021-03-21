%%@EXAMPLE: [Pwave, flag] = detectPwave(ecg, corrected, length(positions2)-1, nuakhoangRR, Qwave, background_line);

function [Pwave, PLLeg, PRLeg] = detectPwave(data, number_of_peaks, halfRR, Qwave)

    samplingrate = 1000;
    %   Remove lower frequencies
    ECG_FreqTrans = fft(data);
    ECG_FreqTrans(1 : round(length(ECG_FreqTrans)*5/samplingrate))=0; %hpf
    ECG_FreqTrans((end - round(length(ECG_FreqTrans)*5/samplingrate)) : end)=0;   %lpf
    ecg_filtered = real(ifft(ECG_FreqTrans));
    
    for i=2:1:number_of_peaks-1
        %   Finding max and min of data in Time Domain
        [maxPwave, Pmax_index(i)] = max(ecg_filtered([halfRR(i)+80:1:Qwave(i)-30]));    %80
        Pmax_index(i) = halfRR(i)+80+Pmax_index(i)-1;
        
        [minPwave, Pmin_index(i)] = min(ecg_filtered([halfRR(i)+80:1:Qwave(i)-30]));
        Pmin_index(i) = halfRR(i)+Pmin_index(i)-1+80;
        
        
        %   Finding max and min of original data
        [maxPwave, Pmax_index2(i)] = max(data([halfRR(i)+80:1:Qwave(i)-30]));
        Pmax_index2(i) = halfRR(i)+Pmax_index2(i)-1+80;
        
        [minPwave, Pmin_index2(i)] = min(data([halfRR(i)+80:1:Qwave(i)-30]));
        Pmin_index2(i) = halfRR(i)+Pmin_index2(i)-1+80;
    end
    
    for i=2:1:number_of_peaks-1
        %   In general, default that P are the max waves
        Pwave(i) = Pmax_index2(i);
        [USELESS, PRLeg(i)] = min(ecg_filtered([Pwave(i)+1:1:Pwave(i)+100]));
        PRLeg(i) = Pwave(i)+PRLeg(i)-1+1;
            
        [USELESS, PLLeg(i)] = min(ecg_filtered([Pwave(i)-100:1:Pwave(i)-1]));
        PLLeg(i) = Pwave(i)+PLLeg(i)-1-100;
        %   If P is the max in both ECGinTimeDomain and data
        if (((Pmax_index2(i)-10) <= Pmax_index(i)) & (Pmax_index(i) <= (Pmax_index2(i)+10)))
            Pwave(i) = Pmax_index(i);
            
            [USELESS, PRLeg(i)] = min(ecg_filtered([Pwave(i)+1:1:Pwave(i)+75]));
            PRLeg(i) = Pwave(i)+PRLeg(i)-1+1;
            
            [USELESS, PLLeg(i)] = min(ecg_filtered([Pwave(i)-75:1:Pwave(i)-1]));
            PLLeg(i) = Pwave(i)+PLLeg(i)-1-75;
        else
            %   If P is the min in both ECGinTimeDomain and data
            if (Pmin_index2(i)-10 <= Pmin_index(i)) & (Pmin_index(i) <= Pmin_index2(i)+10)
                Pwave(i) = Pmin_index(i);
                
                [USELESS, PRLeg(i)] = max(ecg_filtered([Pwave(i)+1:1:Pwave(i)+75]));
                PRLeg(i) = Pwave(i)+PRLeg(i)-1+1;
                
                [USELESS, PLLeg(i)] = max(ecg_filtered([Pwave(i)-75:1:Pwave(i)-1]));
                PLLeg(i) = Pwave(i)+PLLeg(i)-1-75;
            end
        %   If P isn's max and min in both ECGinTimeDomain and data. Default it is max wave.
        end
        %   If P isn's max and min in both ECGinTimeDomain and data. Default it is max wave.
        if PRLeg(i) >= Qwave(i)
            PRLeg(i) = Pwave(i) + round((Qwave(i)-Pwave(i))/2);
        end
    end
    Pwave(1) = 100;    %   Cho them de ve
    Pwave(number_of_peaks) = Qwave(number_of_peaks)-100; %   Cho them de ve
end



% function Pwave = detectPwave(data, Qwave, nuakhoangRR)
%     WinSize = 251;
%     maxfilter = maxwindowfilter(data, WinSize);
%     minfilter = minwindowfilter(data, WinSize);
%     iter = 0;
%     for i = 2:1:length(Qwave)
%         countmax = 0;
%         countmin = 0;
%         for j = 1:1:length(maxfilter)
%             if maxfilter(j) > nuakhoangRR(i)+50 & maxfilter(j) < Qwave(i)
%                 countmax = countmax + 1;
%             end
%             if maxfilter(j) > Qwave(i)
%                 j = j - 1;
%                 break;
%             end
%         end
%         
%         for k = 1:1:length(minfilter)
%             if minfilter(k) > nuakhoangRR(i)+50 & minfilter(k) < Qwave(i)
%                 countmin = countmin + 1;
%             end
%             if minfilter(k) > Qwave(i)-25
%                 k = k - 1;
%                 break;
%             end
%         end
%         
% %         disp(strcat(num2str(i), '. Countmin = ',num2str(countmin)));
% %         disp(strcat(num2str(i), '. CountmAX = ',num2str(countmax)));
%         
%         %   If it has no max and min
%         if countmax == 0 & countmin == 0
%             Pwave(i) = 0;
%         %   If it has only 1 max
%         elseif countmax == 1 & countmin == 0
%             Pwave(i) = maxfilter(j);
%         %   If it has only 1 min
%         elseif countmax == 0 & countmin == 1
%             Pwave(i) = minfilter(k);
%         %   If it has 1 max and 1 min => peek which closer to Qwave
%         elseif countmax == 1 & countmin == 1
%             if maxfilter(j) > minfilter(k)
%                 Pwave(i) = maxfilter(j);
%             else 
%                 Pwave(i) = minfilter(k);
%             end
%         %   If it a type kind of (min)->max->min->(min(Qwave))
%         elseif minfilter(k-1) > nuakhoangRR(i) & minfilter(k) > maxfilter(j) & maxfilter(j) > minfilter(k-1)
%             Pwave(i) = maxfilter(j);
%         %   Chua nghi ra truong hop
%         else
%             %   If anyone before and closest to Qwave => choose that one
%             if maxfilter(j) > minfilter(k)
%                 Pwave(i) = maxfilter(j);
%             else
%                 Pwave(i) = minfilter(k);
%             end
%         end
%         
%         if i == 2 | i == 3 | i == 4
%             
%         end
%         
%     end
%     
%     %   Check P(2), P(3) and P(4) to synchronous P max or min
% end


    
    
    
    
    
    
    
    
    
    
    
    
    





