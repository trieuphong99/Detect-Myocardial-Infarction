%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH NHOI MAU CO TIM DOAN ST CHENH XUONG
 
function DiagnosisCAD_STsegmentConcave(Lead, data, Jpoint, TLLeg)
global BLRRSTsegmentConcave;
global NBLSTsegmentConcave;
global CTBLSTsegmentConcave;

    STconcave = data(Jpoint) - data(TLLeg);
    if Lead == 4    %    In aVR
        if STconcave > 0.048 & STconcave < 0.052    %   BLRR ~~ 0.5mm
            i = numel(BLRRSTsegmentConcave) + 1;
            BLRRSTsegmentConcave(i) = Lead;
        elseif STconcave >= 0.052 & STconcave < 0.1 %   NNBL ~~ 0.5-0.9mm
            i2 = numel(NBLSTsegmentConcave) + 1;
            NBLSTsegmentConcave(i2) = Lead;
        elseif STconcave >= 0.1                     %   CTBL ~~ 1mm
            i3 = numel(CTBLSTsegmentConcave) + 1;
            CTBLSTsegmentConcave(i3) = Lead;
        end
    else    %   In other lead
        if STconcave > 0.048 & STconcave < 0.052    %   CTBL ~~ 0.5mm
            i3 = numel(CTBLSTsegmentConcave) + 1;
            CTBLSTsegmentConcave(i3) = Lead;
        elseif STconcave >= 0.052 & STconcave < 0.1 %   NNBL ~~ 0.5-0.9mm
            i2 = numel(NBLSTsegmentConcave) + 1;
            NBLSTsegmentConcave(i2) = Lead;
        elseif STconcave >= 0.1                     %   BLRR~~ 1mm
            i = numel(BLRRSTsegmentConcave) + 1;
            BLRRSTsegmentConcave(i) = Lead;
        end
    end

end
