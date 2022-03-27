function [auto_staging_mod1 nodestage_result] = multi_scale_auto_staging_Siesta_chun(data,feat)
tic
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

%EMG_amp_mean=mean(feat(:,21))%+0.5*std(feat(:,21));
corr=corrcoef(feat(:,52),feat(:,51))

for epoch_no = 1:length(feat)
    set_Mov = 0;
    set_Aro = 0;
    %%%  Arousal & Mov staging  %%%
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
    if feat(epoch_no,50) > 0 && feat(epoch_no,21) > 0.3%C4F40-30
        auto_staging(epoch_no) = 15; 
        set_Aro=1;
    end
    if  corr(1,2)< 0.4 && feat(epoch_no,51) > 0.5 && feat(epoch_no,21) > 0.15 || ( corr(1,2)< 0.4 &&feat(epoch_no,3) > 0.9 && feat(epoch_no,35) > 0.9)%C4F40-30 %alphaCF>0.9
        auto_staging(epoch_no) = 15; 
        set_Aro=1;
    end
    %%%  non-Mov staging  %%%
    if set_Aro~=1 && set_Mov~=1
        if feat(epoch_no,10) > 0.2 && feat(epoch_no,18) > 0.83 && feat(epoch_no,31) > 0.4 && feat(epoch_no,32) > 0.3 && feat(epoch_no,37) > 0.3 && feat(epoch_no,42) > 0.51 %&& feat(epoch_no,51) == 0 % pro_alpha = 1 , rule 1
            if feat(epoch_no,8) > 0.1 && feat(epoch_no,15) > 0.3 && feat(epoch_no,18) > 0.84 && feat(epoch_no,21) > 0.05 && feat(epoch_no,35) > 0.2 % rule 2
                if feat(epoch_no,4) < 0.4  %rule 4(N2)
                    if feat(epoch_no,23) < 0.12 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 8
                        auto_staging(epoch_no) = 1; 
                    else
                        auto_staging(epoch_no) = 2; 
                    end
                else
                    if feat(epoch_no,5) < 0.5 && feat(epoch_no,15) < 0.95 && feat(epoch_no,16) < 0.97 && feat(epoch_no,21) < 0.75 && feat(epoch_no,32) < 0.6 && feat(epoch_no,37) < 0.8 %rule 4
                        if feat(epoch_no,23) < 0.12 && feat(epoch_no,5) > 0.1 && feat(epoch_no,10) > 0.2 && feat(epoch_no,16) > 0.2 && feat(epoch_no,31) > 0.2 && feat(epoch_no,32) > 0.1 && feat(epoch_no,37) > 0.2  %  rule 8
                            auto_staging(epoch_no) = 1; 
                        else
                            auto_staging(epoch_no) = 2; 
                        end
                    else  %rule9;
                        if  feat(epoch_no,8) >  0.17 && feat(epoch_no,12) >  0.01 && feat(epoch_no,15) >  0.2 && feat(epoch_no,39) >  0.01 %rule 9
                            auto_staging(epoch_no) = 3;
                        else
                            auto_staging(epoch_no) = 4;
                        end
                    end
                end
            else
                output_rule5 = rule5(epoch_no);
                if output_rule5 == 0  %rule10;
                    if feat(epoch_no,15) < 0.7  && feat(epoch_no,16) > 0.01 && feat(epoch_no,21) < 0.5 && feat(epoch_no,22) < 0.4 %|| feat(epoch_no,51) > 0%  rule 10
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
            if feat(epoch_no,1) > 0.59 && feat(epoch_no,5) < 0.2 && feat(epoch_no,4) < 0.4 && feat(epoch_no,31) < 0.6 && feat(epoch_no,51) == 0 % rule3
                rule6(epoch_no);
            else
                if feat(epoch_no,5) > 0.19   && feat(epoch_no,6) < 0.33 && feat(epoch_no,20) < 0.2 && feat(epoch_no,23) < 0.25 && feat(epoch_no,25) < 0.3 && feat(epoch_no,27) < 0.6 && feat(epoch_no,49) < 0.3|| (feat(epoch_no,51) > 0 && feat(epoch_no,21) < 0.3) % rule 7  && feat(epoch_no,10) > 0.51 && feat(epoch_no,37) > 0.43
                    if feat(epoch_no,15) < 0.7   && feat(epoch_no,16) > 0.01 && feat(epoch_no,21) < 0.15 && feat(epoch_no,22) < 0.4 && feat(epoch_no,52) < 0.1|| (feat(epoch_no,51) > 0 && feat(epoch_no,21) < 0.3) % && feat(epoch_no,5) < 0.4 && feat(epoch_no,52) < 0.02%  rule 12 %
                        auto_staging(epoch_no) = 11;
                    else
                        auto_staging(epoch_no) = 12; 
                    end
                elseif corr(1,2)>0.4
                    if feat(epoch_no,52) > 0.6 ||feat(epoch_no,51) > 0
                        auto_staging(epoch_no) = 11;
                    else
                        auto_staging(epoch_no) = 14;
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


    %%%  5-staged automatic staging accuracy  %%%
    pos_wake_1 = find(auto_staging == 3);
    pos_wake_2 = find(auto_staging == 15);
    
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
    pos_REM_3 = find(auto_staging == 17);
    
    pos_Mov_1 = find(auto_staging == -2);
    
    pos_Aro_1 = find(auto_staging == 16);
    
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
    auto_staging(pos_REM_2) = 4.11;
    auto_staging(pos_REM_3) = 4.17;
    
    auto_staging(pos_Mov_1) = 5;
    
    auto_staging(pos_Aro_1) = 6;
    %%  Smoothing  %%%
    auto_staging_mod1 = auto_staging; % without smoothing
    %auto_staging_mod1 = post_staging(auto_staging_mod1);
   % auto_staging_mod1 = post_staging_feat(auto_staging_mod1,feat); % with smoothing
   
    csvwrite(['auto_node_stage.dat'],auto_staging_mod1);
%% Movement Smoothing %%   
    %auto_staging = mov_rej(auto_staging); % without smoothing
    %auto_staging_mod1 = mov_rej(auto_staging_mod1); % with smoothing
    
    nodestage_result = [auto_staging, auto_staging_mod1];
    %csvwrite([nodestageDir,'node_stage_',filename(1:end-5),'.dat'],nodestage_result);
    
    %%Recover
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
    
    auto_staging(pos_REM_1) = -1;
    auto_staging(pos_REM_2) = -1;
    auto_staging(pos_REM_3) = -1;
    
    auto_staging(pos_Mov_1) = 0;
    
    auto_staging(pos_Aro_1) = 4;
    %%  Smoothing  %%%
    auto_staging_mod1 = auto_staging; % without smoothing
    auto_staging_mod1 = post_staging_feat_v2(auto_staging_mod1,feat); % with smoothing
    
    %% Movement Smoothing %%   
    %auto_staging = mov_rej(auto_staging); % without smoothing
    %auto_staging_mod1 = mov_rej(auto_staging_mod1); % with smoothing
    csvwrite(['autostage.dat'],auto_staging_mod1);
toc
end