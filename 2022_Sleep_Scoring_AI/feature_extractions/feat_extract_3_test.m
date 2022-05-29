% clear all
function ret_result = feat_extract_3_test(test_data,fs,ns)
%% channel 1:C3 2:C4 3:F3 4:F4 5:O1 6:O2 7:E1(EOG) 8:E2(EOG) 9:EMG

%%
%2022取消註解
test_data=test_data.data;

if size(test_data,1) < size(test_data,2)
    test_data=test_data';
end
total = test_data;
emg_total = total(:,9);     % EMG

L_total = length(total);
%fs = 200;                   % Sample frequency
epoch = fs*30;
epoch_overlapping = ns*fs;    %考慮時序問題:多看前後ns秒
feat_emg = zeros(floor(L_total/epoch),2);
for epoch_seq=1 : floor(L_total/epoch)
    if epoch_seq == 1   %head
        epoch_emg_total = emg_total(1 : epoch_seq*epoch + epoch_overlapping);
    elseif epoch_seq == floor(L_total/epoch)   %tail
        epoch_emg_total = emg_total(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
    else
        epoch_emg_total = emg_total(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
    end
    
    num_cross = 0 ;
    for seq_data = 2:epoch
        if (epoch_emg_total(seq_data) * epoch_emg_total(seq_data-1)) < 0 || epoch_emg_total(seq_data) == 0
            num_cross = num_cross + 1;
        end
    end
    amp_emg1 = mean(abs(epoch_emg_total));                  % EMG Amp (將epoch的值取絕對值後算其平均)
    %         amp_emg2 = sum(abs(epoch_emg_total)) / epoch;
    amp_emg2 = sum(abs(epoch_emg_total)) ./ num_cross;
    feat_emg(epoch_seq,1) = amp_emg1;
    feat_emg(epoch_seq,2) = amp_emg2;
    
end
feat_result(:,1:2) = feat_emg;

% signal abnormal 處理 (看兩者的訊號震幅，若差異大則選小的使用)
c3_amp = mean(abs(diff(total(:,1))));
c4_amp = mean(abs(diff(total(:,2))));
if c3_amp > c4_amp
    spindle_data = total(:,2);
else
    spindle_data = total(:,1);
end
feat_result(:,3) = TEO_STFT_PWR(spindle_data,fs,ns); % C3 or C4
ret_result = feat_result;


