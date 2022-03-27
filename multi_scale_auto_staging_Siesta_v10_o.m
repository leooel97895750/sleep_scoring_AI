function [output result_final nn_result result_before Kappa_value] = multi_scale_auto_staging_Siesta_v10_o(filename)
%% load data %%
%{
tic
FeatureDir = 'E:\成大睡眠醫學中心資料\PSG_final\feature49\';
StageDir = 'E:\成大睡眠醫學中心資料\PSG_final\stage_find_artifacts_withstage\threshold_500\';  %data remove artifact
%OuputDir
AutostageDir = 'E:\成大睡眠醫學中心資料\PSG_final\cut_channel_EOGL_EMG_EEGC3_mat\autostage_smoothing_v3\'; %autostage
if exist(AutostageDir,'dir')~=7
        mkdir(AutostageDir);
end
AllstageDir = 'E:\成大睡眠醫學中心資料\PSG_final\cut_channel_EOGL_EMG_EEGC3_mat\allstage_smoothing_v3\'; %a11stage
if exist(AllstageDir,'dir')~=7
        mkdir(AllstageDir);
end
nodestageDir = 'E:\成大睡眠醫學中心資料\PSG_final\cut_channel_EOGL_EMG_EEGC3_mat\nodestage_smoothing_v3\'; %a11stage
if exist(nodestageDir,'dir')~=7
        mkdir(nodestageDir);
end

feat = load(strcat(FeatureDir,'feat_',filename(1:end-5),'_nor_49.dat'));%feature49
hyp = load(strcat(StageDir,filename(1:end-5),'.txt')); %remove '_C3M2'
%}

tic
% FeatureDir = 'E:\成大睡眠醫學中心資料\計畫專用\feature49_4\';
% StageDir = 'E:\成大睡眠醫學中心資料\計畫專用\stage_find_artifacts_withstage\';

FeatureDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\feat_chun\';
StageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_Stage\';
%OuputDir
AutostageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\cut_channel_2EEG_2EOG_EMG_mat_chun\autostage_withsmoothing\'; %autostage =>line276
if exist(AutostageDir,'dir')~=7
        mkdir(AutostageDir);
end
AllstageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\cut_channel_2EEG_2EOG_EMG_mat_chun\allstage_withsmoothing\'; %a11stage
if exist(AllstageDir,'dir')~=7
        mkdir(AllstageDir);
end
nodestageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\cut_channel_2EEG_2EOG_EMG_mat_chun\nodestage_withsmoothing\'; %a11stage
if exist(nodestageDir,'dir')~=7
        mkdir(nodestageDir);
end

% FeatureDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\feat_chun\';
% StageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\stage_dat_0111\';
% %OuputDir
% AutostageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\cut_channel_2EEG_2EOG_EMG_mat\autostage_withsmoothing\'; %autostage =>line276
% if exist(AutostageDir,'dir')~=7
%         mkdir(AutostageDir);
% end
% AllstageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\cut_channel_2EEG_2EOG_EMG_mat\allstage_withsmoothing\'; %a11stage
% if exist(AllstageDir,'dir')~=7
%         mkdir(AllstageDir);
% end
% nodestageDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\cut_channel_2EEG_2EOG_EMG_mat\nodestage_withsmoothing\'; %a11stage
% if exist(nodestageDir,'dir')~=7
%         mkdir(nodestageDir);
% end

% feat = load(strcat(FeatureDir,'feat_',filename(1:end-24),'_nor_49.dat'));    %feature49
% hyp = load(strcat(StageDir,filename(1:end-24),'.txt'));  %remove '_C3M2'
feat = load(strcat(FeatureDir,filename(1:end),'_feat.mat'));    %feature49
feat=feat.feat;
hyp = load(strcat(StageDir,filename(1:end),'_stage.dat'));  %remove '_C3M2'
if length(hyp(:,1))==1
    hyp=hyp';
end
%{
tic
FeatureDir = 'E:\成大睡眠醫學中心資料\PSG_all\feature49_4\train\';   %test\'; %train\';   %test\'; %
StageDir = 'E:\成大睡眠醫學中心資料\PSG_all\\stage_find_artifacts_withstage_train\';   %test\'; %train\';   %test\'; %stage_find_artifacts_withstage_train\';   %E:\成大睡眠醫學中心資料\PSG_all\stage_find_artifacts_withstage\';
%OuputDir
AutostageDir = 'E:\成大睡眠醫學中心資料\PSG_all\cut_channel_2EEG_2EOG_EMG_mat\autostage_withsmoothing\train\';   %test\'; %train\';   %test\'; %autostage =>line276
if exist(AutostageDir,'dir')~=7
        mkdir(AutostageDir);
end
AllstageDir = 'E:\成大睡眠醫學中心資料\PSG_all\cut_channel_2EEG_2EOG_EMG_mat\allstage_withsmoothing\train\';   %test\'; %train\';   %test\'; %a11stage
if exist(AllstageDir,'dir')~=7
        mkdir(AllstageDir);
end
nodestageDir = 'E:\成大睡眠醫學中心資料\PSG_all\cut_channel_2EEG_2EOG_EMG_mat\nodestage_withsmoothing\train\';   %test\'; %train\';   %test\'; %a11stage
if exist(nodestageDir,'dir')~=7
        mkdir(nodestageDir);
end

feat = load(strcat(FeatureDir,'feat_',filename(1:end-24),'_nor_49.dat'));    %feature49
hyp = load(strcat(StageDir,filename(1:end-24),'.txt'));  %remove '_C3M2'
%}
%{
tic
FeatureDir = 'E:\AX3_PSG\feature49_4\';
StageDir = 'E:\AX3_PSG\threshold_500\';  %data remove artifact

%OuputDir
AutostageDir = 'E:\AX3_PSG\retrain_version_20190618\autostage_smoothing\'; %autostage
if exist(AutostageDir,'dir')~=7
        mkdir(AutostageDir);
end

AllstageDir = 'E:\AX3_PSG\retrain_version_20190618\allstage_smoothing\'; %a11stage
if exist(AllstageDir,'dir')~=7
        mkdir(AllstageDir);
end

nodestageDir = 'E:\AX3_PSG\retrain_version_20190618\nodestage_smoothing\'; %a11stage
if exist(nodestageDir,'dir')~=7
        mkdir(nodestageDir);
end

feat = load(strcat(FeatureDir,'feat_',filename(1:end-24),'_nor_49.dat'));    %feature49
hyp = load(strcat(StageDir,filename(1:end-24),'.txt'));  %remove '_C3M2'
%}
%%  map the feature into 0~1  %%
[row_i,col_j] = size(feat);
for seq_i=1:col_j
   for seq_j = 1:row_i
       if feat(seq_j,seq_i) > 1 
           feat(seq_j,seq_i) = 1;
       elseif feat(seq_j,seq_i) < 0
           feat(seq_j,seq_i) = 0;
       end
   end
end

hyp(hyp == -1) = 4;
hyp(hyp == -2) = 5;

