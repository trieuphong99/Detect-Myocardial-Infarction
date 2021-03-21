%%@EXAMPLE Qwave = detectQwave(ecg, length(positions2)-1, positions2, QRdistance);
    %   [Qwave, QLLeg, QRLeg, Q_amplitude] = detectQwave(data, data_filter, number_of_peaks, Rpeaks, Swave, QRdistance)
function [Qwave, QLLeg, QRLeg] = detectQwave(data, data_filter, number_of_peaks, Rpeaks, Swave, QRdistance)
    for i=2:1:number_of_peaks
        [USELESS, Qwave(i)] = min(data([(Rpeaks(i)-QRdistance)+1:1:Rpeaks(i)]));
        Qwave(i) = (Rpeaks(i)-QRdistance)+1+Qwave(i)-1;
        
        [USELESS, Qwave_Filter] = min(data_filter([(Rpeaks(i)-QRdistance)+1:1:Rpeaks(i)]));
        Qwave_Filter(i) = (Rpeaks(i)-QRdistance)+1+Qwave_Filter-1;
        
        %   Neu Qwave nam truoc Qfilter
        if Qwave(i) < Qwave_Filter(i)-5
            Qwave(i) = Qwave_Filter(i);
        end
        %   Neu Qwave nam sau min trong doan nuaRR den R (ex: d2 patien106)
        halfRR = Rpeaks(i-1)+round((Rpeaks(i)-Rpeaks(i-1))/2)+50;
        [USELESS, minimum] = min(data([halfRR:1:Rpeaks(i)]));
        minimum = halfRR+minimum-1;
        if Qwave(i) - minimum <= 25
            Qwave(i) = minimum;
        end
        
        %   Left Leg of Qwave
        [USELESS,QLLeg(i)] = max(data([Qwave(i)-20:1:Qwave(i)]));
        QLLeg(i) = Qwave(i)-20 + QLLeg(i) - 1;
        
        %   Neu song Q ko co chan
        if data(QLLeg(i)) <= data(Qwave(i))
            QLLeg(i) = Qwave(i);
            QRLeg(i) = Qwave(i);
        else
            %   Right Leg of Qwave
            for j=Rpeaks(i)-1:-1:Qwave(i)
                %   Tim diem bang voi QLLeg
                if data(j) == data(QLLeg(i))
                    QRLeg(i) = j;
                    break;
                %   Tim 2 diem lien tiep lon hon va nho hon so voi QLLeg
                elseif data(j) < data(QLLeg(i))
                    if abs(data(j+1)-data(QLLeg(i))) <= abs(data(j)-data(QLLeg(i)))
                        QRLeg(i) = j+1;
                    else
                        QRLeg(i) = j;
                    end
                    break;
                end
            end
        end
        
        %   CORRECTEC Qwave
        if i > numel(Swave)
            break;
        end
        RS_amplitude(i) = data(Rpeaks(i)) - data(Swave(i));
        Q_amplitude(i) = abs(data(Qwave(i))-data(QLLeg(i)));
        if Q_amplitude/RS_amplitude <= 0.02 %   value 0.02 maybe change, but it is the best rational
            Qwave(i) = QRLeg(i);
            QLLeg(i) = QRLeg(i);
            Q_amplitude(i) = 0;
        end
    end
     [USELESS,Qwave(1)] = min(data([1:1:Rpeaks(1)]));   %   Cho them de ve
     QLLeg(1) = Qwave(1);
     QRLeg(1) = Qwave(1);
%     Qwave(number_of_peaks) = Rpeaks(number_of_peaks);
    
    
%% @Fix mistakes when detecting...
    %%@PROBLEM 1: chinh sua viec song Q xac dinh nham ko phai la song sau
     %nhat do pham vi xac dinh song Q qua hep, gay nham lan giua song P va
     %song Q
     
    %@SOLUTION: Neu song Q o giua khoang song sau nhat (Song P nham) va
    %song R hoac gan sat voi muc gioi han tim min song Q o day la
    %(beginn(i)-area_execute) thi cho no la song sau nhat
    
end
%	Ham detectQwave xac dinh tat ca song Q
%	Dau ra la toan bo dinh Q xac dinh duoc
%	Dau vao cua ham la du lieu ECG, so luong dinh R ~ so luong song Q va
%	diem bat dau moi khoang xet la tu vi tri dinh R tru di khoang can xet
%	toi dinh R (RS distance)

%   *******************************************************************
%     % Song Q la song am truoc song R trong phuc bo QRS
%     % Thoi gian QRS tb < 0.1s va khoang QR tam 0.04s
%     % Neu phat hien QRS ma chi co 1 song am thi do la phuc bo la song Q va
%     % goi la phuc bo QS
%     % Q o V1 V2 V3 la bat thuong (vi binh thuong se ko co), ngoai tru D3 va
%     % aVR va aVF thi song Q o cac chuyen dao khac rat nho
%  
% % Detect Q wave ends here-------------------------------------