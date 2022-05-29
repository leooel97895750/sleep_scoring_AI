% clear all
function feat_result = feat_extract_6_test(test_data,fs,ns)
%% channel 1:C3 2:C4 3:F3 4:F4 5:O1 6:O2 7:E1(EOG) 8:E2(EOG) 9:EMG
    
test_data=test_data.data;

if size(test_data,1) < size(test_data,2)
    test_data=test_data';
end

data_o1 = double(test_data(:,5)); % O1 Channel
data_o2 = double(test_data(:,6)); % O2 Channel
data_c3 = double(test_data(:,1)); % C3 Channel
data_c4 = double(test_data(:,2)); % C4 Channel
data_f3 = double(test_data(:,3)); % F3 Channel
data_f4 = double(test_data(:,4)); % F4 Channel

epoch = fs*30;
epoch_overlapping = ns*fs;    %考慮時序問題:多看前後ns秒
alpha_seg = fs/2;
coeff_alpha = 0.5;

spindle_seg = fs;
spindle_shift = fs/2;
tot_spindle_seg = (epoch - spindle_seg)/spindle_shift + 1;

th1_SWS = 15;           % set base threshold : up and down amplitude
th2_SWS_p2p = 60;       % set peak to peak threshold 


%%  extract feature
    
    [x1,y1] = butter(8, 12/(fs/2),'low');      % filter for alpha and beta
    [x2,y2] = butter(8, 8/(fs/2),'high');
    [x3,y3] = butter(8,18/(fs/2),'high');
    
    [a1,b1] = butter(8,15/(fs/2),'low');       % filter for spindle
    [a2,b2] = butter(8,12/(fs/2),'high');
    
    [i1,j1] = butter(3,2/(fs/2),'low');        % filter for delta
    
    feat_seq = 1;
    tot_fault = 0;
    for epoch_seq = 1:floor(length(data_o1)/epoch)
        if epoch_seq == 1   %head
            epoch_o1 = data_o1(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_o2 = data_o2(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_c3 = data_c3(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_c4 = data_c4(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_f3 = data_f3(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_f4 = data_f4(1 : epoch_seq*epoch + epoch_overlapping);
        elseif epoch_seq == floor(length(data_o1)/epoch)   %tail
            epoch_o1 = data_o1(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_o2 = data_o2(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_c3 = data_c3(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_c4 = data_c4(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_f3 = data_f3(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_f4 = data_f4(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
        else
            epoch_o1 = data_o1(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
            epoch_o2 = data_o2(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
            epoch_c3 = data_c3(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
            epoch_c4 = data_c4(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
            epoch_f3 = data_f3(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
            epoch_f4 = data_f4(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
        end

        % signal abnormal 處理 (看兩者的訊號震幅，若差異大則選小的使用)
        o1_amp = mean(abs(diff(epoch_o1)));
        o2_amp = mean(abs(diff(epoch_o2)));
        c3_amp = mean(abs(diff(epoch_c3)));
        c4_amp = mean(abs(diff(epoch_c4)));
        f3_amp = mean(abs(diff(epoch_f3)));
        f4_amp = mean(abs(diff(epoch_f4)));
        if o1_amp > o2_amp
            alpha_data = epoch_o2;
            epoch_data = epoch_o2;
        else
            alpha_data = epoch_o1;
            epoch_data = epoch_o1;
        end
        if c3_amp > c4_amp
            spindle_data = epoch_c4;
        else
            spindle_data = epoch_c3;
        end
        if f3_amp > f4_amp
            sws_data = epoch_f4;
        else
            sws_data = epoch_f3;
        end

        fil_8_12_epoch = filter(x1,y1,alpha_data);       % alpha filter
        fil_8_12_epoch = filter(x2,y2,fil_8_12_epoch);
        
        fil_18_30_epoch = filter(x3,y3,alpha_data);      % beta filter
        
        fil_12_15_epoch = filter(a1,b1,spindle_data);      % spindle filter
        fil_12_15_epoch = filter(a2,b2,fil_12_15_epoch);
        
        fil_0_2_epoch = filter(i1,j1,sws_data);        % SWS filter
        
        %%   feature of Alpha ratio   %%
        sub_fault = 0 ;
        for sub_seg_seq = 1: epoch/alpha_seg   
            sub_alpha_wave_ratio(sub_seg_seq) = (mean(abs(fil_8_12_epoch(1+(sub_seg_seq-1)*alpha_seg : sub_seg_seq*alpha_seg))) ...
                                                + mean(abs(fil_18_30_epoch(1+(sub_seg_seq-1)*alpha_seg : sub_seg_seq*alpha_seg)))) ...
                                                / mean(abs(epoch_data(1+(sub_seg_seq-1)*alpha_seg : sub_seg_seq*alpha_seg))) ;
                                            if mean(abs(epoch_data(1+(sub_seg_seq-1)*alpha_seg : sub_seg_seq*alpha_seg))) == 0
                                                sub_fault = 1;
                                                sub_fault_epoch(sub_seg_seq) = 1;
                                            else sub_fault_epoch(sub_seg_seq) = 0;
                                            end
        end
        if sub_fault == 1
            tot_fault = tot_fault + 1;
            fault_epoch(epoch_seq) = 1;
        else
            fault_epoch(epoch_seq) = 0;
        end
%         coeff_alpha = 0.5;
        alpha_wave_ratio = sum(sub_alpha_wave_ratio > coeff_alpha) / (epoch/alpha_seg) ;
        feat_wake(feat_seq) = alpha_wave_ratio;                 % Alpha ratio
        
        %%  feature of Spindle ratio  %%
        
        count_spindle = 0;
        for sub_seg_seq = 1: (epoch - spindle_seg)/spindle_shift + 1
            spindle_seg_amp = fil_12_15_epoch(1+(sub_seg_seq-1)*spindle_shift : sub_seg_seq*spindle_shift + spindle_shift);
            spindle_seg_amp = abs(spindle_seg_amp);
            ratio_spindle = sum(spindle_seg_amp > 4) / spindle_seg;
            if ratio_spindle > 0.45
                count_spindle = count_spindle + 1;
            end        
        end
        feat_n2(feat_seq) = count_spindle / tot_spindle_seg;    % Spindle ratio
        %%  feature of SWS ratio  %%
        
        feat_n3(feat_seq) = SWS_detect_func(fil_0_2_epoch,fs);  % SWS ratio
        
        %%%%%%%%%%%%%%%%%%%%%%%
        feat_seq = feat_seq + 1;
    end  
%     s0202_hyp_part = hyp_mod;
    feat_test(:,1) = feat_wake;
    feat_test(:,2) = feat_n2;
    feat_test(:,3) = feat_n3 ./ 100;
    feat_test(:,4) = TEO_STFT_PWR(spindle_data,fs,ns); % F4 應該用C4 or C3
    feat_result = feat_test;

% toc
