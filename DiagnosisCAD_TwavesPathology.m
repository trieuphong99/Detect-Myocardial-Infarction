%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH DONG MACH VANH
%       T WAVE
%   Coronary heart disease (CHD) = Benh Dong Mach Vanh
%
%   Xet o tat ca cac chuyen dao, tru D3 va V1
%   
%           Am sau >= 1mm           :Benh Ly
%           Det                     :Co the benh ly

function DiagnosisCAD_TwavesPathology(Lead, data, Twave, TLLeg, TRLeg)
global BLRRTwavePathology;
global CTBLTwavePathology;

    TwaveLeg = (data(TLLeg) + data(TRLeg))/2;     %   Duong nen song T
    T_amplitude = data(Twave) - TwaveLeg;
    if Lead ~= 3 & Lead ~= 7
        %   Benh ly ro rang: Am sau  duoi 1mm
        if T_amplitude <= -0.1
            i = numel(BLRRTwavePathology) + 1;
            BLRRTwavePathology(i) = Lead;
            
        %   CO the benh ly: T det
        elseif abs(T_amplitude/(min(data) - max(data))) < 0.02     %   Ty so 0.02 co the thay doi
            i2 = numel(CTBLTwavePathology) + 1;
            CTBLTwavePathology(i2)  = Lead;
        end
    end
end

%%
% function DiagnosisCAD_TwavesPathology(Lead, oderstr, data, Twave, TLLeg, TRLeg)
%     figure(204); set(204, 'Name', strcat('Coronary Heart Disease Diagnostic T wave'));
%     text(0.4, 0.9, ['\bf', 'CHAN DOAN THEO SONG T' char(10)]);
%     text(0.35, 0.83, ['\bf', 'Am sau >= 1mm           :Benh Ly' char(10)]);
%     text(0.35, 0.8, ['\bf',  'Det                     :Co the benh ly' char(10)]);
%     
%     LegT = ((data(TLLeg)+data(TRLeg))/2)/10000; %   Trung binh 2 chan song
%     T_amplitude = data(Twave)/10000-LegT;
% 
%     if Lead == 3
%         text(0.15, 0.8-Lead/10, ['T = ', num2str(T_amplitude*10), 'mm']);
%     end
%     if Lead == 7
%         text(0.55, 0.8-(Lead-6)/10, ['T = ', num2str(T_amplitude*10), 'mm']);
%     end
%     if Lead >=1 & Lead <= 6 & Lead ~= 3
%         text(0.12, 0.8-Lead/10, oderstr);
%         if T_amplitude > 0.02
%             text(0.15, 0.8-Lead/10, ['T duong ', num2str(abs(T_amplitude*10)), 'mm']);
%         elseif T_amplitude < -0.1   %   am sau tu 1mm
%             text(0.15, 0.8-Lead/10, ['BENH LY - T am ', num2str(abs(T_amplitude*10)), 'mm']);
%         elseif T_amplitude >= -0.02 & T_amplitude <= 0.02    %  T det
%             text(0.15, 0.8-Lead/10, ['CO THE BENH LY - T det ', num2str(abs(T_amplitude*10)), 'mm']);
%         else
%             text(0.15, 0.8-Lead/10, ['T am ', num2str(abs(T_amplitude*10)), 'mm']);
%         end
%     end
%     
%     if Lead >= 8 & Lead <= 12
%         text(0.52, 0.8-(Lead-6)/10, oderstr);
%         if T_amplitude > 0.02
%             text(0.55, 0.8-(Lead-6)/10, ['T duong ', num2str(abs(T_amplitude*10)), 'mm']);
%         elseif T_amplitude < -0.1   %   am sau tu 1mm
%             text(0.55, 0.8-(Lead-6)/10, ['BENH LY - T am ', num2str(abs(T_amplitude*10)), 'mm']);
%         elseif T_amplitude >= -0.02 & T_amplitude <= 0.02    %  T det
%             text(0.55, 0.8-(Lead-6)/10, ['CO THE BENH LY - T det ', num2str(abs(T_amplitude*10)), 'mm']);
%         else
%             text(0.55, 0.8-(Lead-6)/10, ['T am ', num2str(abs(T_amplitude*10)), 'mm']);
%         end
%     end
% end