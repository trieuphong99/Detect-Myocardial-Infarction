%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH DONG MACH VANH
%       ST SEGMENT
%   Coronary heart disease (CHD) = Benh Dong Mach Vanh
%
%   Xet o tat ca cac chuyen dao, tru aVR thi nguoc lai
%   CHENH LEN BENH LY
%           >= 2mm o V1 den V4
%           >= 1mm o cac chuyen dao khac

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

%%
% function DiagnosisCAD_STsegmentConvex(Lead, oderstr, data, Jpoint, TLLeg)
%     figure(203); set(203, 'Name', strcat('Coronary Heart Disease Diagnostic ST SEGMENT'));
%     text(0.35, 0.9, ['\bf', 'CHAN DOAN THEO DOAN ST CHENH LEN' char(10)]);
%     text(0.35, 0.83, ['\bf', 'Benh ly neu chenh len 2mm o V1 den V4' char(10)]);
%     text(0.35, 0.8, ['\bf', 'va chenh len 1mm o cac chuyen dao khac' char(10)]);
%     
%     ST = (data(TLLeg)-data(Jpoint))/10000;
%     
%     if Lead >= 7 & Lead <= 10
%         text(0.52, 0.8-(Lead-6)/10, oderstr);
%         if ST < 0
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(abs(ST*10))]);
%         elseif ST >= 0.2    %(2mm)
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh len Benh Ly ', num2str(ST*10)]);
%         else
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh len ', num2str(ST*10)]);
%         end
%     end
%     
%     if Lead >=1 & Lead <= 6
%         text(0.12, 0.8-Lead/10, oderstr);
%         if ST < 0
%             text(0.15, 0.8-Lead/10, ['Chenh xuong ', num2str(abs(ST*10))]);
%         elseif ST >= 0.1    %(1mm)
%             text(0.15, 0.8-Lead/10, ['Chenh len Benh Ly ', num2str(ST*10)]);
%         else
%             text(0.15, 0.8-Lead/10, ['Chenh len ', num2str(ST*10)]);
%         end
%     end
%     
%     if Lead == 11 | Lead == 12
%         text(0.52, 0.8-(Lead-6)/10, oderstr);
%         if ST < 0
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(abs(ST*10))]);
%         elseif ST >= 0.1    %(1mm)
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh len Benh Ly ', num2str(ST*10)]);
%         else
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh len ', num2str(ST*10)]);
%         end
%     end
% end