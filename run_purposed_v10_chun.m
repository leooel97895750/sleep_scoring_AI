clear 
close all

result_table = zeros(5,5);
totalruletable = zeros(15,6);
result_before = zeros(5,5);

%InputDir = 'D:\kuokuo\Rule_Based_Method\rule based method程式(特徵+判讀)\data\';%channel(EOG_EMG_EEG)\';
%InputDir = 'E:\成大睡眠醫學中心資料\計畫專用\cut_channel_2EEG_2EOG_EMG_mat\';%channel(C3_F4_E1_E2_EMG)\';
%InputDir = 'E:\成大睡眠醫學中心資料\PSG_all\cut_channel_2EEG_2EOG_EMG_mat\train\';   %test\'; %all\'; %
%InputDir = 'E:\成大睡眠醫學中心資料\PSG_final\cut_channel_EOGL_EMG_EEGC3_mat\';%channel(EOG_EMG_EEG)\';
%InputDir = 'E:\AX3_PSG\turned_5_channel_mat\';
%InputDir = 'E:\成大睡眠醫學中心資料\心理系專用\cut_channel_EOG_EMG_EEG_mat\';%channel(EOG_EMG_EEG)\';


% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\MAT\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\MAT\';

% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\';

InputDir = 'C:\Users\leooel97895750\Desktop\stageAI\';
OutputDir = 'C:\Users\leooel97895750\Desktop\stageAI\2022result';

% InputDir = 'D:\孟純\mandywu\睡眠判讀\data\thesis_data\AHI5-15\';
% OutputDir = 'D:\孟純\mandywu\睡眠判讀\data\thesis_data\AHI5-15\';

% 要注意feature_files跟stage_files順序一不一樣
feature_files = dir([InputDir '2022feature\*_feature.dat']); %load all .mat files in the folder
stage_files = dir([InputDir '2022stage\*.dat']); %load all .mat files in the folder
files = dir([InputDir '*.mat']); %load all .mat files in the folder
filesNumber = length(stage_files);
%file = {'s980401'};
    
final_table=[];
train_idx=[3 7 8 11 13 14 17 22 23 28 31 32 35 36 39 40 41 42 43 47 48 54 56 57];
test_idx=[2 4 5 6 9 10 12 15 18 20 24 26 27 30 33 37 38 44 49 51 55 ];
for i = 1:filesNumber
    [result(i,:) table ruletable table2 kappa pred_stage output_reliab(i,:) pred_stage_reliab low_reliability] = multi_scale_auto_staging_Siesta_v10_chun(feature_files(i),stage_files(i),OutputDir); %original(files(i).name(1:end-4));  %
    hyp = load(fullfile(stage_files(i).folder,stage_files(i).name)); 
    totalruletable = ruletable + totalruletable;
    result_table = result_table + table;
    table11(i)={table};
    table12(i)={sp(table)};
    result_before = result_before + table2;     
    hf = figure('outerposition',get(0,'screensize'));
hf=colordef(hf,'white'); %Set color scheme
hf.Color='w'; 
    subplot(411)
    %plot(stage,'b');hold on;
    %plot(stage2,'r');
    hold on;
    W=hyp==0;
    R=hyp==-1;
    bar(R,'FaceColor','#A2142F','BarWidth',1)
    N1=hyp==1;
    bar(N1*-1,'FaceColor','#EDB120','BarWidth',1)
    N2=hyp==2;
    bar(N2*-2,'FaceColor','#77AC30','BarWidth',1)
    N3=hyp==3;
    bar(N3*-3,'FaceColor','#0072BD','BarWidth',1) 
    axis tight;
    ylim([-3 1])
    yticklabels({'N3','N2','N1','W','R'});
    title('human scoring');
    subplot(412)
    %plot(autohyp,'k');
    hold on;
    W=pred_stage_reliab==0;
    R=pred_stage_reliab==4;
    bar(R,'FaceColor','#A2142F','BarWidth',1)
    N1=pred_stage_reliab==1;
    bar(N1*-1,'FaceColor','#EDB120','BarWidth',1)
    N2=pred_stage_reliab==2;
    bar(N2*-2,'FaceColor','#77AC30','BarWidth',1)
    N3=pred_stage_reliab==3;
    bar(N3*-3,'FaceColor','#0072BD','BarWidth',1) 
    for i=1:length(low_reliability)
        second_block = patch([low_reliability(i),low_reliability(i)+1,low_reliability(i)+1,low_reliability(i)], [1 1 -3 -3], 'b');
        second_block.FaceAlpha = 0.5;second_block.EdgeAlpha = 0;
        hold on; 
    end
    title('human-machine collaborative scoring');
    hold on
    grid on
    ACC=length(find(hyp==pred_stage_reliab))/length(hyp)*100;
    epoch_length =length(hyp);
