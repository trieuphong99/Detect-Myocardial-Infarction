%%  QUY TAC MINNESOTA CHO PHAT HIEN BENH DONG MACH VANH
%              NHOI MAU TRUOC VA BEN
%   Coronary heart disease (CHD) = Benh Dong Mach Vanh
%   Nhoi mau truoc va ben D1, D2, aVL, V1 -> V6
%     Q rong >= 0,04s                : Benh lý rõ ràng
%     Q sâu = R                     : Benh lý rõ ràng
%     Dang QS tu V1 den V4 (V5, V6) : Benh lý rõ ràng
%     Q rong 0,03 – 0,04s           : Nghi benh lý
%     Dang QS tu V1 den V3          : Nghi benh lý
%     Q sâu >= 1/5 R                : Có the benh lý
%     Dang QS tu V1 den V2          : Có the benh lý

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

	%---------ENDING---------%
% function CoronaryHeartDisease(Lead, R_high, R_amplitude, Q_high, Q_duration, Q_amplitude)
% 
%     %	RESET ALL VARRIABLE
% % 	if Lead == 1	
% 		blrr_d1 = 0; blrr_d2 = 0; blrr_aVL = 0; blrr_V1 = 0; blrr_V2 = 0; blrr_V3 = 0; blrr_V4 = 0; blrr_V5 = 0; blrr_V6 = 0; 
% 		QS_shapeAtV1 = 0; QS_shapeAtV2 = 0; QS_shapeAtV3 = 0; QS_shapeAtV4 = 0; QS_shapeAtV5 = 0; QS_shapeAtV6 = 0;
% 		nbl_d1 = 0; nbl_d2 = 0; nbl_aVL = 0; nbl_V1 = 0; nbl_V2 = 0; nbl_V3 = 0; nbl_V4 = 0; nbl_V5 = 0; nbl_V6 = 0;
% 		blrrQduration = ' '; nblQduration = ' '; ctblQamplitude = ' '; blrrQamplitude = ' ';
% %     end
% 	
% 		%%	BENH LY RO RANG	%
% 	if Q_duration >= 40
% 		if Lead == 1
% 			blrr_d1 = blrr_d1 + 1;
% 			blrrQduration = strcat(blrrQduration,'DI ');
% 		end
% 		if Lead == 2
% 		%	blrr_d2 = blrr_d2 + 1;
% 			blrrQduration = strcat(blrrQduration,'DII ');
% 		end
% 		if Lead == 5
% 			blrr_aVL = blrr_aVL + 1;
% 			blrrQduration = strcat(blrrQduration,'aVL ');
% 		end
% 		if Lead == 7
% 			blrr_V1 = blrr_V1 + 1;
% 			blrrQduration = strcat(blrrQduration,'V1 ');
% 		end
% 		if Lead == 8
% 			blrr_V2 = blrr_V2 + 1;
% 			blrrQduration = strcat(blrrQduration,'V2 ');
% 		end
% 		if Lead == 9
% 			blrr_V3 = blrr_V3 + 1;
% 			blrrQduration = strcat(blrrQduration,'V3 ');
% 		end
% 		if Lead == 10
% 			blrr_V4 = blrr_V4 + 1;
% 			blrrQduration = strcat(blrrQduration,'V4 ');
% 		end
% 		if Lead == 11
% 			blrr_V5 = blrr_V5 + 1;
% 			blrrQduration = strcat(blrrQduration,'V5 ');
% 		end
% 		if Lead == 12
% 			blrr_V6 = blrr_V6 + 1;
% 			blrrQduration = strcat(blrrQduration,'V6 ');
% 		end
% 	end
% 	
% 	if ((Q_amplitude >= (R_amplitude-0.01)) & (Q_amplitude <= (R_amplitude+0.01))) & (Q_amplitude*R_amplitude < 0)	%	Q and R is in different direction 
% 		if Lead == 1
% 			blrr_d1 = blrr_d1 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'DI ');
% 		end
% 		if Lead == 2
% 			blrr_d2 = blrr_d2 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'DII ');
% 		end
% 		if Lead == 5
% 			blrr_aVL = blrr_aVL + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'aVL ');
% 		end
% 		if Lead == 7
% 			blrr_V1 = blrr_V1 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'V1 ');
% 		end
% 		if Lead == 8
% 			blrr_V2 = blrr_V2 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'V2 ');
% 		end
% 		if Lead == 9
% 			blrr_V3 = blrr_V3 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'V3 ');
% 		end
% 		if Lead == 10
% 			blrr_V4 = blrr_V4 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'V4 ');
% 		end
% 		if Lead == 11
% 			blrr_V5 = blrr_V5 + 1;
% 			
% 			blrrQamplitude = strcat(blrrQamplitude, 'V5 ');
% 		end
% 		if Lead == 12
% 			blrr_V6 = blrr_V6 + 1;
% 			blrrQamplitude = strcat(blrrQamplitude, 'V6 ');
% 		end
% 	end
% 	
% 	if abs(R_high - Q_high) < 0.05	%	Tru theo do cao (so sanh 2 vi tri dinh)
% 		if Lead == 7	%	V1
% 			QS_shapeAtV1 = 1;
% 		end
% 		if Lead == 8	%	V2
% 			QS_shapeAtV2 = 1;
% 		end
% 		if Lead == 9	%	V3
% 			QS_shapeAtV3 = 1;
% 		end
% 		if Lead == 10	%	V4
% 			QS_shapeAtV4 = 1;
% 		end
% 		if Lead == 11	%	V5
% 			QS_shapeAtV5 = 1;
% 		end
% 		if Lead == 12	%	V6
% 			QS_shapeAtV6 = 1;
% 		end
% 	end
% 	if Lead == 12	%	Da duyet het toan bo chuyen dao
%         QS_Diagnostic = 'KHONG CO THONG TIN BENH LY - CHUA THE KHANG DINH CO BENH HAY KHONG';
%         Level1 = 0;
% 		if (QS_shapeAtV1 + QS_shapeAtV2 + QS_shapeAtV3 + QS_shapeAtV4 + QS_shapeAtV5 + QS_shapeAtV6) == 6
% 			%	Benh Ly RO Rang Den 100%
% 			Level1 = 1;
% 			QS_Diagnostic = 'BENH LY RO RANG: Benh Nhan Chac Chan Bi Benh Dong Mach Vanh';
% 		end
% 		if (QS_shapeAtV1 + QS_shapeAtV2 + QS_shapeAtV3 + QS_shapeAtV4 + QS_shapeAtV5 + QS_shapeAtV6) == 5
% 			%	Benh Ly RO Rang Den 95%
% 			Level1 = 0.95;
% 			QS_Diagnostic = 'BENH LY RO RANG: Benh Nhan Chac Chan Bi Benh Dong Mach Vanh';
% 		end
% 		if (((QS_shapeAtV1 + QS_shapeAtV2 + QS_shapeAtV3 + QS_shapeAtV4) == 4) & (QS_shapeAtV5 == 0) & (QS_shapeAtV6 == 0))
% 			%	Benh Ly RO Rang Den 90%
% 			Level1 = 0.9;
% 			QS_Diagnostic = 'BENH LY RO RANG: Benh Nhan Chac Chan Bi Benh Dong Mach Vanh';
% 		end
% 		
% 		if (QS_shapeAtV1 + QS_shapeAtV2 + QS_shapeAtV3) == 3 & QS_shapeAtV4 == 0
% 			%	Nghi Benh Ly
% 			Level1 = 0.75;
% 			QS_Diagnostic = 'NGHI NGO BENH LY: Benh Nhan Co Le Bi Benh Dong Mach Vanh';
% 		end
% 		
% 		if ((QS_shapeAtV1 + QS_shapeAtV2) == 2 & (QS_shapeAtV3 + QS_shapeAtV4) == 0)
% 			%	Co the Benh Ly
% 			Level1 = 0.5;
% 			QS_Diagnostic = 'CO THE BENH LY: Benh Nhan Co The Bi Benh Dong Mach Vanh';
% 		end
% 	end
% 	
% 		%%	NGHI BENH LY	%
% 	if Q_duration > 30 & Q_duration < 40
% 		if Lead == 1
% 			nbl_d1 = nbl_d1 + 1;
% 			nblQduration = strcat(nblQduration, 'DI ');
% 		end
% 		if Lead == 2
% 			nbl_d2 = nbl_d2 + 1;
% 			nblQduration = strcat(nblQduration, 'DII ');
% 		end
% 		if Lead == 5
% 			nbl_aVL = nbl_aVL + 1;
% 			nblQduration = strcat(nblQduration, 'aVL ');
% 		end
% 		if Lead == 7
% 			nbl_V1 = nbl_V1 + 1;
% 			nblQduration = strcat(nblQduration, 'V1 ');
% 		end
% 		if Lead == 8
% 			nbl_V2 = nbl_V2 + 1;
% 			nblQduration = strcat(nblQduration, 'V2 ');
% 		end
% 		if Lead == 9
% 			nbl_V3 = nbl_V3 + 1;
% 			nblQduration = strcat(nblQduration, 'V3 ');
% 		end
% 		if Lead == 10
% 			nbl_V4 = nbl_V4 + 1;
% 			nblQduration = strcat(nblQduration, 'V4 ');
% 		end
% 		if Lead == 11
% 			nbl_V5 = nbl_V5 + 1;
% 			nblQduration = strcat(nblQduration, 'V5 ');
% 		end
% 		if Lead == 12
% 			nbl_V6 = nbl_V6 + 1;
% 			nblQduration = strcat(nblQduration, 'V6 ');
% 		end
% 	end
% 	
% 		%%	CO THE BENH LY	%
% 	if (Q_amplitude >= R_amplitude/5) & (Q_amplitude < R_amplitude) & (Q_amplitude*R_amplitude < 0)
% 		if Lead == 1
% 			ctbl_d1 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'DI ');
% 		end
% 		if Lead == 2
% 			ctbl_d2 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'DII ');
% 		end
% 		if Lead == 5
% 			ctbl_aVL = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'aVL ');
% 		end
% 		if Lead == 7
% 			ctbl_V1 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V1 ');
% 		end
% 		if Lead == 8
% 			ctbl_V2 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V2 ');
% 		end
% 		if Lead == 9
% 			ctbl_V3 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V3 ');
% 		end
% 		if Lead == 10
% 			ctbl_V4 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V4 ');
% 		end
% 		if Lead == 11
% 			ctbl_V5 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V5 ');
% 		end
% 		if Lead == 12
% 			ctbl_V6 = 1;
% 			ctblQamplitude = strcat(ctblQamplitude, 'V6 ');
% 		end
% 	end
% 	
% 	if Lead == 12
% 		figure(200); set(200, 'Name', strcat('Coronary Heart Disease Diagnostic'));
% 		%	Chan Doan theo Dang QS
% 		text(0.05, 0.5, ['\bf', 'Dang QS tu V1 den V6' char(10), QS_Diagnostic, char(10), ...
% 						'Kha nang Bi Benh la: ', Level1, '%']);
% 						
% 		%	Chan Doan theo do rong cua song Q
% 		text(0.09, 0.7, ['\bf', 'Benh Ly ro rang tai cac chuyen dao: ', blrrQduration, char(10)]);
% 		text(0.05, 0.6, ['\bf', 'Nghi Ngo Benh Ly tai cac chuyen dao: ', nblQduration, char(10)]);
% 		
% 		%	Chan Doan theo Do sau cua song Q
% 		text(0.09, 0.4, ['\bf', 'SO SANH SO SAU CUA SONG Q VOI SONG R' char(10), ...
% 						'Q sau = R : Benh Ly Ro Rang tai cac chuyen dao: ', blrrQamplitude, char(10)]);
% 		text(0.05, 0.3, ['\bf', 'Q sau >= R/5 : Co The Benh Ly tai cac chuyen dao: ', ctblQamplitude, char(10)]);
% 		
%         %Diagnostic = ['\bf', 'CO BENH'];
%         %Diagnostic = 1;
%     end
%     
% % 		blrr_d1 = blrr_d1; blrr_d2 = blrr_d2; blrr_aVL = blrr_aVL; blrr_V1 = blrr_V1; blrr_V2 = blrr_V2; blrr_V3 = blrr_V3; blrr_V4 = blrr_V4; blrr_V5 = blrr_V5; blrr_V6 = blrr_V6; 
% % 		QS_shapeAtV1 = QS_shapeAtV1; QS_shapeAtV2 = QS_shapeAtV2; QS_shapeAtV3 = QS_shapeAtV3; QS_shapeAtV4 = QS_shapeAtV4; QS_shapeAtV5 = QS_shapeAtV5; QS_shapeAtV6 = QS_shapeAtV6;
% % 		nbl_d1 = nbl_d1; nbl_d2 = nbl_d2; nbl_aVL = nbl_aVL; nbl_V1 = nbl_V1; nbl_V2 = nbl_V2; nbl_V3 = nbl_V3; nbl_V4 = nbl_V4; nbl_V5 = nbl_V5; nbl_V6 = nbl_V6;
% % 		blrrQduration = blrrQduration; nblQduration = nblQduration; ctblQamplitude = ctblQamplitude; blrrQamplitude = blrrQamplitude;
% 
% end