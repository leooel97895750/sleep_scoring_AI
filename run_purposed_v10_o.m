clear 
result_table = zeros(5,5);
totalruletable = zeros(15,6);
result_before = zeros(5,5);

%InputDir = 'D:\kuokuo\Rule_Based_Method\rule based method程式(特徵+判讀)\data\';%channel(EOG_EMG_EEG)\';
%InputDir = 'E:\成大睡眠醫學中心資料\計畫專用\cut_channel_2EEG_2EOG_EMG_mat\';%channel(C3_F4_E1_E2_EMG)\';
%InputDir = 'E:\成大睡眠醫學中心資料\PSG_all\cut_channel_2EEG_2EOG_EMG_mat\train\';   %test\'; %all\'; %
%InputDir = 'E:\成大睡眠醫學中心資料\PSG_final\cut_channel_EOGL_EMG_EEGC3_mat\';%channel(EOG_EMG_EEG)\';
%InputDir = 'E:\AX3_PSG\turned_5_channel_mat\';
%InputDir = 'E:\成大睡眠醫學中心資料\心理系專用\cut_channel_EOG_EMG_EEG_mat\';%channel(EOG_EMG_EEG)\';

InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠中心(大郭舊data)\all_MAT\';
%InputDir = 'D:\孟純\mandywu\睡眠判讀\data\睡眠data\子計畫五\data_mat_0111\';
files = dir([InputDir '*.mat']); %load all .mat files in the folder
filesNumber = length(files);
%file = {'s980401'};
    
    final_table=[];
train_idx=[3 7 8 11 13 14 17 22 23 28 31 32 35 36 39 40 41 42 43 47 48 54 56 57];
test_idx=[2 4 5 6 9 10 12 15 18 20 24 26 27 30 33 37 38 44 49 51 55 ];
for i = 1:length(test_idx)
    [result(i,:) table ruletable table2] = multi_scale_auto_staging_Siesta_v10_o(files(test_idx(i)).name(1:end-4)); %original(files(i).name(1:end-4));  %
    totalruletable = ruletable + totalruletable;
    result_table = result_table + table;
    table11(i)={table};
    table12(i)={sp(table)};
    result_before = result_before + table2;
end
% for i = 1:filesNumber
%     [result(i,:) table ruletable table2] = multi_scale_auto_staging_Siesta_v10_o(files(i).name(1:end-4)); %original(files(i).name(1:end-4));  %
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