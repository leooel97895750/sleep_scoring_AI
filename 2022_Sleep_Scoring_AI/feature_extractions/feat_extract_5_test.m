% clear all
function ret_result = feat_extract_5_test(ini_data,fs,ns)
%% channel 1:C3 2:C4 3:F3 4:F4 5:O1 6:O2 7:E1(EOG) 8:E2(EOG) 9:EMG
    
%%
%2022取消註解
ini_data=ini_data.data;

if size(ini_data,1) < size(ini_data,2)
    ini_data=ini_data';
end
total = double(ini_data(:,[1 4 7 8 9]));
    eog_total = total(:,4);
    emg_total = total(:,5);
    eeg_c3_total = total(:,2); %%  大鍋寫的

    L_total = length(total);
    %fs = 200;                   % Sample frequency
    epoch = fs*30;
    epoch_overlapping = ns*fs;    %考慮時序問題:多看前後ns秒
    window = 2*fs;              %使用的窗函數:2秒算一次
    nfft = 2^nextpow2(window);  %nextpow2() :靠最近(且比他大的)的2的指?
    % nfft = window;
    noverlap = 0;
    % 2^nextpow2(L)
    eog_feat = zeros(floor(L_total/epoch),4);   %floor去除小數
    emg_feat = zeros(floor(L_total/epoch),3);
    eeg_c3_feat = zeros(floor(L_total/epoch),10);

    %feat = zeros(floor(L_total/epoch),17);
    feat = zeros(floor(L_total/epoch),14);
    for epoch_seq=1 : floor(L_total/epoch) 
        if epoch_seq == 1   %head
            epoch_eog_total = eog_total(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_emg_total = emg_total(1 : epoch_seq*epoch + epoch_overlapping);
            epoch_eeg_c3_total = eeg_c3_total(1 : epoch_seq*epoch + epoch_overlapping);
        elseif epoch_seq == floor(L_total/epoch)   %tail
            epoch_eog_total = eog_total(1+(epoch_seq-1)*epoch - epoch_overlapping : epoch_seq*epoch);
            epoch_emg_total = emg_total(1+(epoch_seq-1)*epoch - epoch_overlapping  : epoch_seq*epoch);
            epoch_eeg_c3_total = eeg_c3_total(1+(epoch_seq-1)*epoch - epoch_overlapping  : epoch_seq*epoch);
        else
            epoch_eog_total = eog_total(1+(epoch_seq-1)*epoch - epoch_overlapping  : epoch_seq*epoch + epoch_overlapping);
            epoch_emg_total = emg_total(1+(epoch_seq-1)*epoch - epoch_overlapping  : epoch_seq*epoch + epoch_overlapping);
            epoch_eeg_c3_total = eeg_c3_total(1+(epoch_seq-1)*epoch - epoch_overlapping  : epoch_seq*epoch + epoch_overlapping);
        end

        [Amp1,f1,t1,p1] = spectrogram(epoch_eeg_c3_total,window,noverlap,nfft,fs);
        [Amp2,f2,t2] = spectrogram(epoch_eog_total,window,noverlap,nfft,fs);
        [Amp3,f3,t3] = spectrogram(epoch_emg_total,window,noverlap,nfft,fs);

        Amp1 = abs(Amp1);
        Amp2 = abs(Amp2);
        Amp3 = abs(Amp3);
        
    %     figure
    %     contour(t1,f1,(abs(Amp1)));
    %     shading flat
    %     xlabel('Time');
    %     ylabel('Frequency (Hz)');
    
        [hwin, times] = size(Amp1);      % hwin = amplitude vector(橫行數), times = FFT 次數(直列數)

        tmp_sum1 = zeros(times,6);    % C3 channel
        tmp_sum2 = zeros(times,2);    % eog
        tmp_sum3 = zeros(times,1);    % emg
        j = 1;

        %%%  power  %%%
        while j <=times
               for i = 1 : hwin


                    if (0.16<f1(i)) && (f1(i)<=4)   % 取出 feature (特徵) 0 ~ 4 Hz

                        tmp_sum1( j,1) = tmp_sum1( j,1) + Amp1(i, j);   % eeg 0-4E
                        tmp_sum2( j,1) = tmp_sum2( j,1) + Amp2(i, j);   % eog 0-4O
%                       tmp_sum3( j,1) = tmp_sum3( j,1) + Amp3(i, j);   % emg 0-4M 

                    end


                    if (4<f1(i)) && (f1(i)<=8)  % 取出 feature (特徵) 4 ~ 8 Hz

                        tmp_sum1( j,2) = tmp_sum1( j,2) + Amp1(i, j);   % eeg 4-8E
    %                   tmp_sum2( j,2) = tmp_sum2( j,2) + Amp2(i, j);   % eog 4-8O                   
    %                   tmp_sum3( j,2) = tmp_sum3( j,2) + Amp3(i, j);   % emg 4-8M 

                    end

                    if (8<f1(i)) && (f1(i)<=13)   % 取出 feature (特徵) 8 ~ 13 Hz (Alpha波)
                        tmp_sum1( j,3) = tmp_sum1( j,3) + Amp1(i, j);   % eeg 8-13E
    %                   tmp_sum2( j,3) = tmp_sum2( j,3) + Amp2(i, j);   % eog 8-13O  
    %                   tmp_sum3( j,3) = tmp_sum3( j,3) + Amp3(i, j);   % emg 8-13M                                       
                    end

                    if  (13<f1(i)) && (f1(i)<=22)   % 取出 feature (特徵) 13 ~ 22 Hz
                        tmp_sum1( j,4) = tmp_sum1( j,4) + Amp1(i, j);   % eeg 13-22E
    %                   tmp_sum2( j,4) = tmp_sum2( j,4) + Amp2(i, j);   % eog 13-22O 
    %                   tmp_sum3( j,4) = tmp_sum3( j,4) + Amp3(i, j);   % emg 13-22M                                       
                    end  


    %               if  (16<f1(i)) && (f1(i)<=18)   % 取出 feature (特徵) 16 ~ 18 Hz              
    %                   tmp_sum1( j,6) = tmp_sum1( j,6) + Amp1(i, j);   % eeg 16-18E
    %                   tmp_sum2( j,6) = tmp_sum2( j,6) + Amp2(i, j);   % eog 16-18O  
    %                   tmp_sum3( j,6) = tmp_sum3( j,6) + Amp3(i, j);   % emg 16-18M                                        
    %               end

                    if  (22<f1(i)) && (f1(i)<=30)   % 取出 feature (特徵) 22 ~ 30 Hz
                        tmp_sum1( j,5) = tmp_sum1( j,5) + Amp1(i, j);   % eeg 22-30E
    %                   tmp_sum2( j,6) = tmp_sum2( j,6) + Amp2(i, j);   % eeg 22-30O  
    %                   tmp_sum3( j,6) = tmp_sum3( j,6) + Amp3(i, j);   % eeg 22-30M   

                    end


                    if  (0.16<f1(i)) && (f1(i)<=30) % 取出 feature (特徵) 0 ~ 30 Hz
                        tmp_sum1( j,6) = tmp_sum1( j,6) + Amp1(i, j);   % eeg 0-30E
                        tmp_sum2( j,2) = tmp_sum2( j,2) + Amp2(i, j);   % eog 0-30O   
                        tmp_sum3( j,1) = tmp_sum3( j,1) + Amp3(i, j);   % emg 0-30M   

                    end

               end
               
    %                 if  (tmp_sum2(j,3) >= tmp_sum2(j,4))       %% count number(theta > alpha)
    %                     ta_count(loop) = ta_count(loop) + 1;
    %                 end


                j = j+1;
        end 

        %%%  frequency mean & std  %%%
        mult_vector = ones(times,1);  % for calculating total power
        fre_hi = 77 ;

        %%%  sep f1 row or column  %%%
        [f1_row,f1_column] = size(f1);
        if f1_row > f1_column
           f1 = f1'; 
        end

        %%  f1,f2,f3 : all the same
        tot_fre_power1 = Amp1(1:fre_hi,:) * mult_vector ;                                               % EEG Total frequency power
        mean_fre1 = f1(1:fre_hi) * tot_fre_power1 / sum(tot_fre_power1);                                % EEG Mean frequency
        std_fre1 = sqrt( ((f1(1:fre_hi) - mean_fre1).^2) * tot_fre_power1 / sum(tot_fre_power1));       % EEG Std frequency

        tot_fre_power2 = Amp2(1:fre_hi,:) * mult_vector  ;                                              % EOG Total frequency power
        mean_fre2 = f1(1:fre_hi) * tot_fre_power2 / sum(tot_fre_power2);                                % EOG Mean frequency
        std_fre2 = sqrt( ((f1(1:fre_hi) - mean_fre2).^2) * tot_fre_power2 / sum(tot_fre_power2));       % EOG Std frequency

        tot_fre_power3 = Amp3(1:fre_hi,:) * mult_vector ;                                               % EMG Total frequency power 
        mean_fre3 = f1(1:fre_hi) * tot_fre_power3 / sum(tot_fre_power3);                                % EMG Mean frequency
        std_fre3 = sqrt( ((f1(1:fre_hi) - mean_fre3).^2) * tot_fre_power3 / sum(tot_fre_power3));       % EMG Std frequency 

        tmp_sum1 = tmp_sum1' * mult_vector ./ times;
        tmp_sum1(1:5) = tmp_sum1(1:5) ./ tmp_sum1(6);   % 將EEG的0-4 Hz、4-8 Hz、8-13 Hz、13-22 Hz和22-30 Hz皆除以0-30 Hz

        tmp_sum2 = tmp_sum2' * mult_vector ./ times;    % 將EOG的0-4 Hz除以0-30O
        tmp_sum2(1) = tmp_sum2(1) ./ tmp_sum2(2);

        tmp_sum3 = tmp_sum3' * mult_vector ./ times;    % Total power of 0-30 Hz EMG

        feat(epoch_seq,1:6) = tmp_sum1;                         % 0-4 Hz/0-30 Hz、4-8 Hz/0-30 Hz、8-13 Hz/0-30 Hz、13-22 Hz/0-30 Hz、22-30 Hz/0-30 Hz and Total power of 0-30 Hz EEG
        feat(epoch_seq,7) = tmp_sum1(1) ./ tmp_sum1(2);         %
        feat(epoch_seq,8) = tmp_sum1(3) ./ tmp_sum1(2);         %
        feat(epoch_seq,9) = mean_fre1;                          % EEG Mean frequency
        feat(epoch_seq,10) = std_fre1;                          % EEG Std frequency
        feat(epoch_seq,11:12) = tmp_sum2;                       % 0-4 Hz/0-30 Hz and Total power of 0-30 Hz EOG
        feat(epoch_seq,13) = mean_fre2;                         % EOG Mean frequency
        feat(epoch_seq,14) = std_fre2;                          % EOG Std frequency
        %feat(epoch_seq,15) = tmp_sum3;                          % Total power of 0-30 Hz EMG
        %feat(epoch_seq,16) = mean_fre3;                         % EMG Mean frequency
        %feat(epoch_seq,17) = std_fre3;                          % EMG Std frequency

    end

    % Total power of 0-30 Hz 皆做取log後乘以20之處理 %
    feat(:,6) = 20.*log10(feat(:,6));    
    feat(:,12) = 20.*log10(feat(:,12)); 
    ret_result = feat;
