function [output, result_final, nn_result, result_before, Kappa_value, raw_staging, pred_stage, output_reliab,  pred_stage_reliab, low_reliability] = multi_scale_auto_staging_Siesta_v10_chun(FeatureDir, StageDir, OuputDir)
%% load data %%

result_answer_dir = [OuputDir '\result_answer\'];
if exist(result_answer_dir, 'dir') ~= 7
    mkdir(result_answer_dir);
end

feat = load(fullfile(FeatureDir.folder, FeatureDir.name)); 
hyp = load(fullfile(StageDir.folder,StageDir.name)); 
L = min(length(feat), length(hyp));
feat = feat(1:L, :);

if length(hyp(:, 1)) == 1
    hyp = hyp';
end
hyp = hyp(1:L, :);

W = hyp == 0;
tmp = find(W==0);
SE = length(tmp) / length(hyp);
tmp = find(W(tmp(1):end) == 1);
WASO = length(tmp)/2;

%%  map the feature into 0~1  %%
[row_i,col_j] = size(feat);
for seq_i = 1:col_j
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
auto_staging = zeros(length(feat), 1) - 1;
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
           
function membership = feature_low(new, feature_num, page_num)
    for i = 1 : size(feature_max_min, 1)
        if feature_max_min(i, 1, page_num) == feature_num
            membership = 1 - (new-feature_max_min(i,3,page_num)) / (feature_max_min(i,2,page_num)-feature_max_min(i,3,page_num));
        end
    end
end

function membership = feature_high(new, feature_num, page_num)
    for i = 1 : size(feature_max_min, 1)
        if feature_max_min(i, 1, page_num) == feature_num
            membership = (new-feature_max_min(i,3,page_num)) / (feature_max_min(i,2,page_num)-feature_max_min(i,3,page_num));
        end
    end
end
function output_rule5 = rule5(epoch_no)

    % dichotomy
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
    if feat(epoch_no,23) > 0.55 && feat(epoch_no,27) > 0.20 && feat(epoch_no,49) > 0.34
        auto_staging(epoch_no) = 10;
    else 
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
end

%% 
for epoch_no = 1:length(feat)
    set_Mov = 0;
    %%%  Mov staging  %%%
    if epoch_no == 1
        if feat(epoch_no,21) > 0.9
            auto_staging(epoch_no) = -2;
            set_Mov = 1;
        end
    else
        if feat(epoch_no,21) > 0.9 || (feat(epoch_no,21) - feat(epoch_no-1,21)) > 0.33 || (feat(epoch_no,17) - feat(epoch_no-1,17)) > 0.33
            auto_staging(epoch_no) = -2;
            set_Mov = 1;
        end
    end
    % 好像沒用到
    if feat(epoch_no,50) > 0 && feat(epoch_no,21) > 0.3 %C4F40-30
        auto_staging(epoch_no) = 15; 
        set_Aro=1;
    end
    if  corr(1,2)< 0.4 && feat(epoch_no,51) > 0.5 && feat(epoch_no,21) > 0.15 || ( corr(1,2)< 0.4 &&feat(epoch_no,3) > 0.9 && feat(epoch_no,35) > 0.9) %C4F40-30 %alphaCF>0.9
        auto_staging(epoch_no) = 15; 
        set_Aro=1;
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
                        %if feat(epoch_no,9) >  0.5 && feat(epoch_no,16) >  0.33 && feat(epoch_no,23) >  0.1% 有問題 , rule 9
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
                if feat(epoch_no,19) > 0.06 && feat(epoch_no,43) > 0.06 || feat(epoch_no,23) > 0.19 && feat(epoch_no,45) > 0.19   % rule 7
                    if feat(epoch_no,1) < 0.38 && feat(epoch_no,23) < 0.05 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 13
                        auto_staging(epoch_no) = 13;
                    else
                        auto_staging(epoch_no) = 14;
                    end
                else
                    if feat(epoch_no,5) > 0.19  && feat(epoch_no,10) > 0.51 && feat(epoch_no,37) > 0.43 && feat(epoch_no,6) < 0.33 && feat(epoch_no,20) < 0.2 && feat(epoch_no,23) < 0.25 && feat(epoch_no,25) < 0.3 && feat(epoch_no,27) < 0.6 && feat(epoch_no,49) < 0.3|| feat(epoch_no,51) > 0  % rule 7
                        if feat(epoch_no,15) < 0.7  && feat(epoch_no,16) > 0.01 && feat(epoch_no,21) < 0.15 && feat(epoch_no,22) < 0.4 %  rule 12
                            if feat(epoch_no,51) > 0 && feat(epoch_no,21) < 0.3
                                auto_staging(epoch_no) = 11;
                            else
                                auto_staging(epoch_no) = 16;
                            end
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
end

    %% cal accuracy
    auto_stage_label=[(0:14) -2];
    human_label=(0:5);
    for idx1 = 1:15
        for idx2 = 1:6
            nn_result(idx1,idx2) = sum(human_sco == human_label(idx2) & auto_staging == auto_stage_label(idx1));
        end
    end
    %%  5-staged automatic staging accuracy  %%
    node_only = auto_staging;
    pos_wake_1 = auto_staging == 3;
    pos_wake_2 = auto_staging == 15;
    
    pos_n1_1 = auto_staging == 1;
    pos_n1_2 = auto_staging == 4;
    pos_n1_3 = auto_staging == 6;
    pos_n1_4 = auto_staging == 7;
    pos_n1_5 = auto_staging == 12;
    pos_n1_6 = auto_staging == 13;
    
    pos_n2_1 = auto_staging == 2;
    pos_n2_2 = auto_staging == 8;
    pos_n2_3 = auto_staging == 10;
    pos_n2_4 = auto_staging == 14;
    
    pos_n3_1 = auto_staging == 9;
    
    pos_REM_1 = auto_staging == 5;
    pos_REM_2_1 = auto_staging == 11;
    pos_REM_2_2 = auto_staging == 16;
    
    pos_Mov_1 = auto_staging == -2;
        
    
    auto_staging(pos_wake_1) = 0.3;
    auto_staging(pos_wake_2) = 0.15;
    
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
    auto_staging(pos_REM_2_1) = 4.11;
    auto_staging(pos_REM_2_2) = 4.16;
    
    auto_staging(pos_Mov_1) = 5;

    %%  Smoothing  %%%
    %auto_staging_mod1 = auto_staging; % without smoothing
    % 有小數點無法跑這個
    %auto_staging_mod1 = post_staging_feat(auto_staging_mod1, feat); % with smoothing
    
    %% Movement Smoothing %%   
    auto_staging = mov_rej_v10(auto_staging); % without smoothing
    %auto_staging_mod1 = mov_rej_v10(auto_staging_mod1); % with smoothing
    
    %nodestage_result = [auto_staging, auto_staging_mod1];
    %csvwrite([nodestageDir, 'node_stage_', FeatureDir.name(1:13), '.dat'], nodestage_result);
    
   %% Recover %%
    auto_staging(pos_wake_1) = 0;
    auto_staging(pos_wake_2) = 0;
    
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
    auto_staging(pos_REM_2_1) = 4;
    auto_staging(pos_REM_2_2) = 4;
    
    auto_staging(pos_Mov_1) = 5;
    %%  Smoothing  %%
    auto_staging_mod1 = auto_staging; % without smoothing
    auto_staging_mod1 = post_staging_feat(auto_staging_mod1, feat); % with smoothing
    % auto_staging_mod1 = post_staging(auto_staging_mod1); % with smoothing
    
    %% Movement Smoothing %%
    auto_staging = mov_rej_v10(auto_staging); % without smoothing
    auto_staging_mod1 = mov_rej_v10(auto_staging_mod1); % with smoothing
    %csvwrite([AutostageDir,'auto_',FeatureDir.name(1:13),'.dat'], auto_staging_mod1);
    pred_stage = auto_staging_mod1;
    human_sco2 = mov_rej(human_sco);
    raw_staging = auto_staging;
    raw_staging_smoothing = auto_staging_mod1;
    %final_output = [human_sco2, nodestage_result, raw_staging, raw_staging_smoothing];
    %stage_result = [human_sco2, auto_staging, auto_staging_mod1];
    %csvwrite([AllstageDir,'allstage_',FeatureDir.name(1:13),'.dat'], stage_result);
    

    %% without smoothing %%
    stage_label=(0:5);
    for idx1=1:6
        for idx2 = 1:6
            nn_fi_result(idx2,idx1) = sum(human_sco == stage_label(idx1) & auto_staging == stage_label(idx2));
            nn_fi_mod1_result(idx2,idx1) = sum(human_sco == stage_label(idx1) & auto_staging_mod1 == stage_label(idx2));
            nn_ratio_result(idx2,idx1) = sum(human_sco == stage_label(idx1) & auto_staging == stage_label(idx2))./sum(human_sco == stage_label(idx1)).* 100;
            nn_ratio_result_mod1(idx2,idx1) = sum(human_sco == stage_label(idx1) & auto_staging_mod1 == stage_label(idx2))./sum(human_sco == stage_label(idx1)).* 100;
        end
    end
    
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
    %disp(result_accu)
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
    %disp(ratio_result_seq)                                   %print each stage agreement

    nn_fi_result = nn_fi_result';
    nn_fi_mod1_result = nn_fi_mod1_result';
    nn_ratio_result = nn_ratio_result';
    nn_ratio_result_mod1 = nn_ratio_result_mod1';
    nn_ratio_result_mod1 = nn_ratio_result_mod1 .* 100 - (nn_ratio_result_mod1 .* 100 - round(nn_ratio_result_mod1 .* 100)); % 保留至小數點後兩位
    nn_ratio_result_mod1 = nn_ratio_result_mod1/100; 

    %% Cohen's Kappa
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
    
    %% output result1
    output = [epoch_no, ratio_result_seq, result_accu, RJratio, Kappa_value];
 
    %% low reliability duration
    pagemax=epoch_no;
    count_from_head = ones(1,pagemax);
    count_from_bottom = ones(1,pagemax);
    count_changetime_from_head = zeros(1,pagemax);
    front_stage = auto_staging_mod1(1);
    next_stage =auto_staging_mod1(pagemax);
    startnum = 0;
    endnum = 0;
    SWR_feat_num = [1 28 20 44 4 31 18 42];
    SWR_bound = [0.45 1;    %1  (N3>N2)
        0.45 1;     %28
        0.3 0.7;    %20
        0.4 0.8;    %44
        0 0.4;      %4  (N2>N3)
        0 0.3;      %31
        0 0.5;      %18
        0 0.4;];    %42
    SWR_vote_pre = zeros(size(feat,1), length(SWR_feat_num));
    SWR_vote = [];
    for i = 2 : size(auto_staging_mod1,1)
        if front_stage ~= auto_staging_mod1(i)
            front_stage = auto_staging_mod1(i);
            count_changetime_from_head(i) = count_changetime_from_head(i-1) + 1;
        else
            count_from_head(i) = count_from_head(i-1) + 1;
        end

        if next_stage ~=auto_staging_mod1(pagemax - i + 1)
            next_stage = auto_staging_mod1(pagemax - i + 1);
        else
            count_from_bottom(pagemax - i + 1) = count_from_bottom(pagemax - i + 2) + 1;
        end     
    end

    for i = 1:length(SWR_feat_num)
        SWR_vote_pre(:,i) = feat(:,SWR_feat_num(i)) > SWR_bound(i,1) & feat(:,SWR_feat_num(i)) < SWR_bound(i,2);
    end
    SWR_vote = SWR_vote_pre;
    for j = 1:length(SWR_feat_num)
        for k = 3:size(feat,1)-2
            if SWR_vote_pre(k,j) == SWR_vote_pre(k-1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k-2,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+2,j)
                SWR_vote(k,j) = 1; %0
            else
                SWR_vote(k,j) = 0; %1
            end
        end     
    end

    for i = 1:length(SWR_vote)
        sum_SWR_vote(i) = sum(SWR_vote(i,:));
    end
        sum_SWR_vote=sum_SWR_vote';
    slow_wave_related=zeros(1,pagemax);
    stage_change_distance=zeros(1,pagemax);
    stage_change_freq=zeros(1,pagemax);
    arousal=zeros(1,pagemax);
    for i = 1 : size(auto_staging_mod1,1)
        % SCD
        stage_change_distance(i) = min(count_from_head(i), count_from_bottom(i));
        % SCF
        startnum = i - 2;
        endnum = i + 2;
        if startnum <= 0
            startnum = 1;
        end
        if endnum > pagemax
            endnum = pagemax;
        end
        stage_change_freq(i) = count_changetime_from_head(endnum) - count_changetime_from_head(startnum);
        % SWR
        if sum_SWR_vote(i) >= 6 %2
            slow_wave_related(i) = 1;
        end

        %Arousal
        if feat(i,50) > 0 
            arousal(i:i+1) = 1;
        end
    end
    % SWR(slow wave related)
    % print low reliability
    low_reliability = [];
    count_low_reliability = 1;
    
    pred_stage_reliab=auto_staging_mod1;
    for i = 1 : length(stage_change_distance)
        vote=0;
        if stage_change_distance(i) < 2
            vote=vote+1;
        end
        if slow_wave_related(i) == 1
            vote=vote+1;
        end
        if abs(stage_change_freq(i)) > 2
            vote=vote+1;
        end
        if vote >= 2 || arousal(i) == 1
            low_reliability(count_low_reliability) = i;
            % 因為這邊加了小數點，所以prediction那邊畫圖會變wake，要取個floor
            pred_stage_reliab(i) = human_sco(i) + 0.1;
            count_low_reliability  = count_low_reliability + 1;
        end
    end
    
    final_output = [human_sco2, node_only, raw_staging, raw_staging_smoothing, pred_stage_reliab];
    csvwrite([result_answer_dir, FeatureDir.name, '.csv'], final_output);
   %% caulate result  
    stage_label=(0:5);
    for idx1=1:6
        for idx2 = 1:6
            nn_fi_mod1_result(idx2,idx1)=sum(human_sco == stage_label(idx1) & pred_stage_reliab == stage_label(idx2));
            nn_ratio_result_mod1(idx2,idx1) = sum(human_sco == stage_label(idx1) & ...
               pred_stage_reliab == stage_label(idx2))./sum(human_sco == stage_label(idx1)).* 100;
        end
    end
    mov_stage = find(human_sco == 5 | pred_stage_reliab == 5);
    RJratio = length(mov_stage)/epoch_no*100;

    %% result
    result_final = nn_fi_mod1_result(1:5,1:5);
    result_final_sum = sum(result_final);                   %print epoch total num
    result_cor = result_final(1,1) + result_final(2,2) + result_final(3,3) + result_final(4,4) + result_final(5,5) ;
    result_accu = result_cor / sum(result_final_sum) * 100;
    result_accu = result_accu * 100 - (result_accu * 100 - round(result_accu * 100)); % 保留至小數點後兩位
    result_accu = result_accu/100;
    %disp(result_accu)
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
    %disp(ratio_result_seq)                                   %print each stage agreement

    nn_fi_result = nn_fi_result';
    nn_fi_mod1_result = nn_fi_mod1_result';
    nn_ratio_result = nn_ratio_result';
    nn_ratio_result_mod1 = nn_ratio_result_mod1';
    nn_ratio_result_mod1 = nn_ratio_result_mod1 .* 100 - (nn_ratio_result_mod1 .* 100 - round(nn_ratio_result_mod1 .* 100)); % 保留至小數點後兩位
    nn_ratio_result_mod1 = nn_ratio_result_mod1/100; 

    %% Cohen's Kappa
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
    
    output_reliab = [epoch_no, ratio_result_seq, result_accu, RJratio, Kappa_value];
    
end