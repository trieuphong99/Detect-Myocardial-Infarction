%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH NHOI MAU CO TIM SONG T

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

