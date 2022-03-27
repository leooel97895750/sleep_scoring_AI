
%InputDir = 'G:\我的雲端硬碟\AHI5_temp\MAT\';
%OutputDir = 'G:\我的雲端硬碟\AHI5_temp\Feature\';
% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\MAT\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\MAT\Feature\';
% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\data_mat_0111\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\Feature\';
% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\雲端判讀系統data\Training4data\data\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\雲端判讀系統data\Training4data\Feature\';
InputDir = 'C:\Users\leooel97895750\Desktop\stageAI\2022data\';
OutputDir = 'C:\Users\leooel97895750\Desktop\stageAI\2022feature\';
files = dir([InputDir '*.mat']); %load all .mat files in the folder

%files = {'s980401'};
%%
h = waitbar(0,'Please wait...');
filesNumber = length(files);
% filesNumber = 10;
for i = 1 : filesNumber
    %load([InputDir files(i).name]);
    fprintf('file(%d/%d): %s is loaded.\n',i,filesNumber,files(i).name(1:end-4));
    %feat_extract(files{i,1});
    feat_extract(files(i),OutputDir);
    
    waitbar(i/filesNumber,h,strcat('Please wait...',num2str(round(i/filesNumber*100)),'%'))    
end
close(h);