function feat_n3 = SWS_detect_func(fil_data,seg)
%% SWS feature
% clear all
% tic
% load FZ_0218_pos1_s2_SWS.mat
% stage = load ('hyp_1_s2_SWS.dat');
% power  = load ('ratio_power_SWS.dat');

% seg = 200;
fs = seg;
epoch = fs * 30;
% shift = 100;
% data = fil_data;

th1_SWS = 20;      % set base threshold : up and down amplitude
th2_SWS_p2p = 70;      % set base threshold : up and down amplitude


%%

fconnect = 1;

    epoch_SWS_amp = fil_data;    %取epoch filtered(0.5~2) data
    
    pos_SWS = find(abs(epoch_SWS_amp) > th1_SWS);   % 儲存超過base threshold的data position
    seq_SWS = 1;    %  initialize skimming pos_SWS
    tmp_start = 1;   %  set the first position of the structure segment over the threshold
    p_site = 1;   % index for storing peak position
    SWS_len = 0; % slow wave length per epoch
    pos_peak = 0;
    %%%%%%　　find peak   %%%%%%
    while seq_SWS < length(pos_SWS)    % skim total possible SWS data 
        if epoch_SWS_amp(pos_SWS(seq_SWS)) > 0   %  sep positive : signal is positive
            if epoch_SWS_amp(pos_SWS(seq_SWS+1)) > 0 & (pos_SWS(seq_SWS+1) - pos_SWS(seq_SWS)) == 1 & seq_SWS < length(pos_SWS)-1 % sep continuous
                seq_SWS = seq_SWS + 1;
            else       %  find the end of the stucture segment
                [c,i] = max(epoch_SWS_amp(pos_SWS(tmp_start : seq_SWS)));
                pos_peak(p_site) = pos_SWS(tmp_start + i - 1);
                p_site = p_site +1;
                seq_SWS = seq_SWS +1;
                tmp_start = seq_SWS;
            end
        else                    %  sep positive : signal is negative , others are the same as codes above
            if epoch_SWS_amp(pos_SWS(seq_SWS+1)) < 0 & (pos_SWS(seq_SWS+1) - pos_SWS(seq_SWS)) == 1 & seq_SWS < length(pos_SWS)-1 % sep continuous
                seq_SWS = seq_SWS + 1;
            else
                [c,i] = min(epoch_SWS_amp(pos_SWS(tmp_start : seq_SWS)));
                pos_peak(p_site) = pos_SWS(tmp_start + i - 1);              
                p_site = p_site +1;
                seq_SWS = seq_SWS +1;
                tmp_start = seq_SWS;
            end
        end
    end
    
    %%%%%  find SWS  %%%%%
    SWS_peak_seq = 1;     % initialize skimming peak-storing vector 
    for loop2 = 2 : length(pos_peak)      % rule : 如果amp大於80 & 時間長度少於2 sec 則判為SWS structure 
       if abs(epoch_SWS_amp(pos_peak(loop2)) - epoch_SWS_amp(pos_peak(loop2-1))) > th2_SWS_p2p & (pos_peak(loop2) - pos_peak(loop2-1)) < (1.5*fs)
           SWS_pos(SWS_peak_seq,1) = pos_peak(loop2-1);
           SWS_pos(SWS_peak_seq,2) = pos_peak(loop2);
           SWS_peak_seq = SWS_peak_seq + 1;      
       end
    end
    if fconnect == 1    
        %%%%%  connect SWS segment %%%%%
        for loop3 = 2 : SWS_peak_seq-1
            if SWS_pos(loop3,1) - SWS_pos(loop3-1,2) < fs
                SWS_pos(loop3,1) = SWS_pos(loop3-1,2);
            end
        end
        loop3 = 2;
        while loop3 <= SWS_peak_seq-1
            if SWS_pos(loop3,1) == SWS_pos(loop3-1,2)
                SWS_pos(loop3,1) = SWS_pos(loop3-1,1);
                SWS_pos(loop3-1,:) = [];
                SWS_peak_seq = SWS_peak_seq - 1;
            else
                loop3 = loop3 + 1;
            end

        end
        %%%%% connect to zero point %%%%%
        for loop3 = 1 : SWS_peak_seq-1
            if epoch_SWS_amp(SWS_pos(loop3,1)) > 0
                while epoch_SWS_amp(SWS_pos(loop3,1)) > 0 & SWS_pos(loop3,1) > 1
                    SWS_pos(loop3,1) = SWS_pos(loop3,1) - 1;
                end
            else
                while epoch_SWS_amp(SWS_pos(loop3,1)) < 0 & SWS_pos(loop3,1) > 1
                    SWS_pos(loop3,1) = SWS_pos(loop3,1) - 1;
                end
            end
            if epoch_SWS_amp(SWS_pos(loop3,2)) > 0
                while epoch_SWS_amp(SWS_pos(loop3,2)) > 0 & SWS_pos(loop3,2) < epoch 
                    SWS_pos(loop3,2) = SWS_pos(loop3,2) + 1;
                end
            else
                while epoch_SWS_amp(SWS_pos(loop3,2)) < 0 & SWS_pos(loop3,2) < epoch
                    SWS_pos(loop3,2) = SWS_pos(loop3,2) + 1;
                end
            end
        end
        
        
    end    
    %%%%%  calculate SWS percentage %%%%%
    for loop3 = 1 : SWS_peak_seq-1     
        SWS_len = SWS_len + (SWS_pos(loop3,2) - SWS_pos(loop3,1) + 1); % slow wave length
    end
    feat_n3 = 100*(SWS_len/epoch);
    

% toc