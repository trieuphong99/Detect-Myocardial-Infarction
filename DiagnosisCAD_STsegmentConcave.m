%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH DONG MACH VANH
%       ST SEGMENT
%   Coronary heart disease (CHD) = Benh Dong Mach Vanh
%
%   Xet o tat ca cac chuyen dao, tru aVR thi nguoc lai
%   CHENH XUONG
%           1mm             Benh ly ro rang
%           0.5-0.9mm       Nghi benh ly
%           0.5             Co th benh ly

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

%%
% function DiagnosisCAD_STsegmentConcave(Lead, oderstr, data, Jpoint, TLLeg)
%     figure(202); set(202, 'Name', strcat('Coronary Heart Disease Diagnostic ST SEGMENT'));
%     text(0.45, 0.8, ['\bf', 'CHAN DOAN THEO DOAN ST CHENH XUONG' char(10)]);
%     ST = (data(Jpoint)-data(TLLeg))/10000;
%     
%     %   In aVR
%     if Lead == 4
%         text(0.12, 0.4, oderstr);
%         if ST < 0
%             text(0.15, 0.4, ['Chenh len ', num2str(abs(ST*10))]);
%         elseif ST >= 0.1 %(1mm)
%             text(0.15, 0.4, ['Chenh xuong ', num2str(ST*10), '\bf', '    Co the benh ly']);
%         elseif ST > 0.05 & ST < 0.1
%             text(0.15, 0.4, ['Chenh xuong ', num2str(ST*10), '\bf', '    Nghi Ngo benh ly']);
%         elseif ST > 0.045 & ST <= 0.05
%             text(0.15, 0.4, ['Chenh xuong ', num2str(ST*10), '\bf', '    Benh Ly ro rang']);
%         else
%             text(0.15, 0.4, ['Chenh xuong ', num2str(ST*10), '\bf', '    Khong co benh ly']);
%         end
%     end
%     
%     %   In DI
%     if Lead >=1 & Lead <= 6 & Lead ~= 4
% %         text(0.12, 0.8-Lead/10, strcat('(',num2str(Lead),')'));
%         text(0.12, 0.8-Lead/10, oderstr);
%         if ST < 0
%             text(0.15, 0.8-Lead/10, ['Chenh len ', num2str(abs(ST*10))]);
%         elseif ST >= 0.1 %(1mm)
%             text(0.15, 0.8-Lead/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    Benh Ly RO RANG']);
%         elseif ST > 0.05 & ST < 0.1
%             text(0.15, 0.8-Lead/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    NGHI NGO benh ly']);
%         elseif ST > 0.045 & ST <= 0.05
%             text(0.15, 0.8-Lead/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    CO THE benh ly']);
%         else
%             text(0.15, 0.8-Lead/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    Khong co benh ly']);
%         end
%     end
%     
%     if Lead >= 7 & Lead <= 12
%         text(0.52, 0.8-(Lead-6)/10, oderstr);
%         if ST < 0
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh len ', num2str(abs(ST*10))]);
%         elseif ST >= 0.1 %(1mm)
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    Benh Ly RO RANG']);
%         elseif ST > 0.05 & ST < 0.1
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    NGHI NGO benh ly']);
%         elseif ST > 0.045 & ST <= 0.05
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    CO THE benh ly']);
%         else
%             text(0.55, 0.8-(Lead-6)/10, ['Chenh xuong ', num2str(ST*10), '\bf', '    CO THE benh ly']);
%         end
%     end
% end