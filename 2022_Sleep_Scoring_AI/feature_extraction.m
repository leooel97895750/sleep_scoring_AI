addpath('.\feature_extractions');

InputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022data\';
OutputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022feature\';
files = dir([InputDir '*.mat']); %load all .mat files in the folder

%%
h = waitbar(0,'Please wait...');
filesNumber = length(files);

for i = 1 : filesNumber

    fprintf('file(%d/%d): %s is loaded.\n',i,filesNumber,files(i).name(1:end-4));
    feat_extract(files(i),OutputDir);
    waitbar(i/filesNumber,h,strcat('Please wait...',num2str(round(i/filesNumber*100)),'%'))
    
end
close(h);