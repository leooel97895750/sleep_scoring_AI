% clear all
function feat_nor = feat_nor_test(feat)
% tic
%feat_23 = feat;
feat_52 = feat;
% for subj_no = 6
% if subj_no == 1
%     load feat_s980423.dat
%     load s980423_feat_new3.dat
%     load feat_spindle_s980423.dat
%     load feat_emg_s980423.dat
% 
%     feat_ori_17 = feat_s980423;
%     feat_new3 = s980423_feat_new3;
%     feat_emg = feat_emg_s980423;
%     feat_spindle = feat_spindle_s980423;
% elseif subj_no == 2
%     load feat_s980428.dat
%     load s980428_feat_new3.dat
%     load feat_spindle_s980428.dat
%     load feat_emg_s980428.dat
% 
%     feat_ori_17 = feat_s980428;
%     feat_new3 = s980428_feat_new3;
%     feat_emg = feat_emg_s980428;
%     feat_spindle = feat_spindle_s980428;
% elseif subj_no == 3
%     load feat_s980430.dat
%     load s980430_feat_new3.dat
%     load feat_spindle_s980430.dat
%     load feat_emg_s980430.dat
% 
%     feat_ori_17 = feat_s980430;
%     feat_new3 = s980430_feat_new3;
%     feat_emg = feat_emg_s980430;
%     feat_spindle = feat_spindle_s980430;
% elseif subj_no == 4
%     load feat_s980501.dat
%     load s980501_feat_new3.dat
%     load feat_spindle_s980501.dat
%     load feat_emg_s980501.dat
% 
%     feat_ori_17 = feat_s980501;
%     feat_new3 = s980501_feat_new3;
%     feat_emg = feat_emg_s980501;
%     feat_spindle = feat_spindle_s980501;
% elseif subj_no == 5
%     load feat_s980521.dat
%     load s980521_feat_new3.dat
%     load feat_spindle_s980521.dat
%     load feat_emg_s980521.dat
% 
%     feat_ori_17 = feat_s980521;
%     feat_new3 = s980521_feat_new3;
%     feat_emg = feat_emg_s980521;
%     feat_spindle = feat_spindle_s980521;
% elseif subj_no == 6
%     load feat_s980401.dat
%     load s980401_feat_new3.dat
%     load feat_spindle_s980401.dat
%     load feat_emg_s980401.dat
% 
%     feat_ori_17 = feat_s980401;
%     feat_new3 = s980401_feat_new3;
%     feat_emg = feat_emg_s980401;
%     feat_spindle = feat_spindle_s980401;
% elseif subj_no == 7
%     load feat_s1025.dat
%     load s1025_feat_new3.dat
%     load feat_spindle_s1025.dat
%     load feat_emg_s1025.dat
% 
%     feat_ori_17 = feat_s1025;
%     feat_new3 = s1025_feat_new3;
%     feat_emg = feat_emg_s1025;
%     feat_spindle = feat_spindle_s1025;
% elseif subj_no == 8
%     load feat_s1129.dat
%     load s1129_feat_new3.dat
%     load feat_spindle_s1129.dat
%     load feat_emg_s1129.dat
% 
%     feat_ori_17 = feat_s1129;
%     feat_new3 = s1129_feat_new3;
%     feat_emg = feat_emg_s1129;
%     feat_spindle = feat_spindle_s1129;
% elseif subj_no == 9
%     load feat_s1203.dat
%     load s1203_feat_new3.dat
%     load feat_spindle_s1203.dat
%     load feat_emg_s1203.dat
% 
%     feat_ori_17 = feat_s1203;
%     feat_new3 = s1203_feat_new3;
%     feat_emg = feat_emg_s1203;
%     feat_spindle = feat_spindle_s1203;
% elseif subj_no == 10
%     load feat_s1224.dat
%     load s1224_feat_new3.dat
%     load feat_spindle_s1224.dat
%     load feat_emg_s1224.dat
% 
%     feat_ori_17 = feat_s1224;
%     feat_new3 = s1224_feat_new3;
%     feat_emg = feat_emg_s1224;
%     feat_spindle = feat_spindle_s1224;
% 
% end

% feat_23 = zeros(length(feat_ori_17),23);
% feat_23(:,1:17) = feat_ori_17;
% feat_23(:,18:20) = feat_new3;
% feat_23(:,21:22) = feat_emg;
% feat_23(:,23) = feat_spindle;
[si_a,si_b] = size(feat_52);
feat_new_dis = zeros(si_a,52);
for feat_no = 1:52
        feat_ratio_arr = sort(feat_52(:,feat_no));  % 指定feature
        len_data = length(feat_ratio_arr);
        max_feat_ratio = mean(feat_ratio_arr((len_data - floor(len_data/10)) :len_data));
        min_feat_ratio = mean(feat_ratio_arr( 1 : (1+ floor(len_data/10))));

        %     base_feat(feat_no,1) = min_feat_ratio;
        %     base_feat(feat_no,2) = max_feat_ratio;
            % csvwrite('base_feat_19.dat',base_feat_19)
        min_base = 0;
        max_base = 1;

        % csvwrite('base_feat.dat',base_feat)
        feat_new_dis(:,feat_no) = min_base + ((feat_52(:,feat_no) - min_feat_ratio) ./ (max_feat_ratio - min_feat_ratio)) * (max_base - min_base);  % 指定feature
end 
feat_nor = feat_new_dis;
% if subj_no == 1
%     feat_s980423_nor_23 = feat_new_dis;
%     csvwrite('feat_s980423_nor_23.dat',feat_s980423_nor_23)
% elseif subj_no == 2
%     feat_s980428_nor_23 = feat_new_dis;
%     csvwrite('feat_s980428_nor_23.dat',feat_s980428_nor_23)
% elseif subj_no == 3
%     feat_s980430_nor_23 = feat_new_dis;
%     csvwrite('feat_s980430_nor_23.dat',feat_s980430_nor_23)
% elseif subj_no == 4
%     feat_s980501_nor_23 = feat_new_dis;
%     csvwrite('feat_s980501_nor_23.dat',feat_s980501_nor_23)
% elseif subj_no == 5
%     feat_s980521_nor_23 = feat_new_dis;
%     csvwrite('feat_s980521_nor_23.dat',feat_s980521_nor_23)
% elseif subj_no == 6
%     feat_s980401_nor_23 = feat_new_dis;
%     csvwrite('feat_s980401_nor_23.dat',feat_s980401_nor_23)
% elseif subj_no == 7
%     feat_s1025_nor = feat_new_dis;
%     csvwrite('feat_s1025_nor.dat',feat_s1025_nor)
% elseif subj_no == 8
%     feat_s1129_nor = feat_new_dis;
%     csvwrite('feat_s1129_nor.dat',feat_s1129_nor)
% elseif subj_no == 9
%     feat_s1203_nor = feat_new_dis;
%     csvwrite('feat_s1203_nor.dat',feat_s1203_nor)
% elseif subj_no == 10
%     feat_s1224_nor = feat_new_dis;
%     csvwrite('feat_s1224_nor.dat',feat_s1224_nor)
% end
% end
% toc