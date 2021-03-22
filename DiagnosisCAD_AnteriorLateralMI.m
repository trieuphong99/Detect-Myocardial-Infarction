%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH NHOI MAU CO TIM TRUOC VA BEN

function DiagnosisCAD_AnteriorLateralMI(Lead, R_high, R_amplitude, Q_high, Q_duration, Q_amplitude)
    %	CORONARY HEART DISEASE	%
    %   NHOI MAU TRUOC VA BEN   %
global BLRRQduration;
global BLRRQamplitude;
global BLRRQS_Shape;

global NBLQduration;
global NBLQS_Shape;

global CTBLQamplitude;
global CTBLQS_Shape;

    %%   XET THEO BENH LY RO RANG
    %   Q rong >= 40s
    if Q_duration >= 40
        i1 = numel(BLRRQduration)+1;
        BLRRQduration(i1) = Lead;
        %   BLRRQduration = strcat(BLRRQduration, num2str(Lead), ' ');
    end
    %   Q sau bang R
    if abs(Q_amplitude/R_amplitude) >= 0.99 & abs(Q_amplitude/R_amplitude) <= 1.01
        i2 = numel(BLRRQamplitude)+1;
        BLRRQamplitude(i2) = Lead;
        %   BLRRQamplitude = strcat(BLRRQamplitude, num2str(Lead), ' ');
    end
    %   Dang QS tu V1 den V4 (V5, V6)
    if Lead >= 7 & Lead <= 12
        if (R_high/Q_high >= 0.9 & R_high/Q_high < 1.1 & R_high*Q_high > 0)	%	Ty le 2 dinh bang 1 hoac dinh R bang 0
            i3 = numel(BLRRQS_Shape)+1;
            BLRRQS_Shape(i3) = Lead;
        end
    end
    
    %%  XET THEO NGHI NGO BENH LY
    %   Q rong tu 0.03-0.04s
    if Q_duration > 30 & Q_duration < 40
        ii1 = numel(NBLQduration) + 1;
        NBLQduration(ii1) = Lead;
    end
    %   Dang QS tu V1 den V3
    if Lead >= 7 & Lead <= 9
        if (R_high/Q_high >= 0.9 & R_high/Q_high < 1.1 & R_high*Q_high > 0)	%	Ty le 2 dinh bang 1 hoac dinh R bang 0
            ii2 = numel(NBLQS_Shape)+1;
            NBLQS_Shape(ii2) = Lead;
        end
    end
    
    %%  XET THEO CO THE BENH LY
    %   Q sau = 1/3 R
    if (Q_amplitude >= R_amplitude/5) & (Q_amplitude < R_amplitude)
        iii1 = numel(CTBLQamplitude) + 1;
        CTBLQamplitude(iii1) = Lead;
    end
    %   Dang QS tu V1 den V2
    if Lead >= 7 & Lead <= 8
        if (R_high/Q_high >= 0.9 & R_high/Q_high < 1.1 & R_high*Q_high > 0)	%	Ty le 2 dinh bang 1 hoac dinh R bang 0
            iii2 = numel(CTBLQS_Shape)+1;
            CTBLQS_Shape(iii2) = Lead;
        end
    end
end
