function feat_result = feat_extract_8_test_new(test_data,fs,ns)
tic
channel_idx=[1 4 7 8 9];
  %%  
  %2022取消註解
test_data=test_data.data;

    if size(test_data,1) < size(test_data,2)
        test_data=test_data';
    end
    EXGsignal=[];
    %  c4 f4 o2 EOG1 EOG2 EMG   
    EXGsignal= double(test_data(:,[1 4 7 8 9]));

     count=2;
    Length = length(test_data);
    %fs = 200;                   % Sample frequency
    epoch_sec = fs*30;
    epoch=floor(Length/epoch_sec);
    t = [1:Length]/fs;
    %ns = 2;    %考慮時序問題:多看前後ns秒
    epoch_overlapping = 0; %ns*fs;    %考慮時序問題:多看前後ns秒
    %%%fft short window parameter  
    window = 1*fs;      %使用的窗函數:1秒算一次
    overlap_coefficient=0;
    overlap = overlap_coefficient*window ;     
    nfft = 2^nextpow2(window);  %nextpow2() :靠最近(且比他大的)的2的指數
    %%%%%%fft long window parameter  
    long_window = 3*fs;      %使用的窗函數:3秒算一次
    overlap_coefficient=0;
    long_overlap = overlap_coefficient*long_window ;     
    long_nfft = 2^nextpow2(long_window);  %nextpow2() :靠最近(且比他大的)的2的指數
    %%%
    hi_fre_feat=[];SS_feat=[];
    for epoch_num=1:epoch
        %% Arousal  feature
        %%%initial variable
        total_arousal=0;
        %%small window
        times=floor((epoch_sec/window-window/fs)/(1-overlap_coefficient)+1);
        if mod(nfft,2)==0
            Amp=zeros(length(channel_idx),nfft/2+1,times);  %對於實信號x，如果nfft為偶數，則S的行數為(nfft/2+1)，如果nfft為奇數，則行數為(nfft+1)/2
            f=zeros(length(channel_idx),nfft/2+1);
        else
            Amp=zeros(length(channel_idx),(nfft+1)/2,times);
            f=zeros(length(channel_idx),(nfft+1)/2);
        end
        t1=zeros(length(channel_idx),times);
        tmp_sum = zeros(times,1,length(channel_idx));    % 
        %%long window
        long_times=10;%floor((epoch_sec/long_window-long_window/fs)/(1-overlap_coefficient)+1);
        if mod(long_nfft,2)==0
            long_Amp=zeros(length(channel_idx),long_nfft/2+1,long_times);  %對於實信號x，如果nfft為偶數，則S的行數為(nfft/2+1)，如果nfft為奇數，則行數為(nfft+1)/2
            long_f=zeros(length(channel_idx),long_nfft/2+1);
        else
            long_Amp=zeros(length(channel_idx),(long_nfft+1)/2,long_times);
            long_f=zeros(length(channel_idx),(long_nfft+1)/2);
        end
        long_t1=zeros(length(channel_idx),long_times);
        long_tmp_sum = zeros(long_times,1,length(channel_idx));    % 
        
        epoch_EXGsignal_seg=[];
        noise_signal=[];
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
            if i<=2
                if(mean(abs(epoch_EXGsignal_seg(:,i)))>25)
                    noise_signal=[noise_signal,i];
                end
            end
            %%  short window fft ->high frequency
            [Amp(i,:,:),f(i,:),t1(i,:)] = spectrogram(epoch_EXGsignal_seg(:,i),window,overlap,nfft,fs);
            [idx, hwin,times] = size(Amp);     % hwin = amplitude vector(橫行數),%times = FFT 次數(直列數)
            Amp=abs(Amp);
            j = 1;
                    %%% FFT
            %%%  power  %%%
            while j <=times
                   for k = 1 : hwin
                        if  (13<f(i,k)) && (f(i,k)<=30)   % 取出 feature (特徵) 13 ~ 30 Hz Hifre belta
                            tmp_sum(j,1,i) = tmp_sum(j,1,i) + Amp(i,k,j);   %        
                        end
                   end
                j = j+1;
            end
            frequency_hifre_seg_sum_1(:,:) = tmp_sum(:,1,i);
            feat_hifre(:,i)=frequency_hifre_seg_sum_1;     
            %frequency_hifre_seg_sum_2(:,:) = tmp_sum(:,2,i);
            %feat_tmp(:,2*i)=frequency_hifre_seg_sum_2;
             %% long window fft ->big slow wave in arousal
            [long_Amp(i,:,:),long_f(i,:),long_t1(i,:)] = spectrogram(epoch_EXGsignal_seg(:,i),long_window,long_overlap,long_nfft,fs);
            [idx, hwin,times] = size(long_Amp);     % hwin = amplitude vector(橫行數),%times = FFT 次數(直列數)
            long_Amp=abs(long_Amp);
            j = 1;
                    %%% FFT
            %%%  power  %%%
            while j <=times
                   for k = 1 : hwin
                        if  (0<long_f(i,k)) && (long_f(i,k)<=4)   % 取出 feature (特徵) 0-40 Hz slow wave
                            long_tmp_sum(j,1,i) = long_tmp_sum(j,1,i) + long_Amp(i,k,j);   %        
                        end
                   end
                j = j+1;
            end
            slowwave_seg_sum(:,:) = long_tmp_sum(:,1,i);
            feat_slowwave_o(:,i)=slowwave_seg_sum;     
            feat_slowwave=repelem(feat_slowwave_o(:,i),3);
        end
        hi_fre_feat=[hi_fre_feat;feat_hifre];  
        SS_feat=[SS_feat;feat_slowwave];  
        
        feat_EMGhifre(epoch_num)=mean(abs(feat_hifre(:,5)));
    end
    
    threshold=mean(hi_fre_feat(:,1))+1*std(hi_fre_feat(:,1));    %2500;
    threshold2=mean(hi_fre_feat(:,1))+0.5*std(hi_fre_feat(:,1));  %2000;
    amp_threshold=mean(abs(EXGsignal(:,1)))+2*std(abs(EXGsignal(:,1)));
    for epoch_num=1:epoch
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
        end
        amplitude_c4_sec=[];amplitude_f4_sec=[];amplitude_emg_sec=[];
        
        if epoch_num>30%%>10才開始抓arousal
            total_arousal=0;
            %%%arousal
            aro_epoch_feat_c4=hi_fre_feat((epoch_num-1)*30+1:epoch_num*30,1);%
            aro_epoch_feat_f4=hi_fre_feat((epoch_num-1)*30+1:epoch_num*30,2);
            aro_epoch_feat_emg=hi_fre_feat((epoch_num-1)*30+1:epoch_num*30,5);
            if noise_signal==1%% remove 雜訊channel
                aro_epoch_feat_c4=zeros(1,30);
            elseif noise_signal==1
                aro_epoch_feat_f4=zeros(1,30); 
            end
            isHead = 0;
            aro_end=0;
            block_index=[];
            aro_flag=zeros(30,1);pre_aro_flag=zeros(30,1);
            %amp_threshold=20;
            threshold_list_c4=[];threshold_list_f4=[];threshold_list_o2=[];threshold_list_emg=[];
            for sec=1:30
                amplitude_c4_sec(sec)=max(abs(epoch_EXGsignal_seg((sec-1)*fs+1:sec*fs,1)))';
                amplitude_f4_sec(sec)=max(abs(epoch_EXGsignal_seg((sec-1)*fs+1:sec*fs,2)))';
                amplitude_emg_sec(sec)=max(abs(epoch_EXGsignal_seg((sec-1)*fs+1:sec*fs,5)))';
                vote=0;
                if isHead==0
                    if aro_epoch_feat_c4(sec)>threshold
                        vote=vote+1;
                    end
                    if aro_epoch_feat_f4(sec)>threshold
                        vote=vote+1;
                    end
                    if aro_epoch_feat_emg(sec)>threshold
                        vote=vote+1;
                    end
                    if vote>=2 ||(amplitude_c4_sec(sec)>amp_threshold && amplitude_f4_sec(sec)>amp_threshold)
                        block_index(end+1)=sec;
                        isHead = 1; 
                    end
                       %aro_count(epoch_num)=aro_count(epoch_num)+1; 
                elseif  isHead==1 
                    if aro_epoch_feat_c4(sec)<threshold
                        vote=vote-1;
                    end
                    if aro_epoch_feat_f4(sec)<threshold
                        vote=vote-1;
                    end
                    if aro_epoch_feat_emg(sec)<threshold
                        vote=vote-1;
                    end
                   if vote<1 
                       block_index(end+1)=sec-1;
                       isHead = 0;
                   %elseif (amplitude_c4_sec(sec)<amp_threshold && amplitude_f4_sec(sec)<amp_threshold)
                    %   block_index(end+1)=sec-1;
                   %    isHead = 0;
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
                    vote=0;
                    if aro_epoch_feat_c4(j)>threshold2
                        vote=vote+1;
                    end
                    if aro_epoch_feat_f4(j)>threshold2
                        vote=vote+1;
                    end
                    if aro_epoch_feat_emg(j)>threshold2 
                        vote=vote+1;
                    end
                    if vote>=2
                        tmp_count=tmp_count+1;
                    else
                        i=i+1;
                        break;
                    end
                end        
                if tmp_count==b-a+1
                    block_index(i*2:i*2+1)=[];
                end
            end
         %畫出區間，刪除過小的區間
