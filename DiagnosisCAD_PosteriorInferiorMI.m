%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH NHOI MAU CO TIM SAU VA DUOI

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
end
