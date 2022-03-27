% clear all
function feat_result = feat_extract_6_test(test_data,fs,ns)
%% channel 1:C3 2:C4 3:F3 4:F4 5:O1 6:O2 7:E1(EOG) 8:E2(EOG) 9:EMG
    
%%
%2022取消註解
test_data=test_data.data;

if size(test_data,1) < size(test_data,2)
    test_data=test_data';
end
data = double(test_data(:,4)); % F4 Channel
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
    for epoch_seq = 1:floor(length(data)/epoch)
        if epoch_seq == 1   %head
            epoch_data = data(1 : epoch_seq*epoch + epoch_overlapping);
        elseif epoch_seq == floor(length(data)/epoch)   %tail
            epoch_data = data(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
        else
            epoch_data = data(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch + epoch_overlapping);
        end

        fil_8_12_epoch = filter(x1,y1,epoch_data(:));       % alpha filter
        fil_8_12_epoch = filter(x2,y2,fil_8_12_epoch);
        
        fil_18_30_epoch = filter(x3,y3,epoch_data(:));      % beta filter
        
        fil_12_15_epoch = filter(a1,b1,epoch_data(:));      % spindle filter
        fil_12_15_epoch = filter(a2,b2,fil_12_15_epoch);
        
        fil_0_2_epoch = filter(i1,j1,epoch_data(:));        % SWS filter
        
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
    feat_test(:,4) = TEO_STFT_PWR(data,fs,ns); % F4
    feat_result = feat_test;

% toc
