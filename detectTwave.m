function [Twave, TLLeg, TRLeg] = detectTwave(data, Jpoint, number_of_peaks, nuakhoangRR, Rpeaks)

    %%  For sure that there are at least a Twave in each cycle of each lead (initial step)
    for i=2:1:number_of_peaks-1
        [USELESS, Tmin(i)] = min(data([Jpoint(i):1:nuakhoangRR(i+1)-50]));
        Tmin(i) = Jpoint(i)+Tmin(i)-1;
        
        [USELESS, Tmax(i)] = max(data([Jpoint(i):1:nuakhoangRR(i+1)-50]));
        Tmax(i) = Jpoint(i)+Tmax(i)-1;
        
        if abs(data(Tmin(i))-data(Jpoint(i))) < abs(data(Tmax(i))-data(Jpoint(i)))
            Twave(i) = Tmax(i);
        else
            Twave(i) = Tmin(i);
        end
        
        TLLeg(i) = round((Jpoint(i)+Twave(i))/2);
        TRLeg(i) = round((Twave(i)+nuakhoangRR(i+1))/2);
    end
    Twave(1) = Rpeaks(1)+200;  %   Cho them de ve
    TLLeg(1) = Twave(1);
    TRLeg(1) = Twave(1);
    Twave(number_of_peaks) = Rpeaks(number_of_peaks);
    TLLeg(number_of_peaks) = Twave(number_of_peaks);
    TRLeg(number_of_peaks) = Twave(number_of_peaks);
    
    %%  Accuracy of Twave
    EcgFreqTrans=fft(data);
    EcgFreqTrans(1 : round(length(EcgFreqTrans)*5/1000))=0; %hpf
    EcgFreqTrans((end - round(length(EcgFreqTrans)*5/1000)) : end)=0;   %lpf
    ecgFiltered=real(ifft(EcgFreqTrans));
    
    winsize = round(0.5*(Rpeaks(4)-Rpeaks(3))-100)
    findMax = ecgdemowinmax(data, winsize);   %   Draw all peaks after R
    maxIndex = find(findMax);
    
    minIndex = minwindowfilter(data, winsize);   %   Draw all peaks after R
    
    for j = 2:1:number_of_peaks-1
        firstMaxAfterJpoint = maxIndex(find(maxIndex > Jpoint(j), 1, 'first'));
        firstMinAfterJpoint = minIndex(find(minIndex > Jpoint(j), 1, 'first'));
        if (firstMaxAfterJpoint < nuakhoangRR(j+1)) | (firstMinAfterJpoint < nuakhoangRR(j+1))
            subArrayFindMinMax = ecgFiltered([Jpoint(j):nuakhoangRR(j+1)]);
            if firstMaxAfterJpoint < firstMinAfterJpoint
                Twave(j) = firstMaxAfterJpoint;
                minIndex2 = minwindowfilter(subArrayFindMinMax, 101);
                minIndex2 = minIndex2 + Jpoint(j)-1;

                if max(minIndex2) <= Twave(j) | numel(minIndex2) == 0
                    TRLeg(j) = round((Twave(j)+nuakhoangRR(j+1))/2);
                else
                    TRLeg(j) = minIndex2(find(minIndex2 > Twave(j), 1, 'first'));
                end
                
                if min(minIndex2) >= Twave(j) | numel(minIndex2) == 0
                    TLLeg(j) = round((Jpoint(j)+Twave(j))/2);
                else
                    TLLeg(j) = minIndex2(find(minIndex2 < Twave(j), 1, 'last'));
                end
                
            else
                Twave(j) = firstMinAfterJpoint;
                maxIndex2 = maxwindowfilter(subArrayFindMinMax, 101);
                maxIndex2 = maxIndex2 + Jpoint(j)-1;

                if max(maxIndex2) <= Twave(j) | numel(maxIndex2) == 0
                    TRLeg(j) = round((Twave(j)+nuakhoangRR(j+1))/2);
                else
                    TRLeg(j) = maxIndex2(find(maxIndex2 > Twave(j), 1, 'first'));
                end
                
                if min(maxIndex2) >= Twave(j) | numel(maxIndex2) == 0
                    TLLeg(j) = round((Jpoint(j)+Twave(j))/2);
                else
                    TLLeg(j) = maxIndex2(find(maxIndex2 < Twave(j), 1, 'last'));
                end
                
            end    %   END OF firstMaxAfterJpoint < firstMinAfterJpoint
        end
    end
end