human_sco = hyp;
%% staging %%
auto_staging = zeros(length(feat),1) - 1;
%fuzzy feature max and min
feature_max_min = [ 1 1 0.45;   %page_num1:N2_N3
                    28 1 0.4;
                    20 0.68 0.3;
                    44 0.79 0.4;
                    36 0.5 0;
                    31 0.38 0;
                    11 1 0;
                    0 0 0;
                    0 0 0; 
                    0 0 0;
                    0 0 0;
                    0 0 0; ];
feature_max_min(:,:,2) = [  5 1 0.35;   %page_num2:N2_REM(rule5)
                            32 0.9 0.47;
                            6 0.61 0;
                            33 0.7 0;
                            10 0.89 0.48;
                            37 0.9 0.69;
                            0 0 0;
                            0 0 0; 
                            0 0 0;
                            0 0 0; 
                            0 0 0;
                            0 0 0; ];
% feature_max_min(:,:,3) = [  1 1 0;   %page_num3:Wake_N2
%                             28 1 0;
%                             2 1 0;
%                             29 1 0;
%                             4 0.9 0.33;
%                             31 1 0.4;
%                             5 1 0.15;
%                             32 1 0.2;
%                             9 1 0;
%                             36 1 0;
%                             10 1 0.2;
%                             15 1 0; ];
% feature_max_min(:,:,3) = [  5 0.9 0.2;   %page_num3:N2_REM(rule7)
%                             32 0.9 0.2;
%                             6 0.5 0;
%                             33 0.45 0;
%                             10 0.9 0.55;
%                             37 0.9 0.5;
%                             0 0 0;
%                             0 0 0; 
%                             0 0 0;
%                             0 0 0; 
%                             0 0 0;
%                             0 0 0; ];
%fuzzy function                       
function membership = feature_low(new,feature_num,page_num)
    for i = 1 : size(feature_max_min,1)
        if feature_max_min(i,1,page_num) == feature_num
            membership = 1-(new-feature_max_min(i,3,page_num))/(feature_max_min(i,2,page_num)-feature_max_min(i,3,page_num));
        end
    end
end

function membership = feature_high(new,feature_num,page_num)
    for i = 1 : size(feature_max_min,1)
        if feature_max_min(i,1,page_num) == feature_num
            membership = (new-feature_max_min(i,3,page_num))/(feature_max_min(i,2,page_num)-feature_max_min(i,3,page_num));
        end
    end
end
%{
function output_rule4 = rule4(epoch_no)
    if feat(epoch_no,18) < 0.33 && 0.3 < feat(epoch_no,47) < 0.9
        output_rule4 = 0;  %rule8;
    else
        %fuzzy
        tmp_W = 0;
        tmp_N2 = 0;
        for j = 1 : size(feature_max_min,1)
            if feature_max_min(j,1,3) == 5 || feature_max_min(j,1,3) == 32|| feature_max_min(j,1,3) == 10 || feature_max_min(j,1,3) == 15 || feature_max_min(j,1,3) == 4 || feature_max_min(j,1,3) == 31 || feature_max_min(j,1,3) == 9 || feature_max_min(j,1,3) == 36 || feature_max_min(j,1,3) == 10 || feature_max_min(j,1,3) == 15
                if feat(epoch_no,feature_max_min(j,1,3)) >= feature_max_min(j,2,3)
                    tmp_W = tmp_W + 1;
                elseif feature_max_min(j,3,3) < feat(epoch_no,feature_max_min(j,1,3)) < feature_max_min(j,2,3)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) >= feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_N2 = tmp_N2 + feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) < feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_W = tmp_W + feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,3)) <= feature_max_min(j,3,3)
                    tmp_N2 = tmp_N2 + 1;
                end
            elseif feature_max_min(j,1,3) == 1 || feature_max_min(j,1,3) == 28 || feature_max_min(j,1,3) == 2 || feature_max_min(j,1,3) == 29
                if feat(epoch_no,feature_max_min(j,1,3)) >= feature_max_min(j,2,3)
                    tmp_N2 = tmp_N2 + 1;
                elseif feature_max_min(j,3,3) < feat(epoch_no,feature_max_min(j,1,3)) < feature_max_min(j,2,3)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) > feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_W = tmp_W + feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) <= feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_N2 = tmp_N2 + feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,3)) <= feature_max_min(j,3,3)
                    tmp_W = tmp_W + 1;
                end
            end
        end
        if tmp_N2 < tmp_W
            output_rule4 = 1;  %rule9;
        else
            output_rule4 = 0;  %rule8;
        end

    end
end
%}
function output_rule5 = rule5(epoch_no)

    %dichotomy
    tmp_N2 = 0;
    tmp_REM = 0;
    if  feat(epoch_no,19) > 0.3 && feat(epoch_no,23) > 0.75 && feat(epoch_no,43) > 0.6 && feat(epoch_no,15) > 0.65 %&& feat(epoch_no,25) > 0.1 && feat(epoch_no,47) > 0.1 && feat(epoch_no,21) > 0.5 && feat(epoch_no,20) > 0.55% rule 5
        output_rule5 = 1;  %rule11;
    else    
        %fuzzy 
        for j = 1 : size(feature_max_min,1)
            if feature_max_min(j,1,2) == 5 || feature_max_min(j,1,2) == 32 || feature_max_min(j,1,2) == 10 || feature_max_min(j,1,2) == 37
                if feat(epoch_no,feature_max_min(j,1,2)) >= feature_max_min(j,2,2)
                    tmp_REM = tmp_REM + 1;
                elseif feature_max_min(j,3,2) < feat(epoch_no,feature_max_min(j,1,2)) < feature_max_min(j,2,2)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2) >= feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2)
                        tmp_N2 = tmp_N2 + feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2) < feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2)
                        tmp_REM = tmp_REM + feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,2)) <= feature_max_min(j,3,2)
                    tmp_N2 = tmp_N2 + 1;
                end
            elseif feature_max_min(j,1,2) == 6 || feature_max_min(j,1,2) == 33
                if feat(epoch_no,feature_max_min(j,1,2)) >= feature_max_min(j,2,2)
                    tmp_N2 = tmp_N2 + 1;
                elseif feature_max_min(j,3,2) < feat(epoch_no,feature_max_min(j,1,2)) < feature_max_min(j,2,2)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2) > feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2)
                        tmp_REM = tmp_REM + feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2) <= feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2)
                        tmp_N2 = tmp_N2 + feature_high(feat(epoch_no,feature_max_min(j,1,2)),feature_max_min(j,1,2),2);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,2)) <= feature_max_min(j,3,2)
                    tmp_REM = tmp_REM + 1;
                end
            end
        end
        if tmp_N2 < tmp_REM
            output_rule5 = 0;  %rule10;
        else
            output_rule5 = 1;  %rule11;
        end
    end
