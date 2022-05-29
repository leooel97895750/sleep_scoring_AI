clear
close all

% 注意順序一不一樣
featureDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022feature\';
featureFiles = dir([featureDir '*.dat']);
stageDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022stage\';
stageFiles = dir([stageDir '*.dat']);
num = length(featureFiles);

mean_wake = zeros(num, 52);
mean_N1 = zeros(num, 52);
mean_N2 = zeros(num, 52);
mean_N3 = zeros(num, 52);
mean_REM = zeros(num, 52);

std_wake = zeros(num, 52);
std_N1= zeros(num, 52);
std_N2 = zeros(num, 52);
std_N3= zeros(num, 52);
std_REM = zeros(num, 52);

for i = 1:length(featureFiles)
    feature = load([featureDir featureFiles(i).name]);
    stage = load([stageDir stageFiles(i).name]);
    if length(feature) ~= length(stage)
        disp(featureFiles(i).name);
    end

    for j = 1:52
        mean_wake(i, j) = mean(feature(stage == 0, j));
        mean_N1(i, j) = mean(feature(stage == 1, j));
        mean_N2(i, j) = mean(feature(stage == 2, j));
        mean_N3(i, j) = mean(feature(stage == 3, j));
        mean_REM(i, j) = mean(feature(stage == -1, j));
        
        std_wake(i, j) = std(feature(stage == 0, j));
        std_N1(i, j) = std(feature(stage == 1, j));
        std_N2(i, j) = std(feature(stage == 2, j));
        std_N3(i, j) = std(feature(stage == 3, j));
        std_REM(i, j) = std(feature(stage == -1, j));
    end
end

mean_stage1 = mean_N2;
mean_stage2 = mean_N3;
std_stage1 = std_N2;
std_stage2 = std_N3;
dist_d = 1 - ((std_stage1 + std_stage2) ./ (2 .* abs(mean_stage1 - mean_stage2)));
pos_o = find(dist_d < 0);
dist_d(pos_o) = 0;

