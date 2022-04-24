clear 
close all

addpath('.\predictions');

result_table = zeros(5,5);
totalruletable = zeros(15,6);
result_before = zeros(5,5);

InputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\';
OutputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022result';

% 要注意feature_files跟stage_files順序一不一樣
feature_files = dir([InputDir '2022feature\*_feature.dat']); %load all .mat files in the folder
stage_files = dir([InputDir '2022stage\*_stage.dat']); %load all .mat files in the folder
files = dir([InputDir '*.mat']); %load all .mat files in the folder
filesNumber = length(stage_files);
    
final_table = [];
for i = 1:filesNumber
    [result(i,:), table, ruletable, table2, kappa, pred_stage, output_reliab(i,:), pred_stage_reliab, low_reliability] = multi_scale_auto_staging_Siesta_v10_chun(feature_files(i), stage_files(i), OutputDir); %original(files(i).name(1:end-4));  %
    hyp = load(fullfile(stage_files(i).folder,stage_files(i).name)); 
    totalruletable = ruletable + totalruletable;
    result_table = result_table + table;
    table11(i) = {table};
    table12(i) = {sp(table)};
    result_before = result_before + table2;     
    hf = figure('outerposition', get(0, 'screensize'));
    hf = colordef(hf, 'white'); %Set color scheme
    hf.Color = 'w'; 
    subplot(411); hold on;
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
    
    subplot(412); hold on;
    W = pred_stage_reliab == 0;
    R = pred_stage_reliab == 4;
    bar(R, 'FaceColor', '#A2142F', 'BarWidth', 1);
    N1 = pred_stage_reliab == 1;
    bar(N1*-1, 'FaceColor', '#EDB120', 'BarWidth', 1);
    N2 = pred_stage_reliab == 2;
    bar(N2*-2, 'FaceColor', '#77AC30', 'BarWidth', 1);
    N3 = pred_stage_reliab == 3;
    bar(N3*-3, 'FaceColor', '#0072BD', 'BarWidth', 1) ;
    
    for j = 1:length(low_reliability)
        second_block = patch([low_reliability(j), low_reliability(j)+1, low_reliability(j)+1, low_reliability(j)], [1 1 -3 -3], 'b');
        second_block.FaceAlpha = 0.5;
        second_block.EdgeAlpha = 0;
        hold on; 
    end
    
    title('human-machine collaborative scoring');
    hold on; grid on;
    ACC = length(find(hyp == pred_stage_reliab)) / length(hyp)*100;
    epoch_length = length(hyp);
end

final_table(1:5,1:5) = result_table;
final_table(1,6) = result_table(1,1) / sum(result_table(1,:))*100 ;
final_table(2,6) = result_table(2,2) / sum(result_table(2,:))*100 ;
final_table(3,6) = result_table(3,3) / sum(result_table(3,:))*100 ;
final_table(4,6) = result_table(4,4) / sum(result_table(4,:))*100 ;
final_table(5,6) = result_table(5,5) / sum(result_table(5,:))*100 ;
final_table(6,6) = (result_table(1,1) + result_table(2,2) + result_table(3,3) + result_table(4,4) + result_table(5,5)) / ...
    (sum(result_table(:,1)) + sum(result_table(:,2)) + sum(result_table(:,3)) + sum(result_table(:,4)) + sum(result_table(:,5)))*100;

csvwrite(strcat(OutputDir,'\','result.csv'), result);