end
function rule6(epoch_no)
    tmp_N2 = 0;
    tmp_N3 = 0;

    for j = 1 : size(feature_max_min,1)
        if feature_max_min(j,1,1) == 1 || feature_max_min(j,1,1) == 28 || feature_max_min(j,1,1) == 20 || feature_max_min(j,1,1) == 44 || feature_max_min(j,1,1) == 36
            if feat(epoch_no,feature_max_min(j,1,1)) >= feature_max_min(j,2,1)
                tmp_N3 = tmp_N3 + 1;
            elseif feature_max_min(j,3,1) < feat(epoch_no,feature_max_min(j,1,1)) < feature_max_min(j,2,1)
                if feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1) >= feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1)
                    tmp_N2 = tmp_N2 + feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1);
                elseif feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1) < feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1)
                    tmp_N3 = tmp_N3 + feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1);
                end
            elseif feat(epoch_no,feature_max_min(j,1,1)) <= feature_max_min(j,3,1)
                tmp_N2 = tmp_N2 + 1;
            end
        elseif feature_max_min(j,1,1) == 31 || feature_max_min(j,1,1) == 11
            if feat(epoch_no,feature_max_min(j,1,1)) >= feature_max_min(j,2,1)
                tmp_N2 = tmp_N2 + 1;
            elseif feature_max_min(j,3,1) < feat(epoch_no,feature_max_min(j,1,1)) < feature_max_min(j,2,1)
                if feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1) > feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1)
                    tmp_N3 = tmp_N3 + feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1);
                elseif feature_low(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1) <= feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1)
                    tmp_N2 = tmp_N2 + feature_high(feat(epoch_no,feature_max_min(j,1,1)),feature_max_min(j,1,1),1);
                end
            elseif feat(epoch_no,feature_max_min(j,1,1)) <= feature_max_min(j,3,1)
                tmp_N3 = tmp_N3 + 1;
            end
        end
    end
    if tmp_N2 < tmp_N3
         auto_staging(epoch_no) = 9;
    else
         auto_staging(epoch_no) = 10; 
    end        

end
%{
function output_rule7 = rule7(epoch_no)

    %dichotomy
    tmp_N2 = 0;
    tmp_REM = 0;
    if feat(epoch_no,19) > 0.3 && feat(epoch_no,43) > 0.6 && feat(epoch_no,25) > 0.1 && feat(epoch_no,47) > 0.1 && feat(epoch_no,15) > 0.65 && feat(epoch_no,21) > 0.5 && feat(epoch_no,20) > 0.55 && feat(epoch_no,23) > 0.75 % rule 5
        output_rule7 = 1;
    else    
        %fuzzy 
        for j = 1 : size(feature_max_min,1)
            if feature_max_min(j,1,3) == 5 || feature_max_min(j,1,3) == 32 || feature_max_min(j,1,3) == 10 || feature_max_min(j,1,3) == 37
                if feat(epoch_no,feature_max_min(j,1,3)) >= feature_max_min(j,2,3)
                    tmp_REM = tmp_REM + 1;
                elseif feature_max_min(j,3,3) < feat(epoch_no,feature_max_min(j,1,3)) < feature_max_min(j,2,3)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) >= feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_N2 = tmp_N2 + feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) < feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_REM = tmp_REM + feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,3)) <= feature_max_min(j,3,3)
                    tmp_N2 = tmp_N2 + 1;
                end
            elseif feature_max_min(j,1,3) == 6 || feature_max_min(j,1,3) == 33
                if feat(epoch_no,feature_max_min(j,1,3)) >= feature_max_min(j,2,3)
                    tmp_N2 = tmp_N2 + 1;
                elseif feature_max_min(j,3,3) < feat(epoch_no,feature_max_min(j,1,3)) < feature_max_min(j,2,3)
                    if feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) > feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_REM = tmp_REM + feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    elseif feature_low(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3) <= feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3)
                        tmp_N2 = tmp_N2 + feature_high(feat(epoch_no,feature_max_min(j,1,3)),feature_max_min(j,1,3),3);
                    end
                elseif feat(epoch_no,feature_max_min(j,1,3)) <= feature_max_min(j,3,3)
                    tmp_REM = tmp_REM + 1;
                end
            end
        end
        if tmp_N2 < tmp_REM
            output_rule7 = 0;  %rule10;
        else
            output_rule7 = 1;  %rule11;
        end
    end
end
%}
for epoch_no = 1:length(feat)
    set_Mov = 0;
    %%%  Mov staging  %%%
    if epoch_no == 1
        if feat(epoch_no,21) > 0.9
            auto_staging(epoch_no) = -2;
            set_Mov = 1;
        end
    else
        if feat(epoch_no,21) > 0.9 | (feat(epoch_no,21) - feat(epoch_no-1,21)) > 0.33 | (feat(epoch_no,17) - feat(epoch_no-1,17)) > 0.33
            auto_staging(epoch_no) = -2;
            set_Mov = 1;
        end
    end
    %%%  non-Mov staging  %%%
    if set_Mov == 0
        if feat(epoch_no,10) > 0.2 && feat(epoch_no,18) > 0.83 && feat(epoch_no,31) > 0.4 && feat(epoch_no,32) > 0.3 && feat(epoch_no,37) > 0.3 && feat(epoch_no,42) > 0.51  % pro_alpha = 1 , rule 1
            if feat(epoch_no,8) > 0.1 && feat(epoch_no,15) > 0.3 && feat(epoch_no,18) > 0.84 && feat(epoch_no,21) > 0.05 && feat(epoch_no,35) > 0.2% rule 2
                if feat(epoch_no,4) < 0.4  %rule 4(N2)
                    if feat(epoch_no,23) < 0.12 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 8
                        auto_staging(epoch_no) = 1; 
                    else
                        auto_staging(epoch_no) = 2; 
                    end
                else
                    if feat(epoch_no,5) < 0.5 && feat(epoch_no,15) < 0.95 && feat(epoch_no,16) < 0.97 && feat(epoch_no,21) < 0.75 && feat(epoch_no,32) < 0.6 && feat(epoch_no,37) < 0.8  %rule 4
                        if feat(epoch_no,23) < 0.12 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 8
                            auto_staging(epoch_no) = 1; 
                        else
                            auto_staging(epoch_no) = 2; 
                        end
                    else  %rule9;
                        if feat(epoch_no,8) >  0.17 && feat(epoch_no,12) >  0.01 && feat(epoch_no,15) >  0.2 && feat(epoch_no,39) >  0.01   %rule 9
                            auto_staging(epoch_no) = 3;
                        else
                            auto_staging(epoch_no) = 4;
                        end
                    end
                end
            else
                output_rule5 = rule5(epoch_no);
                if output_rule5 == 0  %rule10;
                    if feat(epoch_no,15) < 0.7  && feat(epoch_no,16) > 0.01 && feat(epoch_no,21) < 0.5 && feat(epoch_no,22) < 0.4 %  rule 10
                        auto_staging(epoch_no) = 5;
                    else
                        auto_staging(epoch_no) = 6;
                    end
                else  %rule11;
                    if feat(epoch_no,23) < 0.3 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 11
                        auto_staging(epoch_no) = 7; 
                    else
                        auto_staging(epoch_no) = 8; 
                    end
                end
            end
        else  % pro_alpha = 2
            if feat(epoch_no,1) > 0.59 && feat(epoch_no,5) < 0.2 && feat(epoch_no,4) < 0.4 && feat(epoch_no,31) < 0.6% rule3
                rule6(epoch_no);
            else
                if feat(epoch_no,5) > 0.19  && feat(epoch_no,10) > 0.51 && feat(epoch_no,37) > 0.43 && feat(epoch_no,6) < 0.33 && feat(epoch_no,20) < 0.2 && feat(epoch_no,23) < 0.25 && feat(epoch_no,25) < 0.3 && feat(epoch_no,27) < 0.6 && feat(epoch_no,49) < 0.3 % rule 7
                    if feat(epoch_no,15) < 0.7  && feat(epoch_no,16) > 0.01 && feat(epoch_no,21) < 0.15 && feat(epoch_no,22) < 0.4 %  rule 12
                        auto_staging(epoch_no) = 11; 
                    else
                        auto_staging(epoch_no) = 12; 
                    end

                else  %rule13;
                    if feat(epoch_no,1) < 0.38 && feat(epoch_no,23) < 0.05 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 13
                        auto_staging(epoch_no) = 13;
                    else
                        auto_staging(epoch_no) = 14;
                    end
                end
            end       
        end
    end
