function ret_result = feat_extract_3_test_3(test_data,fs,ns)

    total = test_data;
    if size((test_data),2) == 3
        %3-channel (new 1299):C3M2,EOG,EMG
        emg_total = total(:,3);
    elseif size((test_data),2) == 4
        %4-channel (new PSG):C3,CZ,EOG,EMG
        emg_total = total(:,4);
    elseif size((test_data),2) == 5
        %5-channel (weiwei PSG):C3,EMG,SUB(L2-R3),L2,R3
        emg_total = total(:,2);
    end
    
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
    feat_result(:,3) = TEO_STFT_PWR(total(:,1),fs,ns); % C3
    ret_result = feat_result;

    
    