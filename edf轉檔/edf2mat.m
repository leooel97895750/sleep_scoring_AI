clc
clear
close
tic

fpath = uigetdir;
InputDir = fpath;
OutputDir = fpath;
files = dir([InputDir '\' '*.edf']); %load all .edf files in the folder
filesNumber = length(files);

if exist(OutputDir,'dir')~=7
        mkdir(OutputDir);
end
    
for f = 1:filesNumber
    [hdr, data] = edfread([InputDir '\' files(f).name]);
    %load([InputDir files(f).name]);
    fprintf('file(%d/%d): %s is loaded.\n',f,filesNumber,files(f).name(1:end-4));

    save(strcat(OutputDir,'\',files(f).name(1:end-4),'.mat'),'data');
    fprintf('file(%d/%d): %s is saved.\n',f,filesNumber,files(f).name(1:end-4));
  
    %clear data
    close all
end