end

%% cal accuracy
    %%%  人工判讀為 wake
    nn_result(1,1) = sum(human_sco == 0 & auto_staging == 1);
    nn_result(2,1) = sum(human_sco == 0 & auto_staging == 2);
    nn_result(3,1) = sum(human_sco == 0 & auto_staging == 3);
    nn_result(4,1) = sum(human_sco == 0 & auto_staging == 4);
    nn_result(5,1) = sum(human_sco == 0 & auto_staging == 5);
    nn_result(6,1) = sum(human_sco == 0 & auto_staging == 6);
    nn_result(7,1) = sum(human_sco == 0 & auto_staging == 7);
    nn_result(8,1) = sum(human_sco == 0 & auto_staging == 8);
    nn_result(9,1) = sum(human_sco == 0 & auto_staging == 9);
    nn_result(10,1) = sum(human_sco == 0 & auto_staging == 10);
    nn_result(11,1) = sum(human_sco == 0 & auto_staging == 11);
    nn_result(12,1) = sum(human_sco == 0 & auto_staging == 12);
    nn_result(13,1) = sum(human_sco == 0 & auto_staging == 13);
    nn_result(14,1) = sum(human_sco == 0 & auto_staging == 14);
    nn_result(15,1) = sum(human_sco == 0 & auto_staging == -2);
    
    %%%  人工判讀為 n1
    nn_result(1,2) = sum(human_sco == 1 & auto_staging == 1);
    nn_result(2,2) = sum(human_sco == 1 & auto_staging == 2);
    nn_result(3,2) = sum(human_sco == 1 & auto_staging == 3);
    nn_result(4,2) = sum(human_sco == 1 & auto_staging == 4);
    nn_result(5,2) = sum(human_sco == 1 & auto_staging == 5);
    nn_result(6,2) = sum(human_sco == 1 & auto_staging == 6);
    nn_result(7,2) = sum(human_sco == 1 & auto_staging == 7);
    nn_result(8,2) = sum(human_sco == 1 & auto_staging == 8);
    nn_result(9,2) = sum(human_sco == 1 & auto_staging == 9);
    nn_result(10,2) = sum(human_sco == 1 & auto_staging == 10);
    nn_result(11,2) = sum(human_sco == 1 & auto_staging == 11);
    nn_result(12,2) = sum(human_sco == 1 & auto_staging == 12);
    nn_result(13,2) = sum(human_sco == 1 & auto_staging == 13);
    nn_result(14,2) = sum(human_sco == 1 & auto_staging == 14);  
    nn_result(15,2) = sum(human_sco == 1 & auto_staging == -2);
    %%%  人工判讀為 n2
    nn_result(1,3) = sum(human_sco == 2 & auto_staging == 1);
    nn_result(2,3) = sum(human_sco == 2 & auto_staging == 2);
    nn_result(3,3) = sum(human_sco == 2 & auto_staging == 3);
    nn_result(4,3) = sum(human_sco == 2 & auto_staging == 4);
    nn_result(5,3) = sum(human_sco == 2 & auto_staging == 5);
    nn_result(6,3) = sum(human_sco == 2 & auto_staging == 6);
    nn_result(7,3) = sum(human_sco == 2 & auto_staging == 7);
    nn_result(8,3) = sum(human_sco == 2 & auto_staging == 8);
    nn_result(9,3) = sum(human_sco == 2 & auto_staging == 9);
    nn_result(10,3) = sum(human_sco == 2 & auto_staging == 10);
    nn_result(11,3) = sum(human_sco == 2 & auto_staging == 11);
    nn_result(12,3) = sum(human_sco == 2 & auto_staging == 12);
    nn_result(13,3) = sum(human_sco == 2 & auto_staging == 13);
    nn_result(14,3) = sum(human_sco == 2 & auto_staging == 14);
    nn_result(15,3) = sum(human_sco == 2 & auto_staging == -2);
    %%%  人工判讀為 n3
    nn_result(1,4) = sum(human_sco == 3 & auto_staging == 1);
    nn_result(2,4) = sum(human_sco == 3 & auto_staging == 2);
    nn_result(3,4) = sum(human_sco == 3 & auto_staging == 3);
    nn_result(4,4) = sum(human_sco == 3 & auto_staging == 4);
    nn_result(5,4) = sum(human_sco == 3 & auto_staging == 5);
    nn_result(6,4) = sum(human_sco == 3 & auto_staging == 6);
    nn_result(7,4) = sum(human_sco == 3 & auto_staging == 7);
    nn_result(8,4) = sum(human_sco == 3 & auto_staging == 8);
    nn_result(9,4) = sum(human_sco == 3 & auto_staging == 9);
    nn_result(10,4) = sum(human_sco == 3 & auto_staging == 10);
    nn_result(11,4) = sum(human_sco == 3 & auto_staging == 11);
    nn_result(12,4) = sum(human_sco == 3 & auto_staging == 12);
    nn_result(13,4) = sum(human_sco == 3 & auto_staging == 13);
    nn_result(14,4) = sum(human_sco == 3 & auto_staging == 14);
    nn_result(15,4) = sum(human_sco == 3 & auto_staging == -2);
    %%%  人工判讀為 REM
    nn_result(1,5) = sum(human_sco == 4 & auto_staging == 1);
    nn_result(2,5) = sum(human_sco == 4 & auto_staging == 2);
    nn_result(3,5) = sum(human_sco == 4 & auto_staging == 3);
    nn_result(4,5) = sum(human_sco == 4 & auto_staging == 4);
    nn_result(5,5) = sum(human_sco == 4 & auto_staging == 5);
    nn_result(6,5) = sum(human_sco == 4 & auto_staging == 6);
    nn_result(7,5) = sum(human_sco == 4 & auto_staging == 7);
    nn_result(8,5) = sum(human_sco == 4 & auto_staging == 8);
    nn_result(9,5) = sum(human_sco == 4 & auto_staging == 9);
    nn_result(10,5) = sum(human_sco == 4 & auto_staging == 10);
    nn_result(11,5) = sum(human_sco == 4 & auto_staging == 11);
    nn_result(12,5) = sum(human_sco == 4 & auto_staging == 12);
    nn_result(13,5) = sum(human_sco == 4 & auto_staging == 13);
    nn_result(14,5) = sum(human_sco == 4 & auto_staging == 14);
    nn_result(15,5) = sum(human_sco == 4 & auto_staging == -2);
    %%%  人工判讀為 arti
    nn_result(1,6) = sum(human_sco == 5 & auto_staging == 1);
    nn_result(2,6) = sum(human_sco == 5 & auto_staging == 2);
    nn_result(3,6) = sum(human_sco == 5 & auto_staging == 3);
    nn_result(4,6) = sum(human_sco == 5 & auto_staging == 4);
    nn_result(5,6) = sum(human_sco == 5 & auto_staging == 5);
    nn_result(6,6) = sum(human_sco == 5 & auto_staging == 6);
    nn_result(7,6) = sum(human_sco == 5 & auto_staging == 7);
    nn_result(8,6) = sum(human_sco == 5 & auto_staging == 8);
    nn_result(9,6) = sum(human_sco == 5 & auto_staging == 9);
    nn_result(10,6) = sum(human_sco == 5 & auto_staging == 10);
    nn_result(11,6) = sum(human_sco == 5 & auto_staging == 11);
    nn_result(12,6) = sum(human_sco == 5 & auto_staging == 12);
    nn_result(13,6) = sum(human_sco == 5 & auto_staging == 13);
    nn_result(14,6) = sum(human_sco == 5 & auto_staging == 14);
    nn_result(15,6) = sum(human_sco == 5 & auto_staging == -2);


    %%  5-staged automatic staging accuracy  %%
    pos_wake_1 = find(auto_staging == 3);
    
    pos_n1_1 = find(auto_staging == 1);
    pos_n1_2 = find(auto_staging == 4);
    pos_n1_3 = find(auto_staging == 6);
    pos_n1_4 = find(auto_staging == 7);
    pos_n1_5 = find(auto_staging == 12);
    pos_n1_6 = find(auto_staging == 13);
    
    pos_n2_1 = find(auto_staging == 2);
    pos_n2_2 = find(auto_staging == 8);
    pos_n2_3 = find(auto_staging == 10);
    pos_n2_4 = find(auto_staging == 14);
    
    pos_n3_1 = find(auto_staging == 9);
    
    pos_REM_1 = find(auto_staging == 5);
    pos_REM_2 = find(auto_staging == 11);
    
    pos_Mov_1 = find(auto_staging == -2);
    
    
    
    auto_staging(pos_wake_1) = 0.3;
    
    auto_staging(pos_n1_1) = 1.1;
    auto_staging(pos_n1_2) = 1.4;
    auto_staging(pos_n1_3) = 1.6;
    auto_staging(pos_n1_4) = 1.7;
    auto_staging(pos_n1_5) = 1.12;
    auto_staging(pos_n1_6) = 1.13;
    
    auto_staging(pos_n2_1) = 2.2;
    auto_staging(pos_n2_2) = 2.8;
    auto_staging(pos_n2_3) = 2.10;
    auto_staging(pos_n2_4) = 2.14;
    
    auto_staging(pos_n3_1) = 3.9;
    
    auto_staging(pos_REM_1) = 4.5;
    auto_staging(pos_REM_2) = 4.11;
    
    auto_staging(pos_Mov_1) = 5;

    %%  Smoothing  %%%
    auto_staging_mod1 = auto_staging; % without smoothing
