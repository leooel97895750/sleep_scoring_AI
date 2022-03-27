clear 
%close all
data_files=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\*.mat');
stage_files=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_Stage\*.dat');
feat_files=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\feat_o\*.mat');
feat_files2=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\feat_chun\*.mat');
auto_files=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\autostage_o\*.dat');
auto_files2=dir('D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\autostage_chun\*.dat');
% %%
% data1_files=dir('D:\孟純\mandywu\睡眠判讀\論文MYTEST\feature_and_test\autostage_chun\');
% data2_files=dir('D:\孟純\mandywu\睡眠判讀\論文MYTEST\feature_and_test\autostage_o\');
% stage_files=dir("D:\孟純\mandywu\睡眠判讀\論文MYTEST\feature_and_test\stage_with_unknown\");
result_table=zeros(5,5);
result_pre=zeros(5,5);
result_table_o=zeros(5,5);
result_pre_o=zeros(5,5);
for data_num=1:length(data_files)
stage=load([stage_files(data_num).folder '\' stage_files(data_num).name]);
data=load([data_files(data_num).folder '\' data_files(data_num).name]);
data=data.data;
autostage=load([auto_files(data_num).folder '\' auto_files(data_num).name]);
autostage_chun=load([auto_files2(data_num).folder '\' auto_files2(data_num).name]);
feat=load([feat_files2(data_num).folder '\' feat_files2(data_num).name]);
feat=feat.feat;
% fs=200;
% if data_num==28 || data_num==38
%     fs=512;
% end
% pagemax=floor(length(data(1,:))/fs/30);
% feat = run_feat_chun(data',fs);
% save(['D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\feat_chun\' data_files(data_num).name(1:end-4) '_feat.mat'],'feat');

% [autostage nodestage] = run_purposed(data',feat);
% csvwrite(['D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\autostage_o\' data_files(data_num).name(1:end-4) '_autostage.dat'],autostage);
% agreement(data_num)=length(find(autostage==stage))/length(stage);
% 

stage_sum=zeros(5,5);
stage2num=containers.Map([0,1,2,3,-1,5],[1 2 3 4 5,1]);
% %%new
% test(data_num).result_table=zeros(5,5);
% test(data_num).result_pre=zeros(5,5);
% for i=1:length(stage)
%     test(data_num).result_table(stage2num(stage(i)),stage2num(autostage_chun(i)))=test(data_num).result_table(stage2num(stage(i)),stage2num(autostage_chun(i)))+1;
%     result_table(stage2num(stage(i)),stage2num(autostage_chun(i)))=result_table(stage2num(stage(i)),stage2num(autostage_chun(i)))+1;
% end
% for i=1:5
%     test(data_num).result_pre(i,1:5)=test(data_num).result_table(i,1:5)/sum(result_table(i,1:5));
%     result_pre(i,1:5)=result_table(i,1:5)/sum(result_table(i,1:5));
% end   
%%original
% test(data_num).result_table_o=zeros(5,5);
% test(data_num).result_pre_o=zeros(5,5);
% for i=1:length(stage)
%     test(data_num).result_table_o(stage2num(stage(i)),stage2num(autostage(i)))=test(data_num).result_table_o(stage2num(stage(i)),stage2num(autostage(i)))+1;
%     result_table_o(stage2num(stage(i)),stage2num(autostage(i)))=result_table_o(stage2num(stage(i)),stage2num(autostage(i)))+1;
% end
% for i=1:5
%     test(data_num).result_pre_o(i,1:5)=test(data_num).result_table_o(i,1:5)/sum(result_table_o(i,1:5));
%     result_pre_o(i,1:5)=result_table_o(i,1:5)/sum(result_table_o(i,1:5));
% end
% data1=load([data1_files(data_num).folder '\' data1_files(data_num).name]);
% data2=load([data2_files(data_num).folder '\' data2_files(data_num).name]);
% stage=load([stage_files(data_num).folder '\' stage_files(data_num).name]);
% t=[1:length(stage)];
% pagemax=length(stage)
% autostage_chun=data1.autostage_chun;
% autostage=data2.autostage;
% 
% autostage(find(autostage==4))=-1;
% autostage=autostage*-1;
% autostage_chun(find(autostage_chun==4))=-1;
% autostage_chun=autostage_chun*-1;
% unknown_idx=find(stage==6);
% stage(find(stage==6))=0;
% stage=stage*-1;
% 
% count_from_head = ones(1,pagemax);
% count_from_bottom = ones(1,pagemax);
% count_changetime_from_head = zeros(1,pagemax);
% front_stage = autostage(1);
% next_stage = autostage(pagemax);
% startnum = 0;
% endnum = 0;
% SWR_feat_num = [1 28 20 44 4 31 18 42];
% SWR_bound = [0.45 1;    %1  (N3>N2)
%     0.45 1;     %28
%     0.3 0.7;    %20
%     0.4 0.8;    %44
%     0 0.4;      %4  (N2>N3)
%     0 0.3;      %31
%     0 0.5;      %18
%     0 0.4;];    %42
% SWR_vote_pre = zeros(size(feat,1),length(SWR_feat_num));
% SWR_vote = [];
% 
% for i = 2 : size(autostage,1)
%     if front_stage ~= autostage(i)
%         front_stage = autostage(i);
%         count_changetime_from_head(i) = count_changetime_from_head(i-1) + 1;
%     else
%         count_from_head(i) = count_from_head(i-1) + 1;
%     end
% 
%     if next_stage ~= autostage(pagemax - i + 1)
%         next_stage = autostage(pagemax - i + 1);
%     else
%         count_from_bottom(pagemax - i + 1) = count_from_bottom(pagemax - i + 2) + 1;
%     end     
% end
% 
% for i = 1:length(SWR_feat_num)
%     SWR_vote_pre(:,i) = feat(:,SWR_feat_num(i)) > SWR_bound(i,1) & feat(:,SWR_feat_num(i)) < SWR_bound(i,2);
% end
% SWR_vote = SWR_vote_pre;
% for j = 1:length(SWR_feat_num)
%     for k = 3:size(feat,1)-2
%         if SWR_vote_pre(k,j) == SWR_vote_pre(k-1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k-2,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+2,j)
%             SWR_vote(k,j) = 1; %0
%         else
%             SWR_vote(k,j) = 0; %1
%         end
%     end     
% end
% 
% for i = 1:length(SWR_vote)
%     sum_SWR_vote(i) = sum(SWR_vote(i,:));
% end
%     sum_SWR_vote=sum_SWR_vote';
% slow_wave_related=zeros(1,pagemax);
% stage_change_distance=zeros(1,pagemax);
% stage_change_freq=zeros(1,pagemax);
% for i = 1 : size(autostage,1)
%     %SCD
%     stage_change_distance(i) = min(count_from_head(i),count_from_bottom(i));
%     %SCF
%     startnum = i - 2;
%     endnum = i + 2;
%     if startnum <= 0
%         startnum = 1;
%     end
%     if endnum > pagemax
%         endnum = pagemax;
%     end
%     stage_change_freq(i) = count_changetime_from_head(endnum) - count_changetime_from_head(startnum);
% 
%     %SWR
%     if sum_SWR_vote(i) >= 6 %2
%         slow_wave_related(i) = 1;
%     end
% end
% %SWR(slow wave related)
% %print low reliability
% low_reliability = [];
% count_low_reliability = 1;
% for i = 1 : length(stage_change_distance)
%     %if (stage_change_distance(i) < 2 && slow_wave_related(i) == 1) || (abs(stage_change_freq(i)) >= 2 && slow_wave_related(i) == 1)
%     if stage_change_distance(i) < 10 && abs(stage_change_freq(i)) >= 1 && slow_wave_related(i) == 1
%         low_reliability(count_low_reliability) = i;
%         autostage(i)=0;
%         autostage_chun(i)=0;
%         count_low_reliability  = count_low_reliability + 1;
%     end
% end
% 
figure('outerposition',get(0,'screensize'));
subplot(312)
plot(autostage,'r');hold on;
% for i=1:length(low_reliability)
%     second_block = patch([low_reliability(i),low_reliability(i)+1,low_reliability(i)+1,low_reliability(i)], [1 1 -3 -3], 'b');
%     second_block.FaceAlpha = 0.2;second_block.EdgeAlpha = 0.2;
%     hold on; 
% end
subplot(313)
plot(autostage_chun,'b');hold on;
% for i=1:length(low_reliability)
%     second_block = patch([low_reliability(i),low_reliability(i)+1,low_reliability(i)+1,low_reliability(i)], [1 1 -3 -3], 'b');
%     second_block.FaceAlpha = 0.2;second_block.EdgeAlpha = 0.2;
% hold on; 
% end
subplot(311)
plot(stage,'k');
% for i=1:length(unknown_idx)
%     second_block = patch([unknown_idx(i),unknown_idx(i)+1,unknown_idx(i)+1,unknown_idx(i)], [1 1 -3 -3], 'b');
%     second_block.FaceAlpha = 0.2;second_block.EdgeAlpha = 0.2;
% hold on; 
% end
end
