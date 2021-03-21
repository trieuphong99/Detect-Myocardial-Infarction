%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH DONG MACH VANH
%              NHOI MAU SAU - DUOI
%   Coronary heart disease (CHD) = Benh Dong Mach Vanh
%   Nhoi mau sau - duoi: Cac chuyen dao D3, aVF
%       Q rong >= 0.05s         Benh ly ro rang
%       Q rong 0.04s - 0.05s    Nghi benh ly
%       Q sau >= 5mm            Nghi benh ly

function DiagnosisCAD_PosteriorInferiorMI(Lead, Q_duration, Q_amplitude)
global BLRRQdurationCAD_Poterior;

global NBLQdurationCAD_Poterior;
global NBLQamplitudeCAD_Poterior;

    %%   CHAN DOAN THEO BENH LY RO RANG
    %   Q rong >= 0.05s
    if Q_duration >= 50
        i1 = numel(BLRRQdurationCAD_Poterior) + 1;
        BLRRQdurationCAD_Poterior(i1) = Lead;
    end
    
    %%  CHAN DOAN THEO NGHI BENH LY
    %   Q rong tu 0.04 - 0.05s
    if Q_duration >= 40 & Q_duration < 50
        ii1 = numel(NBLQdurationCAD_Poterior) + 1;
        NBLQdurationCAD_Poterior(ii1) = Lead;
    end
    %   Q sau >= 5mm
    if Q_amplitude >= 0.5
        ii2 = numel(NBLQamplitudeCAD_Poterior) + 1;
        NBLQamplitudeCAD_Poterior(ii2) = Lead;
    end

%%
% function Diagnosis_CoronaryHeartDisease2(Lead, Q_duration, Q_amplitude)
%     figure(201); set(201, 'Name', strcat('Coronary Heart Disease Diagnostic'));
%     text(0.45, 0.8, ['\bf', 'NHOI MAU SAU - DUOI' char(10)]);
%     if Lead == 3
%         text(0.25, 0.7, 'DIII ');
%         if Q_duration >= 50
%             text(0.1, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    BENH LY RO RANG TAI D3']);
%         end
%         if Q_duration >= 40 & Q_duration < 50
%             text(0.1, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    NGHI BENH LY TAI D3']);
%         end
%         if Q_duration < 40
%             text(0.1, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    KHONG CO BENH LY TAI D3']);
%         end
%         if Q_amplitude >= 0.5
%             text(0.1, 0.5, ['Q amplitude = ', num2str(Q_amplitude), '\bf', '    NGHI BENH LY TAI D3']);
%         end
%         if Q_amplitude < 0.5
%             text(0.1, 0.5, ['Q amplitude = ', num2str(Q_amplitude), '\bf', '    KHONG CO BENH LY TAI D3']);
%         end
%     end
%     
%     if Lead == 6
%         text(0.75, 0.7, 'aVF ');
%         if Q_duration >= 50
%             text(0.6, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    BENH LY RO RANG TAI aVF']);
%         end
%         if Q_duration >= 40 & Q_duration < 50
%             text(0.6, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    NGHI BENH LY TAI aVF']);
%         end
%         if Q_duration < 40
%             text(0.6, 0.6, ['Q duration = ', num2str(Q_duration), '\bf', '    KHONG CO BENH LY TAI aVF']);
%         end
%         if Q_amplitude >= 0.5
%             text(0.6, 0.5, ['Q amplitude = ', num2str(Q_amplitude), '\bf', '    NGHI BENH LY TAI aVF']);
%         end
%         if Q_amplitude < 0.5
%             text(0.6, 0.5, ['Q amplitude = ', num2str(Q_amplitude), '\bf', '    KHONG CO BENH LY TAI aVF']);
%         end
%     end
% end