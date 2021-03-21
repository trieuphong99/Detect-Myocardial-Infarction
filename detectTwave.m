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




% function [Twave, TLLeg, TRLeg] = detectTwave(data, samplingrate, nuakhoangRR, Rpeaks, Swave)
%             %   [Twave, TLLeg, TRLeg]
%     number_of_peaks = length(Rpeaks)-1;
%     %   Remove lower frequencies
%     ECGinFreq = fft(data);
%     ECGinFreq(1 : round(length(ECGinFreq)*5/samplingrate))=0; %hpf
%     ECGinFreq((end - round(length(ECGinFreq)*5/samplingrate)) : end)=0;   %lpf
%     ECGinTimeDomain = real(ifft(ECGinFreq));
%        
%     WinSize = floor(samplingrate * 201 / 1000); %   Winsize should be odd number
%     peaks_tmp = ecgdemowinmax(ECGinTimeDomain, WinSize);
%     peaks_tmp2 = find(peaks_tmp);
%     
%     %   Khoi tao ban dau cho Song T va diem J
%     for i=2:1:number_of_peaks
%         %   Tinh diem J tong quat(khong phai diem J khi tinh Swave vi co the sai khi tinh T)
%         [USELESS, Jpoint(i)] = max(ECGinTimeDomain([Swave(i):1:Swave(i)+70]));
%         Jpoint(i) = Swave(i) + Jpoint(i)-1;
%         
%         %   Xac dinh ban dau song T la dinh sau dinh R khi qua loc cua so
%         for j=2:1:length(peaks_tmp2)
%             if peaks_tmp2(j) == Rpeaks(i)
%                 Ttmp(i) = peaks_tmp2(j+1);
%             end
%             if peaks_tmp2(j) > Jpoint(i)+45 %   Tranh viec Jpoint rat gan voi Ttmp dan den ko tim dc MAX
%                 if peaks_tmp2(j+1) < nuakhoangRR(i+1);  %   Neu co nhieu hon 1 dinh sau R
%                     [USELESS, Twave(i)] = max(data([peaks_tmp2(j)-10:1:peaks_tmp2(j+1)+10]));   %   MAX
%                     Twave(i) = peaks_tmp2(j)-10+Twave(i)-1;
%                     Ttmp(i) = peaks_tmp2(j);
%                 else  %   Neu co 1 dinh sau R
%                     [USELESS, Twave(i)] = max(data([Jpoint(i)+30:1:peaks_tmp2(j)]));   %   MAX
%                     Twave(i) = Jpoint(i)+30+Twave(i)-1;
%                     %Ttmp(i) = Twave(i);
%                 end
%                 break;  %   Tiep tuc voi vong lap i
%             end
%         end
%         %   Initial Right and Left Leg of T
%         TLLeg(i) = Jpoint(i);
%         TRLeg(i) = peaks_tmp2(j+1);
%     end
%     
%     %   CORRECTED T WAVE
%     for i=2:1:number_of_peaks
%        %    AVOID STOPPING PROGRAM when run command in from line 144
%        for k=i:1:length(peaks_tmp2)-1
%            if peaks_tmp2(k)==Ttmp(i)
%                break;
%            end
%        end
%        
%         %   If ini Twave too close to nuakhoangRR, then Twave are minimum in the interval
%        if abs(Twave(i)-nuakhoangRR(i+1)) <= 50
%            %[USELESS, Twave(i)] = min(data([Jpoint(i)+30:1:Ttmp(i)]));
%            [USELESS, Twave(i)] = min(data([Jpoint(i)+30:1:nuakhoangRR(i+1)-60]));
%            Twave(i) = Jpoint(i)+30+Twave(i)-1;
%        else
%            for k=i:1:length(peaks_tmp2)-1
%                %   IF IT HAS MORE THAN 1 PEAK AFTER R PEAK (2 PEAKS)
%                if peaks_tmp2(k)==Ttmp(i) & peaks_tmp2(k+1) <= nuakhoangRR(i+1)-60
%                     [USELESS, Tmax(i)] = max(data([Jpoint(i)+30:1:nuakhoangRR(i+1)-60]));   %   MAX in real
%                     Tmax(i) = Jpoint(i)+30+Tmax(i)-1;
%                     [USELESS, Tmax2(i)] = max(ECGinTimeDomain([peaks_tmp2(k)-10:1:peaks_tmp2(k+1)+10]));   %   MAX in Filter
%                     Tmax2(i) = peaks_tmp2(k)-10+Tmax2(i)-1;
%                     
%                     [USELESS, Tmin(i)] = min(data([peaks_tmp2(k)-10:1:peaks_tmp2(k+1)+10]));   %   MIN in real
%                     Tmin(i) = peaks_tmp2(k)-10+Tmin(i)-1;
%                     [USELESS, Tmin2(i)] = min(ECGinTimeDomain([peaks_tmp2(k)-10:1:peaks_tmp2(k+1)+10]));   %   MIN in Filter
%                     Tmin2(i) = peaks_tmp2(k)-10+Tmin2(i)-1;
%                     
%                     %   If Tmin and Tmin2 is coincide, That value is Twave (2 min trung nhau)
%                     if abs(Tmin2(i)-Tmin(i)) <= 5
%                         Twave(i) = Tmin(i);
%                         
%                         TLLeg(i) = Ttmp(i);
%                         TRLeg(i) = peaks_tmp2(k+1);
%                     %   Nguoc lai thi Uu tien xet vi tri Dt voi Tmax truoc (Dt la dinh sau R)
%                     elseif abs(Tmax(i)-Ttmp(i)) < 50 | abs(Tmax(i)-peaks_tmp2(k+1)) < 50
%                         Twave(i) = Tmax(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
%                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([Ttmp(i):1:peaks_tmp2(k+1)]));
%                         TRLeg(i) = Ttmp(i)+TRLeg(i)-1;
%                     %   Sau do xet vi tri voi Tmin
%                     elseif abs(Tmin(i)-Ttmp(i)) < 50 | abs(Tmin(i)-peaks_tmp2(k+1)) < 50
%                         Twave(i) = Tmin(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
%                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([peaks_tmp2(k+1):1:nuakhoangRR(i+1)-20]));
%                         TRLeg(i) = peaks_tmp2(k+1)+TRLeg(i)-1;
%                     %   Neu tat ca deu ko phai thi T la min 
%                     else
%                         Twave(i) = Tmin(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
% %                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([peaks_tmp2(k+1):1:nuakhoangRR(i+1)-20]));
% %                         TRLeg(i) = peaks_tmp2(k+1)+TRLeg(i)-1;
%                         TRLeg(i) = peaks_tmp2(k+1);
%                     end
%                     break;
%                %   IF IT HAS ONLY 1 PEAK AFTER R PEAKS
%                elseif peaks_tmp2(k)==Ttmp(i) & peaks_tmp2(k+1) > nuakhoangRR(i+1)-60
%                     [USELESS, Tmax(i)] = max(data([Jpoint(i)+30:1:nuakhoangRR(i+1)-60]));   %   MAX nuakhoangRR(i+1)-50
%                     Tmax(i) = Jpoint(i)+30+Tmax(i)-1;
%                     [USELESS, Tmin(i)] = min(data([Jpoint(i)+30:1:nuakhoangRR(i+1)-60]));   %   MIN
%                     Tmin(i) = Jpoint(i)+30+Tmin(i)-1;
%                     
%                     if abs(Tmax(i)-Ttmp(i)) < 50    %   Uu tien xet Tmax truoc
%                         Twave(i) = Tmax(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
%                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([Ttmp(i):1:nuakhoangRR(i+1)-20]));
%                         TRLeg(i) = Ttmp(i)+TRLeg(i)-1;
%                     elseif abs(Tmin(i)-Ttmp(i)) < 50
%                         Twave(i) = Tmin(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
%                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([Ttmp(i):1:nuakhoangRR(i+1)-20]));
%                         TRLeg(i) = Ttmp(i)+TRLeg(i)-1;
%                     else
%                         Twave(i) = Tmin(i);
%                         
%                         [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%                         TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
% %                         [USELESS, TRLeg(i)] = min(ECGinTimeDomain([Ttmp(i):1:nuakhoangRR(i+1)-20]));
% %                         TRLeg(i) = Ttmp(i)+TRLeg(i)-1;
%                         if peaks_tmp2(k+1) < nuakhoangRR(i+1)-40   %   Neu dinh thu 2 rat gan nuakhoangRR thi...
%                             TRLeg(i) = peaks_tmp2(k+1);
%                         else                                    %   Neu khong thi...
%                             TRLeg(i) = nuakhoangRR(i+1) - 50;   
%                         end
%                     end
%                     break;
%                end
%            end
%        end
%      
%        %    Check out if Twave too close to J and nuakhoangRR
%        if abs(Twave(i)-nuakhoangRR(i+1)) <= 65 | abs(Twave(i)-Jpoint(i)) <= 40
%            if peaks_tmp2(k+1) >= nuakhoangRR(i+1)-20
%                k = k-1;
%            end
%            
%            [USELESS, Twave(i)] = min(data([Jpoint(i)+30:1:nuakhoangRR(i+1)-60]));
%            Twave(i) = Jpoint(i)+30+Twave(i)-1;
%            
%            [USELESS, TLLeg(i)] = min(ECGinTimeDomain([Jpoint(i):1:Ttmp(i)]));
%            TLLeg(i) = Jpoint(i)+TLLeg(i)-1;
%            [USELESS, TRLeg(i)] = min(ECGinTimeDomain([peaks_tmp2(k+1):1:nuakhoangRR(i+1)-20]));
%            TRLeg(i) = peaks_tmp2(k+1)+TRLeg(i)-1;
%        end
%        %   Check out if RL and LL are in the same side with Twave cause
%        %   wrong when chosing the interval to determine RL
%        if TRLeg(i) <= Twave(i)
%            TLLeg(i) = TRLeg(i);
%            [USELESS, TRLeg(i)] = min(ECGinTimeDomain([peaks_tmp2(k+1):1:nuakhoangRR(i+1)-20]));
%            TRLeg(i) = peaks_tmp2(k+1)+TRLeg(i)-1;
%        end
%     end
%     
%     Twave(1) = Rpeaks(1)+200;  %   Cho them de ve
%     Twave(number_of_peaks+1) = Rpeaks(number_of_peaks+1);
%     
%     TLLeg(1) = Rpeaks(1)+150;
%     TLLeg(number_of_peaks+1) = Rpeaks(number_of_peaks+1);
%     
%     TRLeg(1) = Rpeaks(1)+250;
%     TRLeg(number_of_peaks+1) = Rpeaks(number_of_peaks+1);
% end









