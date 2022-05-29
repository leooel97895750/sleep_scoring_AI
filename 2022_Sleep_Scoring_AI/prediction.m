clear 
close all

addpath('.\predictions');

InputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\';
OutputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022result';

% 要注意feature_files跟stage_files順序一不一樣
feature_files = dir([InputDir '2022feature\*.dat']); %load all .mat files in the folder
stage_files = dir([InputDir '2022stage\*.dat']); %load all .mat files in the folder
filesNumber = length(stage_files);
    
agreement = [];
wake_agr = [];
n1_agr = [];
n2_agr = [];
n3_agr = [];
rem_agr = [];

for i = 1:filesNumber
    
    % 餵進去: 特徵、睡眠階段、輸出路徑
    % 吐出來: 結果?、table?、ruletable?、table2、一致性?、預測階段?、信賴度?、預測階段信賴度(最後使用的睡眠階段)?、低信賴Epoch?
    [result(i,:), table, ruletable, table2, kappa, raw_staging, pred_stage, output_reliab(i,:), pred_stage_reliab, low_reliability] = ...
        multi_scale_auto_staging_Siesta_v10_chun(feature_files(i), stage_files(i), OutputDir);
    
    hyp = load(fullfile(stage_files(i).folder,stage_files(i).name)); 
    
    hf = figure('outerposition', get(0, 'screensize'));
    hf = colordef(hf, 'white'); %Set color scheme
    hf.Color = 'w'; 
    
    subplot(411); hold on; grid on;
    W = hyp == 0;
    R = hyp == -1;
    bar(R,'FaceColor', '#A2142F', 'BarWidth', 1)
    N1 = hyp == 1;
    bar(N1*-1, 'FaceColor', '#EDB120', 'BarWidth', 1)
    N2 = hyp == 2;
    bar(N2*-2, 'FaceColor', '#77AC30', 'BarWidth', 1)
    N3 = hyp == 3;
    bar(N3*-3, 'FaceColor', '#0072BD', 'BarWidth', 1) 
    axis tight;
    ylim([-3 1]);
    yticklabels({'N3', 'N2', 'N1', 'W', 'R'});
    title('human scoring');

    subplot(412); hold on; grid on;
    W = raw_staging == 0;
    R = raw_staging == 4;
    bar(R,'FaceColor', '#A2142F', 'BarWidth', 1)
    N1 = raw_staging == 1;
    bar(N1*-1, 'FaceColor', '#EDB120', 'BarWidth', 1)
    N2 = raw_staging == 2;
    bar(N2*-2, 'FaceColor', '#77AC30', 'BarWidth', 1)
    N3 = raw_staging == 3;
    bar(N3*-3, 'FaceColor', '#0072BD', 'BarWidth', 1) 
    axis tight;
    ylim([-3 1]);
    yticklabels({'N3', 'N2', 'N1', 'W', 'R'});
    title('without smoothing');
    
    subplot(413); hold on; grid on;
    W = pred_stage == 0;
    R = pred_stage == 4;
    bar(R, 'FaceColor', '#A2142F', 'BarWidth', 1);
    N1 = pred_stage == 1;
    bar(N1*-1, 'FaceColor', '#EDB120', 'BarWidth', 1);
    N2 = pred_stage == 2;
    bar(N2*-2, 'FaceColor', '#77AC30', 'BarWidth', 1);
    N3 = pred_stage == 3;
    bar(N3*-3, 'FaceColor', '#0072BD', 'BarWidth', 1) ;
   
    
    for j = 1:length(low_reliability)
        second_block = patch([low_reliability(j), low_reliability(j)+1, low_reliability(j)+1, low_reliability(j)], [1 1 -3 -3], 'b');
        second_block.FaceAlpha = 0.3;
        second_block.EdgeAlpha = 0;
        hold on; 
    end
    
    axis tight;
    ylim([-3 1]);
    yticklabels({'N3', 'N2', 'N1', 'W', 'R'});
    title('human-machine collaborative scoring');

    % 用完全預測結果來計算agreement
    pred_stage(pred_stage == 4) = -1;
    mystage = floor(pred_stage);
    agreement(end+1) = length(find(hyp == mystage)) / length(hyp)*100;
    wake_agr(end+1) = length(find(((hyp == 0) & (mystage == 0)) == 1)) / length(find(hyp == 0)) * 100;
    n1_agr(end+1) = length(find(((hyp == 1) & (mystage == 1)) == 1)) / length(find(hyp == 1)) * 100;
    n2_agr(end+1) = length(find(((hyp == 2) & (mystage == 2)) == 1)) / length(find(hyp == 2)) * 100;
    n3_agr(end+1) = length(find(((hyp == 3) & (mystage == 3)) == 1)) / length(find(hyp == 3)) * 100;
    rem_agr(end+1) = length(find(((hyp == -1) & (mystage == -1)) == 1)) / length(find(hyp == -1)) * 100;
    xlabel(string(feature_files(i).name)+" Agreement: "+string(agreement(end)));

end

% agreement存起來
final_output = [agreement; wake_agr; n1_agr; n2_agr; n3_agr; rem_agr];
csvwrite([OutputDir, '\agreement', date, '_signal_abnormal_修改後.csv'], final_output);