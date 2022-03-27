% clear 
% close all
% data_files=dir(uigetdir('./'));%D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\Stage_dat
% stage_files=dir(uigetdir('./'));
%%
count=0
for data_num=3:6
    
stage=load([stage_files(data_num).folder '\' stage_files(data_num).name]);
data=load([data_files(data_num).folder '\' data_files(data_num).name]);
data=data.data;
fs=200;
pagemax=floor(length(data(1,:))/fs/30);
feat = run_feat(data',fs);
save(['..\feat_chun\' data_files(data_num).name(1:end-4) '_feat.mat'],'feat');
[autostage nodestage] = run_purposed_chun(data',feat);
save(['..\autostage_chun\' data_files(data_num).name(1:end-4) '_autostage.mat'],'autostage');
agreement(data_num)=length(find(autostage==stage))/length(stage);

    count_from_head = ones(1,handles.pageMax);
    count_from_bottom = ones(1,handles.pageMax);
    count_changetime_from_head = zeros(1,handles.pageMax);
    front_stage = handles.autostageTable(1);
    next_stage = handles.autostageTable(handles.pageMax);
    startnum = 0;
    endnum = 0;
    SWR_feat_num = [1 28 20 44 4 31 18 42];
    SWR_bound = [0.45 1;    %1  (N3>N2)
                0.45 1;     %28
                0.3 0.7;    %20
                0.4 0.8;    %44
                0 0.4;      %4  (N2>N3)
                0 0.3;      %31
                0 0.5;      %18
                0 0.4;];    %42
    SWR_vote_pre = zeros(size(handles.feat,1),length(SWR_feat_num));
    SWR_vote = [];
    
    for i = 2 : size(handles.autostageTable,1)
        if front_stage ~= handles.autostageTable(i)
            front_stage = handles.autostageTable(i);
            count_changetime_from_head(i) = count_changetime_from_head(i-1) + 1;
        else
            count_from_head(i) = count_from_head(i-1) + 1;
        end
        
        if next_stage ~= handles.autostageTable(handles.pageMax - i + 1)
            next_stage = handles.autostageTable(handles.pageMax - i + 1);
        else
            count_from_bottom(handles.pageMax - i + 1) = count_from_bottom(handles.pageMax - i + 2) + 1;
        end
    end
    
    handles.info = strvcat('Wait for SWR ... ',handles.info);
    set(handles.text_info,'String',handles.info);
    
    for i = 1:length(SWR_feat_num)
        SWR_vote_pre(:,i) = handles.feat(:,SWR_feat_num(i)) > SWR_bound(i,1) & handles.feat(:,SWR_feat_num(i)) < SWR_bound(i,2);
    end
    SWR_vote = SWR_vote_pre;
    for j = 1:length(SWR_feat_num)
        for k = 3:size(handles.feat,1)-2
            if SWR_vote_pre(k,j) == SWR_vote_pre(k-1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k-2,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+1,j) && SWR_vote_pre(k,j) == SWR_vote_pre(k+2,j)
                SWR_vote(k,j) = 1; %0
            else
                SWR_vote(k,j) = 0; %1
            end
        end     
    end
    
    for i = 1:length(SWR_vote)
        sum_SWR_vote(i) = sum(SWR_vote(i,:));
    end
    sum_SWR_vote=sum_SWR_vote';
    
    handles.info = strvcat('Wait for SCD & SCF ... ',handles.info);
    set(handles.text_info,'String',handles.info);
    
    for i = 1 : size(handles.autostageTable,1)
        %SCD
        handles.stage_change_distance(i) = min(count_from_head(i),count_from_bottom(i));
        
        %SCF
        startnum = i - 2;
        endnum = i + 2;
        if startnum <= 0
            startnum = 1;
        end
        if endnum > handles.pageMax
            endnum = handles.pageMax;
        end
        handles.stage_change_freq(i) = count_changetime_from_head(endnum) - count_changetime_from_head(startnum);
        
        %SWR
        if sum_SWR_vote(i) >= 6 %2
            handles.slow_wave_related(i) = 1;
        end
    end
    
    %SWR(slow wave related)
    
    %print low reliability
    handles.low_reliability = [];
    count_low_reliability = 1;
    for i = 1 : length(handles.stage_change_distance)
        %if (handles.stage_change_distance(i) < 2 && handles.slow_wave_related(i) == 1) || (abs(handles.stage_change_freq(i)) >= 2 && handles.slow_wave_related(i) == 1)
        if handles.stage_change_distance(i) < 10 && abs(handles.stage_change_freq(i)) >= 1 && handles.slow_wave_related(i) == 1 
            handles.low_reliability(count_low_reliability) = i;
            count_low_reliability  = count_low_reliability + 1;
        end
    end
    
    
plot_window=10*1;
if mod(data_num,plot_window)==1
   figure('outerposition',get(0,'screensize'));
   count=count+1;
end
subplot(10,1,data_num-plot_window*count)
plot(autostage);hold on;
plot(stage);
end