%     hr_percent = 0; hr_agr = 0; lr_agr = 0;count_low_reliability=length(low_reliability_idx);
%     hr_percent = round(((epoch_length - count_low_reliability + 1)/epoch_length)*100,2);
%     compare_index = 1;count_high = 0;count_low =0;
%     for j = 1 : epoch_length
%         if j == low_reliability_idx(compare_index) && compare_index < count_low_reliability - 1 %low
%             if pred_hyp(j) == hyp(j)
%                 count_low = count_low + 1;
%             end
%             compare_index = compare_index + 1;
%         else                                    %high
%             if pred_hyp(j) == hyp(j)
%                 count_high = count_high + 1;
%             end
%         end
%     end
%     hr_agr = round(((count_high)/(epoch_length - count_low_reliability + 1))*100,2);
%     lr_agr = round(((count_low)/(count_low_reliability - 1))*100,2); 
%     total_table(i,:) =[hr_percent hr_agr lr_agr];
    %if result(i,7) <75
%         hyp = load(fullfile(hyp_files(i).folder,hyp_files(i).name));
%         pred_hyp(pred_hyp==4)=-1;
%         figure('outerposition',get(0,'screensize'));
%         ACC=mean(hyp==pred_hyp)*100;
%         subplot(2,1,1)
%         stairs(hyp*-1)
%         title(hyp_files(i).name)
%         subplot(2,1,2)
%         stairs(pred_hyp*-1)
%         title(['ACC = ' num2str(ACC,'%.2f') '%'])
%         saveas(gcf,strcat(OutputDir,feature_files(i).name(1:end-12),'with_reliability','.jpg'));
%         close all
    %end
end
% for i = 1:filesNumber
%     
% hyp = load(strcat(hypDir,files(i).name(1:end-4),'_hyp.dat')); 
%     W=hyp==0;
%     tmp=find(W==0);
%     SE(i)=length(tmp)/length(hyp);
%     TST(i)=length(tmp)/2;
%     SOT(i)=tmp(1)/2;
%     tmp=find(W(tmp(1):end)==1);
%     WASOT(i)=length(tmp)/2;
%     [result(i,:) table ruletable table2] = multi_scale_auto_staging_Siesta_v10_chun(files(i).name(1:end-4)); %original(files(i).name(1:end-4));  %
%     totalruletable = ruletable + totalruletable;
%     result_table = result_table + table;
%     table11(i)={table};
%     table12(i)={sp(table)};
%     result_before = result_before + table2;
% end
      final_table(1:5,1:5)=result_table;
    final_table(1,6)=result_table(1,1)/sum(result_table(1,:))*100 ;
    final_table(2,6)=result_table(2,2)/sum(result_table(2,:))*100 ;
    final_table(3,6)=result_table(3,3)/sum(result_table(3,:))*100 ;
    final_table(4,6)=result_table(4,4)/sum(result_table(4,:))*100 ;
    final_table(5,6)=result_table(5,5)/sum(result_table(5,:))*100 ;
    final_table(6,6)=(result_table(1,1)+result_table(2,2)+result_table(3,3)+result_table(4,4)+result_table(5,5))/...
        (sum(result_table(:,1))+sum(result_table(:,2))+sum(result_table(:,3))+sum(result_table(:,4))+sum(result_table(:,5)))*100;
    
    csvwrite(strcat(OutputDir,'\','result.csv'),result);