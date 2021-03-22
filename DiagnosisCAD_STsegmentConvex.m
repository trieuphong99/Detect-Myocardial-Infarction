%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH NHOI MAU CO TIM DOAN ST CHENH LEN

function DiagnosisCAD_STsegmentConvex(Lead, data, Jpoint, TLLeg)
global BLRRSTsegmentConvex;

    STsegmentConvex = data(TLLeg) - data(Jpoint);
    if Lead >= 7 & Lead <= 10   %   IN lead from V1 to V4
        if STsegmentConvex >= 0.2       %   BLRR ~~ 2mm
            i = numel(BLRRSTsegmentConvex) + 1;
            BLRRSTsegmentConvex(i) = Lead;
        end
    else    %   In other leads
        if STsegmentConvex >= 0.1       %   BLRR ~~ 1mm
            i = numel(BLRRSTsegmentConvex) + 1;
            BLRRSTsegmentConvex(i) = Lead;
        end
    end
end
