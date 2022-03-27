tic
clear all
%InputDir


stage_files=dir('D:\﹕\mandywu\何痸弄\data\何痸いみ(尝侣data)\all_Stage\*.dat');
feat_files=dir('D:\﹕\mandywu\何痸弄\data\何痸いみ(尝侣data)\all_MAT\feat_o\*.mat');
feat_files2=dir('D:\﹕\mandywu\何痸弄\data\何痸いみ(尝侣data)\all_MAT\feat_chun\*.mat');
FeatureDir = 'D:\﹕\mandywu\何痸弄\data\何痸いみ(尝侣data)\all_MAT\feat_chun\';
files1 = dir([FeatureDir '*.mat']); %load all .mat files in the folder
filesNumber1 = length(files1);

StageDir = 'D:\﹕\mandywu\何痸弄\data\何痸いみ(尝侣data)\all_Stage\';
files2 = dir([StageDir '*.dat']); %load all .mat files in the folder
filesNumber2 = length(files2);

OutputDir = 'D:\﹕\mandywu\何痸弄\阶ゅMYTEST\distribution_distance(DD)\N3_N1REM\'; %%%%%
if exist(OutputDir,'dir')~=7
        mkdir(OutputDir);
end

all_distance = [];
train_distance = [];
test_distance = [];
count_train = 1 ;
count_test = 1 ;

if filesNumber1 == filesNumber2
    for f = 1 : filesNumber1
        feat=[];
        hyp=[];

        filename1 = files1(f).name;
        tmp=load([FeatureDir filename1]);
        feat = [feat; tmp.feat ];
        
        filename2 = files2(f).name;
        hyp = [hyp; load([StageDir filename2]);];
  
        mean_wake = zeros(1,52);
        mean_N1 = zeros(1,52);
        mean_N2 = zeros(1,52);
        mean_N3 = zeros(1,52);
        mean_REM = zeros(1,52);
        
        std_wake = zeros(1,52);
        std_N1= zeros(1,52);
        std_N2 = zeros(1,52);
        std_N3= zeros(1,52);
        std_REM = zeros(1,52);
        
        for i = 1:52
            mean_wake(1,i)=mean(feat(hyp == 0,i));
            mean_N1(1,i)=mean(feat(hyp == 1,i));
            mean_N2(1,i)=mean(feat(hyp == 2,i));
            mean_N3(1,i)=mean(feat(hyp == 3,i));
            mean_REM(1,i)=mean(feat(hyp == -1,i));
            
            tmp = find(hyp == 1 | hyp == -1);
            mean_N1_REM(1,i)=mean(feat(tmp,i));
            
            std_wake(1,i)=std(feat(hyp == 0,i));
            std_N1(1,i)=std(feat(hyp == 1,i));
            std_N2(1,i)=std(feat(hyp == 2,i));
            std_N3(1,i)=std(feat(hyp == 3,i));
            std_REM(1,i)=std(feat(hyp == -1,i));
            std_N1_REM(1,i)=std(feat(tmp,i));
        end

        mean_stage1 = mean_N1;%mean_N3; %mean_N1; %mean_N3; %mean_REM; %mean_wake;     %%%%%%  select stage
        mean_stage2 = mean_REM;%mean_N1_REM; %mean_REM; %mean_wake; %mean_N2; %mean_N3;                 %%%%%%  select stage
        std_stage1 = std_N1;%std_N3; %std_N1; %std_N3; %std_REM; %std_wake;
        std_stage2 = std_REM; %std_N1_REM; %std_REM; %std_wake; %std_N2; %std_N3;

        dist_d = 1-(std_stage1 + std_stage2)./(2.*abs(mean_stage1 - mean_stage2));   %  calculate DD
        pos_o = find(dist_d < 0);
        dist_d(pos_o) = 0;
        
        %pos_o_2 = find(isnan(dist_d) == 1);
        %dist_d(pos_o_2) = 0;
         
        all_distance(f,:) = dist_d;
        if mod(f,2) == 1    %odd(train set)
            train_distance(count_train,:) = dist_d;
            count_train = count_train + 1 ;
        else    %even(test set)
            test_distance(count_test,:) = dist_d;
            count_test = count_test + 1 ;
        end
        
        %figure
        plot(dist_d,'b*-')
        xlim([0 50])
        % set(gca,'XTickLabel',{'0-4E','4-8E','8-13E','22-30E','0-30E','me(fre)E','me(fre)M','amp M','0-30M','alpha','spindle','SWS','0-4O'},'XTick',[1:13])
        
        title(strcat(filename2(1:8),'-',filename2(10:end-4)));
        xlabel('feature计(1-49)');
        ylabel('DD(distribution distance)');
        
        channel_name = '_N3_N1Rem'; %%%%%
        saveas(gcf,strcat(OutputDir,filename2(1:end-4),channel_name,'_DD','.jpg'));
    end
   
    save(strcat(OutputDir,'all_distance',channel_name,'.mat'),'all_distance');
    dlmwrite(strcat(OutputDir,'all_distance',channel_name,'.txt'),all_distance);
    
    save(strcat(OutputDir,'train_distance',channel_name,'.mat'),'train_distance');
    dlmwrite(strcat(OutputDir,'train_distance',channel_name,'.txt'),train_distance);
    
    save(strcat(OutputDir,'test_distance',channel_name,'.mat'),'test_distance');
    dlmwrite(strcat(OutputDir,'test_distance',channel_name,'.txt'),test_distance);
end
toc