function feat_result = feat_extract_8_test(test_data,fs,ns)
% tic
    %test_data=test_data.data;
    if size(test_data,1) < size(test_data,2)
        test_data=test_data';
    end
    emg = test_data(:,5);     % EMG
    eegc3 = test_data(:,1);     % c3
    eegf4 = test_data(:,2);     % f4
    eoge1 = test_data(:,3);     % EOG1
    eoge2 = test_data(:,4);     % EOG2
    
    Length = length(emg);
    fs = 200;                   % Sample frequency
    epoch_sec = fs*30;
    epoch=floor(Length/epoch_sec);
    ns = 2;    %考慮時序問題:多看前後ns秒
    %% Amplitude
    epoch_overlapping = ns*fs;    %考慮時序問題:多看前後ns秒
    for epoch_seq=1 : epoch
         if epoch_seq == 1   %head
            epoch_emg_total = emg(1 : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eegc3_total = eegc3(1 : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eegf4_total = eegf4(1 : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eoge1_total = eoge1(1 : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eoge2_total = eoge2(1 : epoch_seq*epoch_sec + epoch_overlapping);
         elseif epoch_seq == epoch   %tail
            epoch_emg_total = emg(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec);
            epoch_eegc3_total = eegc3(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec);
            epoch_eegf4_total = eegf4(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec);
            epoch_eoge1_total = eoge1(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec);
            epoch_eoge2_total = eoge2(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec);
         else
            epoch_emg_total = emg(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eegc3_total = eegc3(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eegf4_total = eegf4(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eoge1_total = eoge1(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
            epoch_eoge2_total = eoge2(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
         end
        num_cross = 0 ;
        for seq_data = 2:epoch
            if (epoch_emg_total(seq_data) * epoch_emg_total(seq_data-1)) < 0 || epoch_emg_total(seq_data) == 0
                num_cross = num_cross + 1;
            end
        end
        %feat_amp(epoch_seq,5)= mean(abs(epoch_emg_total));    % EMG Amp (將epoch的值取絕對值後算其平均)
        feat_amp(epoch_seq,1)= mean(abs(epoch_eegc3_total));
        feat_amp(epoch_seq,2)= mean(abs(epoch_eegf4_total)); 
        feat_amp(epoch_seq,3)= mean(abs(epoch_eoge1_total)); 
        feat_amp(epoch_seq,4)= mean(abs(epoch_eoge2_total)); 
    end
%% 眼動
    t = [1:Length]/fs;
    epoch_overlapping = 0;%ns*fs;    %考慮時序問題:多看前後ns秒->設為0,不往前往後看
    count=-1;
    for epoch_seq=1 : epoch
        epoch_eoge1_seg = eoge1(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
        epoch_eoge2_seg = eoge2(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
        t_seg = t(1+(epoch_seq-1)*epoch_sec - epoch_overlapping : epoch_seq*epoch_sec + epoch_overlapping);
           
        % 抓取反向眼動
        % 相減平方法
        % 平滑化
        windowSize = fs/2; 
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        epoch_eoge1_seg_f = filter(b,a,epoch_eoge1_seg);
        epoch_eoge2_seg_f = filter(b,a,epoch_eoge2_seg);
        epoch_eoge1_seg_f1=epoch_eoge1_seg_f;
        epoch_eoge2_seg_f1=epoch_eoge2_seg_f;
        epoch_eoge1_seg_f1(end+1)=epoch_eoge1_seg_f(end);
        epoch_eoge2_seg_f1(end+1)=epoch_eoge2_seg_f(end);
        diff_epoch_eoge1_seg_f=abs(diff(epoch_eoge1_seg_f1));
        diff_epoch_eoge2_seg_f=abs(diff(epoch_eoge2_seg_f1));
        seg_diff = epoch_eoge1_seg - epoch_eoge2_seg;
        abs_seg_diff =  abs(seg_diff);%.^ 2 ;
        %R = corrcoef(diff_epoch_eoge1_seg_f,diff_epoch_eoge2_seg_f)
        for i=1:length(epoch_eoge1_seg)/(fs/2)
            diff_epoch_eoge1_seg_f_05s=diff_epoch_eoge1_seg_f((i-1)*fs/2+1:i*fs/2);
            diff_epoch_eoge2_seg_f_05s=diff_epoch_eoge2_seg_f((i-1)*fs/2+1:i*fs/2);
            R = dtw(diff_epoch_eoge1_seg_f_05s,diff_epoch_eoge2_seg_f_05s);
            R_list(i)=abs(R);
        end
        %%%計算高頻成分
        noverlap = 0;
        window = 1*fs;              %使用的窗函數:2秒算一次
        nfft = 2^nextpow2(window);  %nextpow2() :靠最近(且比他大的)的2的指?
        [Amp1,f1,t1] = spectrogram(epoch_eoge1_seg,window,noverlap,nfft,fs);
        Amp1 = abs(Amp1); [hwin, times] = size(Amp1);      % hwin = amplitude vector(橫行數), times = FFT 次數(直列數)
        tmp_sum1 = zeros(times,1);    % EOG channel
        j = 1;
        while j <=times
              for i = 1 : hwin
                  if  (22<f1(i)) && (f1(i)<=30)   % 取出 feature (特徵) 22 ~ 30 Hz
                        tmp_sum1( j,1) = tmp_sum1( j,1) + Amp1(i, j);   % eog 0-4E1 
                  end
               end
               j = j+1;
        end 
        tmp_sum=repelem(tmp_sum1,fs);
        %%%算眼動的秒數
        threshold_diff=70;                
        block_index = [];
        isHead = 0;
        total_wink = 0;
        for k = 1:length(epoch_eoge1_seg)
            if abs_seg_diff(k) > threshold_diff && isHead == 0  && tmp_sum(k,1)<500
                if k>fs/2 && tmp_sum(k-floor(fs/2),1)<500
                    block_index(end+1) =k-floor(fs/2);%高於threshold的第一個值並往前0.5sec
                else
                    block_index(end+1) =k;
                end
                isHead = 1;

            % 找範圍內是否還有後續
            elseif isHead == 1 && tmp_sum(k,1)<500
                block_max = 0;
                % 以0.5秒為單位
                search = fs/2;
                if k+search <= length(epoch_eoge1_seg)
                    block_max = max(abs_seg_diff(k:k+search));
                else
                    block_max = max(abs_seg_diff(k:length(abs_seg_diff)));
                end
                if block_max < threshold_diff || tmp_sum(k,1)>=500       
                    if k<length(epoch_eoge1_seg)-fs/2
                        block_index(end+1) = k+floor(fs/2);
                    else
                        block_index(end+1) = length(epoch_eoge1_seg);
                    end
                    isHead = 0;
                else
                    if k==length(epoch_eoge1_seg)
                        block_index(end+1) = length(epoch_eoge1_seg);
                        isHead = 0;
                    end
                end
            end
        end

        for k = 1:length(block_index)/2
            index1_b = block_index(k*2-1);
            index2_b = block_index(k*2);
            if (t_seg(index2_b) - t_seg(index1_b)) > 0.5 
                total_wink = total_wink  + (t_seg(index2_b) - t_seg(index1_b));
            end
        end
        feat_EOGMove(epoch_seq,1)=total_wink/30;
    end
    
    %% FFT
    for epoch_num=1:epoch
        %%%initial variable
        times=floor((epoch_sec/window-window/fs)/(1-overlap_coefficient)+1);
        if mod(nfft,2)==0
            Amp=zeros(length(channel_idx),nfft/2+1,times);  %對於實信號x，如果nfft為偶數，則S的行數為(nfft/2+1)，如果nfft為奇數，則行數為(nfft+1)/2
            f=zeros(length(channel_idx),nfft/2+1);
        else
            Amp=zeros(length(channel_idx),(nfft+1)/2,times);
            f=zeros(length(channel_idx),(nfft+1)/2);
        end
        t1=zeros(length(channel_idx),times);
        tmp_sum = zeros(times,7,length(channel_idx));    % 
        epoch_EXGsignal_seg=[];
        
        pre_feat_tmp=feat_tmp;
        for i=1: length(channel_idx)
            if epoch_num == 1   %head
                epoch_EXGsignal_seg(:,i) = EXGsignal(1 : epoch_num*epoch_sec + epoch_overlapping,i);
                 t_seg =t(1 : epoch_num*epoch_sec + epoch_overlapping);
            elseif epoch_num == epoch   %tail
                epoch_EXGsignal_seg(:,i) = EXGsignal((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec,i);
                t_seg=t((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec);
            else
                epoch_EXGsignal_seg(:,i) = EXGsignal((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec + epoch_overlapping,i);
                t_seg=t((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec + epoch_overlapping);
            end
                    
            %%%fft
            [Amp(i,:,:),f(i,:),t1(i,:)] = spectrogram(epoch_EXGsignal_seg(:,i),window,overlap,nfft,fs);
            [idx, hwin,times] = size(Amp);     % hwin = amplitude vector(橫行數),%times = FFT 次數(直列數)
            Amp=abs(Amp);
            j = 1;
            %% FFT
            %%%  power  %%%
            while j <=times
                   for k = 1 : hwin
                        if (0.16<f(i,k)) && (f(i,k)<=4)   % 取出 feature (特徵) 0 ~ 4 Hz
                            tmp_sum(j,1,i) = tmp_sum(j,1,i) + Amp(i,k,j);   % 
                        end
                        if (4<f(i,k)) && (f(i,k)<=8)  % 取出 feature (特徵) 4 ~ 8 Hz Theta
                            tmp_sum(j,2,i) = tmp_sum(j,2,i) + Amp(i,k,j);   % 
                        end
                        if (8<f(i,k)) && (f(i,k)<=13)   % 取出 feature (特徵) 8 ~ 13 Hz (Alpha波)
                            tmp_sum(j,3,i) = tmp_sum(j,3,i) + Amp(i,k,j);   %                           
                        end
                        if  (13<f(i,k)) && (f(i,k)<=30)   % 取出 feature (特徵) 13 ~ 30 Hz Hifre
                            tmp_sum(j,4,i) = tmp_sum(j,4,i) + Amp(i,k,j);   %        
                        end  
                        if  (0.16<f(i,k)) && (f(i,k)<=30) % 取出 feature (特徵) 0 ~ 30 Hz
                            tmp_sum(j,7,i) = tmp_sum(j,7,i) + Amp(i,k,j);   % 
                        end
                         if (0.5<=f(i,k)) && (f(i,k)<=2)   % 取出 feature (特徵) 0.5 ~ 2 Hz SW
                            tmp_sum(j,6,i) = tmp_sum(j,6,i) + Amp(i,k,j);   % 
                         end
                         if (11<=f(i,k)) && (f(i,k)<=16)   % 取出 feature (特徵)  11~ 16 Hz Spindle
                            tmp_sum(j,5,i) = tmp_sum(j,5,i) + Amp(i,k,j);   % 
                        end
                   end
                j = j+1;
            end
       
            %mult_vector = ones(times,1);  % for calculating total power
            fre_hi = 77 ;
            tot_fre_power = reshape(Amp(i,1:fre_hi,:),fre_hi,30);  
            fre = reshape(f(i,1:fre_hi),1,[]);                                             % EEG Total frequency power
            mean_fre(i) = fre * tot_fre_power / sum(tot_fre_power);                                % EEG Mean frequency
            std_fre(i) = sqrt( ((fre - mean_fre(i)).^2) * tot_fre_power / sum(tot_fre_power));       % EEG Std frequency
            
            frequency_seg_sum(:,:) = tmp_sum(:,1:3,i);%' * mult_vector ./ times;
            frequency0_30_seg_sum(:,:) = tmp_sum(:,7,i);
            frequency_spindle_seg_sum(:,:) = tmp_sum(:,5,i);
            frequency_SW_seg_sum(:,:) = tmp_sum(:,6,i);
            frequency_hifre_seg_sum(:,:) = tmp_sum(:,4,i);
            %frequency_seg_sum=frequency_seg_sum./frequency0_30_seg_sum;
            
            feat_tmp(:,7*(i-1)+1:7*i-4) = frequency_seg_sum;  %C3 0-4Hz,4-8Hz,8-13Hz
            feat_tmp(:,7*i-3)=frequency_hifre_seg_sum;
            feat_tmp(:,7*i-2)=frequency_spindle_seg_sum;
            feat_tmp(:,7*i-1)=frequency_SW_seg_sum;
            feat_tmp(:,7*i)=frequency0_30_seg_sum;
        end
    
    %%
    if epoch_num>10%%>10才開始抓arousal
            %%%arousal
            pre_aro_epoch_feat_c4=pre_feat_tmp(:,4);
            pre_aro_epoch_feat_f4=pre_feat_tmp(:,11);
            pre_aro_epoch_feat_o2=pre_feat_tmp(:,18);
            pre_aro_epoch_feat_emg=pre_feat_tmp(:,39);
            aro_epoch_feat_c4=feat_tmp(:,4);%
            aro_epoch_feat_f4=feat_tmp(:,11);
            aro_epoch_feat_o2=feat_tmp(:,18);
            aro_epoch_feat_emg=feat_tmp(:,39);

            threshold2=700;
            isHead = 0;
            aro_end=0;
            block_index=[];
            aro_flag=zeros(30,1);pre_aro_flag=zeros(30,1);
            threshold_c4=1100;threshold_f4=1100;threshold_o2=1100;threshold_emg=1100;
            threshold_list_c4=[];threshold_list_f4=[];threshold_list_o2=[];threshold_list_emg=[];
            total_arousal=0;
            for sec=1:30
                if isHead==0 && aro_epoch_feat_c4(sec)>threshold_c4 && aro_epoch_feat_f4(sec)>threshold_f4&& aro_epoch_feat_emg(sec)>threshold_emg %&& aro_epoch_feat_o2(sec) >threshold_o2  && isHead==0
                    block_index(end+1)=sec;
                    isHead = 1; 
                   %aro_count(epoch_num)=aro_count(epoch_num)+1; 
                elseif  isHead==1 
                   if aro_epoch_feat_c4(sec)<threshold_c4 || aro_epoch_feat_f4(sec)<threshold_f4 || aro_epoch_feat_emg(sec)<threshold_emg%|| aro_epoch_feat_o2(sec)< threshold_o2
                       block_index(end+1)=sec-1;
                       isHead = 0;
                   elseif sec==30
                       block_index(end+1)=sec;
                       isHead = 0;
                   end
                end
                if mod(length(block_index),2)==1 && block_index(end)==30
                    block_index(end+1)=30;
                end
            end
            original_block_index=block_index;
            i=1;
            while(isempty(block_index)==0)
                if i*2==length(block_index)
                    break;
                end
                a=block_index(i*2);
                b=block_index(i*2+1);
                tmp_count=0;
                for j=a:b
                    if  aro_epoch_feat_c4(j)>threshold2 && aro_epoch_feat_f4(j)>threshold2&& aro_epoch_feat_o2(j)>threshold2 && aro_epoch_feat_emg(j)>threshold2
                        tmp_count=tmp_count+1;
                    else
                        i=i+1;
                        break;
                    end
                end        
                if tmp_count==b-a+1
                    %block_index(i*2:i*2+1)
                    block_index(i*2:i*2+1)=[];
                end
            end
            pre_aro_flag=aro_flag;
            if isempty(block_index)==0
                for i=1:length(block_index)/2
                    for j=block_index(2*i-1):block_index(2*i)   
                        aro_flag(j)=1;
                    end
                end
            end
            arousal_flag(epoch_num)=total_arousal/30;
        end
    end
    
    %%
    feat_test(:,1:4) = feat_amp(:,1:4);
    feat_test(:,5) = feat_EOGMove(:,1);
    feat_result = feat_test;

% toc