%             plot_window=7*2;
%             if mod(epoch_num,plot_window)==1
%                figure('outerposition',get(0,'screensize'));
%                count=count+1;
%             end
%             subplot(7,2,epoch_num-plot_window*count)
%             %plot(t_seg,repelem(aro_epoch_feat_c4,fs),'b');hold on; 
%             %plot(t_seg,repelem(aro_epoch_feat_f4,fs)),'k';hold on; 
%             %plot(t_seg,repelem(aro_epoch_feat_o2,fs),'g');hold on; 
%             %plot(t_seg,repelem(aro_epoch_feat_emg,fs),'r');hold on; 
%             %plot(t_seg,repelem(threshold_list_c4,fs),'b.');hold on; 
%             %plot(t_seg,repelem(threshold_list_f4,fs),'k');hold on; 
%             %plot(t_seg,repelem(threshold_list_o2,fs),'g');hold on; 
%             %plot(t_seg,repelem(threshold_list_emg,fs),'r');hold on; 
%              plot(t_seg,epoch_EXGsignal_seg(:,1)+200);hold on; 
%              plot(t_seg,epoch_EXGsignal_seg(:,2)+100);hold on; 
%              plot(t_seg,epoch_EXGsignal_seg(:,5),'k');hold on; 
%              title(num2str(epoch_num));%ylim([0 3000])
            %%plot arousal block
            for point = 1:length(block_index)/2
                index1_b = (block_index(point*2-1)-1)*fs+1;%
                index2_b = block_index(point*2)*fs;
                if (t_seg(index2_b) - t_seg(index1_b)) >= 3
                    total_arousal=total_arousal+(t_seg(index2_b) - t_seg(index1_b));