%     auto_staging_mod1 = post_staging(auto_staging_mod1);
   auto_staging_mod1 = post_staging2(auto_staging_mod1,feat); % with smoothing
    %auto_staging_mod1 = post_staging(auto_staging_mod1); % with smoothing
    
    %% Movement Smoothing %%   
    auto_staging = mov_rej_v10(auto_staging); % without smoothing
    auto_staging_mod1 = mov_rej_v10(auto_staging_mod1); % with smoothing
    
    nodestage_result = [auto_staging, auto_staging_mod1];
    csvwrite([nodestageDir,'node_stage_',filename(1:end),'.dat'],nodestage_result);
    
   %% Recover %%
    auto_staging(pos_wake_1) = 0;
    
    auto_staging(pos_n1_1) = 1;
    auto_staging(pos_n1_2) = 1;
    auto_staging(pos_n1_3) = 1;
    auto_staging(pos_n1_4) = 1;
    auto_staging(pos_n1_5) = 1;
    auto_staging(pos_n1_6) = 1;
    
    auto_staging(pos_n2_1) = 2;
    auto_staging(pos_n2_2) = 2;
    auto_staging(pos_n2_3) = 2;
    auto_staging(pos_n2_4) = 2;
    
    auto_staging(pos_n3_1) = 3;
    
  
    auto_staging(pos_REM_1) = 4;
    auto_staging(pos_REM_2) = 4;
    
    auto_staging(pos_Mov_1) =5;
    %%  Smoothing  %%%
    auto_staging_mod1 = auto_staging; % without smoothing
    auto_staging_mod1 = post_staging2(auto_staging_mod1,feat); % with smoothing
    %auto_staging_mod1 = post_staging(auto_staging_mod1); % with smoothing
    
    %% Movement Smoothing %%   
    auto_staging = mov_rej_v10(auto_staging); % without smoothing
    auto_staging_mod1 = mov_rej_v10(auto_staging_mod1); % with smoothing
    csvwrite([AutostageDir,'auto_',filename(1:end),'.dat'],auto_staging_mod1);
    human_sco2 = mov_rej(human_sco); % human smoothing
    
    stage_result = [human_sco2, auto_staging, auto_staging_mod1];
    csvwrite([AllstageDir,'allstage_',filename(1:end),'.dat'],stage_result);
    

    %%  fault pos  %%
    pos_REM_n2 = find(auto_staging_mod1 == 2 & human_sco == 4);
    pos_n2_REM = find(auto_staging_mod1 == 4 & human_sco == 2);
    pos_wake_REM = find(auto_staging_mod1 == 4 & human_sco == 0);
    pos_wake_n2 = find(auto_staging_mod1 == 2 & human_sco == 0);
    pos_wake_n1 = find(auto_staging_mod1 == 1 & human_sco == 0);
    pos_s1_wake = find(auto_staging_mod1 == 0 & human_sco == 1);
    pos_s1_SWS = find(auto_staging_mod1 == 3 & human_sco == 1);
    
    %%  plotting pos %%
    
    pos_REM_hu = find( human_sco == 4);
    pos_n1_hu = find( human_sco == 1);
    pos_n2_hu = find( human_sco == 2);
    pos_n3_hu = find( human_sco == 3);
    pos_mov_hu = find( human_sco == 5);
  
    pos_REM_auto = find( auto_staging == 4);
    pos_n1_auto = find( auto_staging == 1);
    pos_n2_auto = find( auto_staging == 2);
    pos_n3_auto = find( auto_staging == 3);
    pos_mov_auto = find( auto_staging == 5);
  
    pos_REM_auto = find( auto_staging_mod1 == 4);
    pos_n1_auto = find( auto_staging_mod1 == 1);
    pos_n2_auto = find( auto_staging_mod1 == 2);
    pos_n3_auto = find( auto_staging_mod1 == 3);
    pos_mov_auto = find( auto_staging_mod1 == 5);

    %% without smoothing %%
    %%%  人工判讀為 wake       
    nn_fi_result(1,1) = sum(human_sco == 0 & auto_staging == 0);
    nn_fi_result(2,1) = sum(human_sco == 0 & auto_staging == 1);
    nn_fi_result(3,1) = sum(human_sco == 0 & auto_staging == 2);
    nn_fi_result(4,1) = sum(human_sco == 0 & auto_staging == 3);
    nn_fi_result(5,1) = sum(human_sco == 0 & auto_staging == 4);
    nn_fi_result(6,1) = sum(human_sco == 0 & auto_staging == 5);
    %%%  人工判讀為 n1
    nn_fi_result(1,2) = sum(human_sco == 1 & auto_staging == 0);
    nn_fi_result(2,2) = sum(human_sco == 1 & auto_staging == 1);
    nn_fi_result(3,2) = sum(human_sco == 1 & auto_staging == 2);
    nn_fi_result(4,2) = sum(human_sco == 1 & auto_staging == 3);
    nn_fi_result(5,2) = sum(human_sco == 1 & auto_staging == 4);
    nn_fi_result(6,2) = sum(human_sco == 1 & auto_staging == 5);
    %%%  人工判讀為 n2
    nn_fi_result(1,3) = sum(human_sco == 2 & auto_staging == 0);
    nn_fi_result(2,3) = sum(human_sco == 2 & auto_staging == 1);
    nn_fi_result(3,3) = sum(human_sco == 2 & auto_staging == 2);
    nn_fi_result(4,3) = sum(human_sco == 2 & auto_staging == 3);
    nn_fi_result(5,3) = sum(human_sco == 2 & auto_staging == 4);
    nn_fi_result(6,3) = sum(human_sco == 2 & auto_staging == 5);
    %%%  人工判讀為 n3
    nn_fi_result(1,4) = sum(human_sco == 3 & auto_staging == 0);
    nn_fi_result(2,4) = sum(human_sco == 3 & auto_staging == 1);
    nn_fi_result(3,4) = sum(human_sco == 3 & auto_staging == 2);
    nn_fi_result(4,4) = sum(human_sco == 3 & auto_staging == 3);
    nn_fi_result(5,4) = sum(human_sco == 3 & auto_staging == 4);
    nn_fi_result(6,4) = sum(human_sco == 3 & auto_staging == 5);
    %%%  人工判讀為 REM
    nn_fi_result(1,5) = sum(human_sco == 4 & auto_staging == 0);
    nn_fi_result(2,5) = sum(human_sco == 4 & auto_staging == 1);
    nn_fi_result(3,5) = sum(human_sco == 4 & auto_staging == 2);
    nn_fi_result(4,5) = sum(human_sco == 4 & auto_staging == 3);
    nn_fi_result(5,5) = sum(human_sco == 4 & auto_staging == 4);
    nn_fi_result(6,5) = sum(human_sco == 4 & auto_staging == 5);
    %%%  人工判讀為 arti
    nn_fi_result(1,6) = sum(human_sco == 5 & auto_staging == 0);
    nn_fi_result(2,6) = sum(human_sco == 5 & auto_staging == 1);
    nn_fi_result(3,6) = sum(human_sco == 5 & auto_staging == 2);
    nn_fi_result(4,6) = sum(human_sco == 5 & auto_staging == 3);
    nn_fi_result(5,6) = sum(human_sco == 5 & auto_staging == 4);
    nn_fi_result(6,6) = sum(human_sco == 5 & auto_staging == 5);
    
        %% with smoothing %%
    %%%  人工判讀為 wake       
    nn_fi_mod1_result(1,1) = sum(human_sco == 0 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,1) = sum(human_sco == 0 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,1) = sum(human_sco == 0 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,1) = sum(human_sco == 0 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,1) = sum(human_sco == 0 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,1) = sum(human_sco == 0 & auto_staging_mod1 == 5);
    %%%  人工判讀為 n1
    nn_fi_mod1_result(1,2) = sum(human_sco == 1 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,2) = sum(human_sco == 1 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,2) = sum(human_sco == 1 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,2) = sum(human_sco == 1 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,2) = sum(human_sco == 1 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,2) = sum(human_sco == 1 & auto_staging_mod1 == 5);
    %%%  人工判讀為 n2
    nn_fi_mod1_result(1,3) = sum(human_sco == 2 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,3) = sum(human_sco == 2 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,3) = sum(human_sco == 2 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,3) = sum(human_sco == 2 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,3) = sum(human_sco == 2 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,3) = sum(human_sco == 2 & auto_staging_mod1 == 5);
    %%%  人工判讀為 n3
    nn_fi_mod1_result(1,4) = sum(human_sco == 3 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,4) = sum(human_sco == 3 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,4) = sum(human_sco == 3 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,4) = sum(human_sco == 3 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,4) = sum(human_sco == 3 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,4) = sum(human_sco == 3 & auto_staging_mod1 == 5);
    %%%  人工判讀為 REM
    nn_fi_mod1_result(1,5) = sum(human_sco == 4 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,5) = sum(human_sco == 4 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,5) = sum(human_sco == 4 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,5) = sum(human_sco == 4 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,5) = sum(human_sco == 4 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,5) = sum(human_sco == 4 & auto_staging_mod1 == 5);
    %%%  人工判讀為 arti
    nn_fi_mod1_result(1,6) = sum(human_sco == 5 & auto_staging_mod1 == 0);
    nn_fi_mod1_result(2,6) = sum(human_sco == 5 & auto_staging_mod1 == 1);
    nn_fi_mod1_result(3,6) = sum(human_sco == 5 & auto_staging_mod1 == 2);
    nn_fi_mod1_result(4,6) = sum(human_sco == 5 & auto_staging_mod1 == 3);
    nn_fi_mod1_result(5,6) = sum(human_sco == 5 & auto_staging_mod1 == 4);
    nn_fi_mod1_result(6,6) = sum(human_sco == 5 & auto_staging_mod1 == 5);
    
       %% without smoothing %%
    %%%  人工判讀為 wake       
    nn_ratio_result(1,1) = sum(human_sco == 0 & auto_staging == 0)./sum(human_sco == 0).* 100;
    nn_ratio_result(2,1) = sum(human_sco == 0 & auto_staging == 1)./sum(human_sco == 0).* 100;
    nn_ratio_result(3,1) = sum(human_sco == 0 & auto_staging == 2)./sum(human_sco == 0).* 100;
    nn_ratio_result(4,1) = sum(human_sco == 0 & auto_staging == 3)./sum(human_sco == 0).* 100;
    nn_ratio_result(5,1) = sum(human_sco == 0 & auto_staging == 4)./sum(human_sco == 0).* 100;
    nn_ratio_result(6,1) = sum(human_sco == 0 & auto_staging == 5)./sum(human_sco == 0).* 100;
    %%%  人工判讀為 n1
    nn_ratio_result(1,2) = sum(human_sco == 1 & auto_staging == 0)./sum(human_sco == 1).* 100;
    nn_ratio_result(2,2) = sum(human_sco == 1 & auto_staging == 1)./sum(human_sco == 1).* 100;
    nn_ratio_result(3,2) = sum(human_sco == 1 & auto_staging == 2)./sum(human_sco == 1).* 100;
    nn_ratio_result(4,2) = sum(human_sco == 1 & auto_staging == 3)./sum(human_sco == 1).* 100;
    nn_ratio_result(5,2) = sum(human_sco == 1 & auto_staging == 4)./sum(human_sco == 1).* 100;
    nn_ratio_result(6,2) = sum(human_sco == 1 & auto_staging == 5)./sum(human_sco == 1).* 100;
    %%%  人工判讀為 n2
    nn_ratio_result(1,3) = sum(human_sco == 2 & auto_staging == 0)./sum(human_sco == 2).* 100;
    nn_ratio_result(2,3) = sum(human_sco == 2 & auto_staging == 1)./sum(human_sco == 2).* 100;
    nn_ratio_result(3,3) = sum(human_sco == 2 & auto_staging == 2)./sum(human_sco == 2).* 100;
    nn_ratio_result(4,3) = sum(human_sco == 2 & auto_staging == 3)./sum(human_sco == 2).* 100;
    nn_ratio_result(5,3) = sum(human_sco == 2 & auto_staging == 4)./sum(human_sco == 2).* 100;
    nn_ratio_result(6,3) = sum(human_sco == 2 & auto_staging == 5)./sum(human_sco == 2).* 100;
    %%%  人工判讀為 n3
    nn_ratio_result(1,4) = sum(human_sco == 3 & auto_staging == 0)./sum(human_sco == 3).* 100;
    nn_ratio_result(2,4) = sum(human_sco == 3 & auto_staging == 1)./sum(human_sco == 3).* 100;
    nn_ratio_result(3,4) = sum(human_sco == 3 & auto_staging == 2)./sum(human_sco == 3).* 100;
    nn_ratio_result(4,4) = sum(human_sco == 3 & auto_staging == 3)./sum(human_sco == 3).* 100;
    nn_ratio_result(5,4) = sum(human_sco == 3 & auto_staging == 4)./sum(human_sco == 3).* 100;
    nn_ratio_result(6,4) = sum(human_sco == 3 & auto_staging == 5)./sum(human_sco == 3).* 100;
    %%%  人工判讀為 REM
    nn_ratio_result(1,5) = sum(human_sco == 4 & auto_staging == 0)./sum(human_sco == 4).* 100;
    nn_ratio_result(2,5) = sum(human_sco == 4 & auto_staging == 1)./sum(human_sco == 4).* 100;
    nn_ratio_result(3,5) = sum(human_sco == 4 & auto_staging == 2)./sum(human_sco == 4).* 100;
    nn_ratio_result(4,5) = sum(human_sco == 4 & auto_staging == 3)./sum(human_sco == 4).* 100;
    nn_ratio_result(5,5) = sum(human_sco == 4 & auto_staging == 4)./sum(human_sco == 4).* 100;
    nn_ratio_result(6,5) = sum(human_sco == 4 & auto_staging == 5)./sum(human_sco == 4).* 100;
    %%%  人工判讀為 arti
    nn_ratio_result(1,6) = sum(human_sco == 5 & auto_staging == 0)./sum(human_sco == 5).* 100;
    nn_ratio_result(2,6) = sum(human_sco == 5 & auto_staging == 1)./sum(human_sco == 5).* 100;
    nn_ratio_result(3,6) = sum(human_sco == 5 & auto_staging == 2)./sum(human_sco == 5).* 100;
    nn_ratio_result(4,6) = sum(human_sco == 5 & auto_staging == 3)./sum(human_sco == 5).* 100;
    nn_ratio_result(5,6) = sum(human_sco == 5 & auto_staging == 4)./sum(human_sco == 5).* 100;
    nn_ratio_result(6,6) = sum(human_sco == 5 & auto_staging == 5)./sum(human_sco == 5).* 100;
    
      %% with smoothing %%
    %%%  人工判讀為 wake       
    nn_ratio_result_mod1(1,1) = sum(human_sco == 0 & auto_staging_mod1 == 0)./sum(human_sco == 0).* 100;
    nn_ratio_result_mod1(2,1) = sum(human_sco == 0 & auto_staging_mod1 == 1)./sum(human_sco == 0).* 100;
    nn_ratio_result_mod1(3,1) = sum(human_sco == 0 & auto_staging_mod1 == 2)./sum(human_sco == 0).* 100;
    nn_ratio_result_mod1(4,1) = sum(human_sco == 0 & auto_staging_mod1 == 3)./sum(human_sco == 0).* 100;
    nn_ratio_result_mod1(5,1) = sum(human_sco == 0 & auto_staging_mod1 == 4)./sum(human_sco == 0).* 100;
    nn_ratio_result_mod1(6,1) = sum(human_sco == 0 & auto_staging_mod1 == 5)./sum(human_sco == 0).* 100;
    %%%  人工判讀為 n1
    nn_ratio_result_mod1(1,2) = sum(human_sco == 1 & auto_staging_mod1 == 0)./sum(human_sco == 1).* 100;
    nn_ratio_result_mod1(2,2) = sum(human_sco == 1 & auto_staging_mod1 == 1)./sum(human_sco == 1).* 100;
    nn_ratio_result_mod1(3,2) = sum(human_sco == 1 & auto_staging_mod1 == 2)./sum(human_sco == 1).* 100;
    nn_ratio_result_mod1(4,2) = sum(human_sco == 1 & auto_staging_mod1 == 3)./sum(human_sco == 1).* 100;
    nn_ratio_result_mod1(5,2) = sum(human_sco == 1 & auto_staging_mod1 == 4)./sum(human_sco == 1).* 100;
    nn_ratio_result_mod1(6,2) = sum(human_sco == 1 & auto_staging_mod1 == 5)./sum(human_sco == 1).* 100;
    %%%  人工判讀為 n2
    nn_ratio_result_mod1(1,3) = sum(human_sco == 2 & auto_staging_mod1 == 0)./sum(human_sco == 2).* 100;
    nn_ratio_result_mod1(2,3) = sum(human_sco == 2 & auto_staging_mod1 == 1)./sum(human_sco == 2).* 100;
    nn_ratio_result_mod1(3,3) = sum(human_sco == 2 & auto_staging_mod1 == 2)./sum(human_sco == 2).* 100;
    nn_ratio_result_mod1(4,3) = sum(human_sco == 2 & auto_staging_mod1 == 3)./sum(human_sco == 2).* 100;
    nn_ratio_result_mod1(5,3) = sum(human_sco == 2 & auto_staging_mod1 == 4)./sum(human_sco == 2).* 100;
    nn_ratio_result_mod1(6,3) = sum(human_sco == 2 & auto_staging_mod1 == 5)./sum(human_sco == 2).* 100;
    %%%  人工判讀為 n3
    nn_ratio_result_mod1(1,4) = sum(human_sco == 3 & auto_staging_mod1 == 0)./sum(human_sco == 3).* 100;
    nn_ratio_result_mod1(2,4) = sum(human_sco == 3 & auto_staging_mod1 == 1)./sum(human_sco == 3).* 100;
    nn_ratio_result_mod1(3,4) = sum(human_sco == 3 & auto_staging_mod1 == 2)./sum(human_sco == 3).* 100;
    nn_ratio_result_mod1(4,4) = sum(human_sco == 3 & auto_staging_mod1 == 3)./sum(human_sco == 3).* 100;
    nn_ratio_result_mod1(5,4) = sum(human_sco == 3 & auto_staging_mod1 == 4)./sum(human_sco == 3).* 100;
    nn_ratio_result_mod1(6,4) = sum(human_sco == 3 & auto_staging_mod1 == 5)./sum(human_sco == 3).* 100;
    %%%  人工判讀為 REM
    nn_ratio_result_mod1(1,5) = sum(human_sco == 4 & auto_staging_mod1 == 0)./sum(human_sco == 4).* 100;
    nn_ratio_result_mod1(2,5) = sum(human_sco == 4 & auto_staging_mod1 == 1)./sum(human_sco == 4).* 100;
    nn_ratio_result_mod1(3,5) = sum(human_sco == 4 & auto_staging_mod1 == 2)./sum(human_sco == 4).* 100;
    nn_ratio_result_mod1(4,5) = sum(human_sco == 4 & auto_staging_mod1 == 3)./sum(human_sco == 4).* 100;
    nn_ratio_result_mod1(5,5) = sum(human_sco == 4 & auto_staging_mod1 == 4)./sum(human_sco == 4).* 100;
    nn_ratio_result_mod1(6,5) = sum(human_sco == 4 & auto_staging_mod1 == 5)./sum(human_sco == 4).* 100;
    %%%  人工判讀為 arti
    nn_ratio_result_mod1(1,6) = sum(human_sco == 5 & auto_staging_mod1 == 0)./sum(human_sco == 5).* 100;
    nn_ratio_result_mod1(2,6) = sum(human_sco == 5 & auto_staging_mod1 == 1)./sum(human_sco == 5).* 100;
    nn_ratio_result_mod1(3,6) = sum(human_sco == 5 & auto_staging_mod1 == 2)./sum(human_sco == 5).* 100;
    nn_ratio_result_mod1(4,6) = sum(human_sco == 5 & auto_staging_mod1 == 3)./sum(human_sco == 5).* 100;
    nn_ratio_result_mod1(5,6) = sum(human_sco == 5 & auto_staging_mod1 == 4)./sum(human_sco == 5).* 100;
    nn_ratio_result_mod1(6,6) = sum(human_sco == 5 & auto_staging_mod1 == 5)./sum(human_sco == 5).* 100;
    
    mov_stage = find(human_sco == 5 | auto_staging_mod1 == 5);
    RJratio = length(mov_stage)/epoch_no*100;

    %%  non-artifact  %%
    result_med = nn_fi_result(1:5,1:5);
    result_med_sum = sum(result_med);
    for stage_i = 1:5
        ratio_result_med(:,stage_i) = result_med(:,stage_i) / result_med_sum(stage_i);
    end
    ratio_result_med = ratio_result_med' .*100;
    result_before = result_med';
    
    result_final = nn_fi_mod1_result(1:5,1:5);
    result_final_sum = sum(result_final);                   %print epoch total num
    result_cor = result_final(1,1) + result_final(2,2) + result_final(3,3) + result_final(4,4) + result_final(5,5) ;
    result_accu = result_cor / sum(result_final_sum) * 100;
    result_accu = result_accu * 100 - (result_accu * 100 - round(result_accu * 100)); % 保留至小數點後兩位
    result_accu = result_accu/100;
    disp(result_accu)
    for stage_i = 1:5
        ratio_result_final(:,stage_i) = result_final(:,stage_i) / result_final_sum(stage_i);
    end
    result_final = result_final';                            %print confusion matrix
    ratio_result_final = ratio_result_final .*100;
    ratio_result_final_2 = ratio_result_final' ;
    ratio_result_final_2 = ratio_result_final_2 .* 100 - (ratio_result_final_2 .* 100 - round(ratio_result_final_2 .* 100)); % 保留至小數點後兩位
    ratio_result_final_2 = ratio_result_final_2/100; 
    ratio_result_seq = zeros(1,5);
    for stage_seq = 1:5
        ratio_result_seq(stage_seq) = ratio_result_final_2(stage_seq,stage_seq);
    end
    disp(ratio_result_seq)                                   %print each stage agreement

    nn_fi_result = nn_fi_result';
    nn_fi_mod1_result = nn_fi_mod1_result';
    nn_ratio_result = nn_ratio_result';
    nn_ratio_result_mod1 = nn_ratio_result_mod1';
    nn_ratio_result_mod1 = nn_ratio_result_mod1 .* 100 - (nn_ratio_result_mod1 .* 100 - round(nn_ratio_result_mod1 .* 100)); % 保留至小數點後兩位
    nn_ratio_result_mod1 = nn_ratio_result_mod1/100; 

 %Cohen's Kappa
    Kappa_table = zeros(7,7);
    Kappa_table(1:5,1:5) = result_final;
    for i = 1:5
        Kappa_table(i,6) = sum(Kappa_table(i,1:5));
        Kappa_table(6,i) = sum(Kappa_table(1:5,i));
    end
    Kappa_table(6,6) = sum(Kappa_table(6,1:5));
    for i = 1:5
        Kappa_table(i,7) = Kappa_table(i,6)/Kappa_table(6,6);
        Kappa_table(7,i) = Kappa_table(6,i)/Kappa_table(6,6);
    end
    PrA = result_accu;
    PrE = sum(Kappa_table(7,1:5)'.*Kappa_table(1:5,7));
    Kappa_value = (PrA/100-PrE)/(1-PrE); 

    output = [epoch_no ratio_result_seq result_accu RJratio Kappa_value];
  
toc
end