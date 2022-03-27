clc
clear
close
tic

fpath = uigetdir;
InputDir = fpath;%PSG_channel\';
OutputDir = fpath;
files = dir([InputDir '\' '*.edf']); %load all .mat files in the folder
filesNumber = length(files);

if exist(OutputDir,'dir')~=7
        mkdir(OutputDir);
end
    
for f = 1:filesNumber
    [hdr, data] = edfread([InputDir '\' files(f).name]);
    %load([InputDir files(f).name]);
    fprintf('file(%d/%d): %s is loaded.\n',f,filesNumber,files(f).name(1:end-4));

    save(strcat(OutputDir,'\',files(f).name(1:end-4),'.mat'),'data');
    %fprintf('file(%d/%d): %s is saved.\n',f,filesNumber,files(f).name(1:end-4));
    
    data_5ch(1,:)=data(1,:);
    data_5ch(2,:)=data(4,:);
    data_5ch(3,:)=data(7,:);
    data_5ch(4,:)=data(8,:);
    data_5ch(5,:)=data(9,:);
    
    save(strcat(OutputDir,'\',files(f).name(1:end-4),'_C3F4E1E2EMG.mat'),'data_5ch');
    fprintf('file(%d/%d): %s is saved.\n',f,filesNumber,files(f).name(1:end-4));
    close all
    clear data_5ch
end