%                      second_block = patch([t_seg(index1_b) t_seg(index2_b) t_seg(index2_b) t_seg(index1_b)], [300 300 -100 -100], 'b');
%                      second_block.FaceAlpha = 0.2;
%                      hold on; 
                end
            end
            %%%
        end
        if length(noise_signal)==2
           feat_aro(epoch_num)=30;
        else
           feat_aro(epoch_num)=total_arousal;
        end
    end
    
       %% REM feature
    loc_total =  EXGsignal(:,3);
    roc_total =  EXGsignal(:,4);
    eog_total = roc_total-loc_total;
    %%% total parameter
    Length = length(EXGsignal(:,1));      
    velocity_th = 0.5;
    cross_th = 3.5*median(abs(eog_total));
    
    % filter for REM, exluded SEM and high frequency EM
    [x1,y1] = butter(8, 6/(fs/2),'low'); % 8 order butter worth filter
    L_fil_0_6 = filter(x1,y1,loc_total(:)); 
    R_fil_0_6 = filter(x1,y1,roc_total(:));
    
    em_velocity = abs([0; diff(R_fil_0_6)]);
    window_count=-1;
    for epoch_seq=1 : epoch
        total_wink=0;
        epoch_eog_total = eog_total(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        epoch_roc_total = roc_total(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        epoch_loc_total = loc_total(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        t_seg = t(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        num_cross = 1;
        count = 0;
        abs_epoch_eog = abs(epoch_eog_total);
        abs_epoch_eog = abs_epoch_eog - cross_th;
         
        for seq_data = 2:epoch % line cross
            if abs_epoch_eog(seq_data) * abs_epoch_eog(seq_data-1) < 0 || abs_epoch_eog(seq_data) == 0
                count = count + 1;
                if count == 2
                    num_cross = num_cross + 1;
                    count = 0;
                end
            end
        end
        amp_eog1 = mean(abs(epoch_eog_total));                  % EOG Amp (將epoch的值取絕對值後算其平均)
        amp_eog1 = amp_eog1 *amp_eog1 ;
        amp_eog2 = num_cross;
        
        % feat eye movement
        %%%%%%%%%%%%plot%%%%%%%%%%%%%%%
%         plot_window=10*2;
%         if mod(epoch_seq,plot_window)==1
%             figure('outerposition',get(0,'screensize'));
%             window_count=window_count+1;
%         end
%         subplot(10,2,epoch_seq-plot_window*window_count)
%         plot(t_seg,epoch_loc_total,'Color','#750000');hold on; 
%         plot(t_seg,epoch_roc_total,'Color','#5B00AE');hold on; 
%         title(num2str(epoch_seq));
        %%%%%%%%%%%%%%%%
        em_num = 0.1;
        L_fil_0_6_epoch = L_fil_0_6(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        R_fil_0_6_epoch = R_fil_0_6(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
        
        win_size = fs*2;
        win_num = length(L_fil_0_6_epoch) / win_size;
        for seq_data = 1 : win_num
            filtered_win_L = L_fil_0_6_epoch(1 + (seq_data-1) * win_size : seq_data * win_size);
            filtered_win_R = R_fil_0_6_epoch(1 + (seq_data-1) * win_size : seq_data * win_size);
            em_velocity_epoch = em_velocity(1+(epoch_seq-1)*epoch_sec : epoch_seq*epoch_sec);
            [r,p] = corrcoef(filtered_win_L, filtered_win_R ); % loc與roc的相關係數
            if r(1,2) <= -0.9 && mean(em_velocity_epoch(1 + (seq_data-1) * win_size : seq_data * win_size)) > 0.5%velocity_th% 小於-0.2視為有眼動
                em_num = em_num +1;
                if seq_data<win_num
                    total_wink=total_wink+(t_seg(seq_data * win_size)-t_seg(1 + (seq_data-1) * win_size));
%                     second_block = patch([t_seg(1 + (seq_data-1) * win_size) t_seg(seq_data * win_size) t_seg(seq_data * win_size) t_seg(1 + (seq_data-1) * win_size)], [100 100 -100 -100], 'b');
%                     second_block.FaceAlpha = 0.2;
%                     hold on; 
                end
            end
        end
        feat_REM(epoch_seq)=total_wink;
    end
    % high fre EMG
%     %% noise feat
%     for epoch_num=1:epoch
%         if epoch_num == 1   %head
%             epoch_EXGsignal_seg(:,i) = EXGsignal(1 : epoch_num*epoch_sec + epoch_overlapping,i);
%              t_seg =t(1 : epoch_num*epoch_sec + epoch_overlapping);
%         elseif epoch_num == epoch   %tail
%             epoch_EXGsignal_seg(:,i) = EXGsignal((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec,i);
%             t_seg=t((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec);
%         else
%             epoch_EXGsignal_seg(:,i) = EXGsignal((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec + epoch_overlapping,i);
%             t_seg=t((epoch_num-1)*epoch_sec - epoch_overlapping+1 : epoch_num*epoch_sec + epoch_overlapping);
%         end
%         if i<=2
%             if(mean(abs(epoch_EXGsignal_seg(:,i)))>25)
%                 noise_signal=[noise_signal,i];
%             end
%         end
%         if length(noise_signal)==1
%             feat_noise(epoch_num)=1;
%         else
%             feat_noise(epoch_num)=0;
%         end
%     end
    %%%%
    feat_result(:,1)=feat_aro;
    feat_result(:,2)=feat_REM;
    feat_result(:,3)=feat_EMGhifre;
toc


