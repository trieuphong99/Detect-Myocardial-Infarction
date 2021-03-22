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

    
    
    
    
    
    
    
    
    
    
    





