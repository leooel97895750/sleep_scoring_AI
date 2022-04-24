function SpindleNum = TEO_STFT_PWR(inp_x, fs, ns)

Plotflag = 2; % plot
Saveflag = 0; % save figure
SaveSpNumflag = 0; % save spindle number
savedir = 'S2_C3_sr256';  % storing directory
    
if Saveflag == 1
    if exist(savedir,'dir')~=7
            mkdir(savedir);
    end
end

data = inp_x;
%fs = 200;
data = double(data);
[x1, y1] = butter(5, 32/(fs/2), 'low'); % bandpass 0.5-32Hz
[x2, y2] = butter(5, 0.5/(fs/2), 'high');
data = filter(x1, y1, data);
data = filter(x2, y2, data);
data = downsample(data, 2); % down sampling to 128Hz

fs = fs/2;%100;
epoch = 30; % 30s per epoch
t = 0:1/fs:30-1/fs;
L = length(data);
epochnum = floor(length(data)/fs/epoch);
epoch_overlapping = ns*fs;    %考慮時序問題:多看前後ns秒

%%%%%%%%%%% TEO seting %%%%%%%%%%%%%%%%%%%
[x, y] = butter(1, [10 15] / (fs/2)); % bandpass
bnd_data = filter(x, y, data);
spindleL = round(0.5*fs);
Th = zeros(epochnum, 1);
Ts = zeros(fs*epoch, 1);
Tsdet = zeros(fs*epoch, 1);
TsResult = zeros(fs*epoch, epochnum) - 100;

%%%%%%%%%%%%%% STFT seting %%%%%%%%%%%%%%%
window = 64;
noverlap = window*0.75;
NFFT = 0:32;
cover = window*0.5;
spindlebnd = 11:16;
STFTResult = zeros(fs*epoch, epochnum) - 100;

%%%%%%%%%%% PWR seting %%%%%%%%%%%%%%%%%%%
[x,y] = butter(1, [0.5 4]/(fs/2)); % bandpass
slow_data = filter(x, y, data);
hi_th = 30;
lo_th = 5;
slow_th = 50;
PWRResult = zeros(fs*epoch, epochnum) - 100;

FinalResult = zeros(fs*epoch, epochnum) - 100;
SpindleNum = zeros(epochnum, 1);
SpindleLength = zeros(epochnum, 15);

if Plotflag == 0
    h = waitbar(0, 'Please wait...');
end

for i = 1:epochnum
    if i == 1   %head
        epochdata = data(1:i*fs*epoch + epoch_overlapping);
        bndepochdata = bnd_data(1:i*fs*epoch + epoch_overlapping);
    elseif i == epochnum   %tail
        epochdata = data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch);
        bndepochdata = bnd_data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch);
    else
        epochdata = data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch + epoch_overlapping);
        bndepochdata = bnd_data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch + epoch_overlapping);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% TEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ts = bndepochdata;
    for j = 2:fs*epoch-1
        Ts(j) = bndepochdata(j)^2 - bndepochdata(j-1)*bndepochdata(j+1);
    end
    Th(i) = mean(Ts)*0.6; % Threshold
    
    % data over threshold
    for j = 1:fs*epoch
        if Ts(j) >= Th(i)
            Tsdet(j) = 1;
        else
            Tsdet(j) = 0;
        end
    end
    
    % spindle position
    for j = 1:fs*epoch - spindleL + 1
        if sum(Tsdet(j:j+spindleL-1)) == spindleL
            TsResult(j:j+spindleL-1,i) = 100;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% STFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Sx, F, T] = spectrogram(epochdata, window, noverlap, NFFT, fs, 'yaxis');
    Sx = abs(Sx);
    
    MaxSx = max(Sx);
    for j = 1:length(MaxSx)
        norSx(:, j) = Sx(:, j) / MaxSx(j);
    end
    for j = 1:length(T)
        if find(norSx(spindlebnd, j) > 0.9) > 0
            idx = int32(T(j)*fs - cover+1:T(j)*fs+cover);
            STFTResult(idx(:), i) = 100;
        end
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PWR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i == 1   %head
        slowepochdata = slow_data(1:i*fs*epoch + epoch_overlapping);
    elseif i == epochnum   %tail
        slowepochdata = slow_data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch);
    else
        slowepochdata = slow_data((i-1)*fs*epoch+1 - epoch_overlapping:i*fs*epoch + epoch_overlapping);
    end
    
    absslow = abs(slowepochdata);
    diffdata = diff(bndepochdata);
    diffdata(length(diffdata)+1) = 0; 
    squdata = diffdata.^2;
    
    N = 16;
    inte = squdata;
    for n = N:length(squdata)
        inte(n) = sum( squdata(n-(N-1):n) ) / N;
    end

    % thresholding
    lo_pass = zeros(epoch*fs,1);
    lo_pass(inte >= lo_th) = 1;
    hi_pass = zeros(epoch*fs,1);
    hi_pass(inte >= hi_th) = 1;
    
    % thresholding for slow wave
    thslow = zeros(epoch*fs,1);
    thslow(absslow >= slow_th) = 1;
    
    % delete lo_pass by slow wave threshold
    for j = 1+round(spindleL/2):fs*epoch - round(spindleL/2)
        if thslow(j) ==1
            lo_pass(j-round(spindleL/2):j+round(spindleL/2)) = 0;
        end
    end
    
    % spindle position
    for j = 1:fs*epoch - spindleL + 1
        if sum(lo_pass(j:j+spindleL-1)) == spindleL && sum(hi_pass(j:j+spindleL-1)) > 0
            PWRResult(j:j+spindleL-1,i) = 100;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Final
    tmpfinal = zeros(fs*epoch,1);
    for j = 1:fs*epoch 
        if STFTResult(j,i)+TsResult(j,i)+PWRResult(j,i) >= 100
            tmpfinal(j) = 1;
        end
    end
    for j = 1:fs*epoch - spindleL + 1
        if sum(tmpfinal(j:j+spindleL-1)) == spindleL
            FinalResult(j:j+spindleL-1,i) = 100;
        end
    end
    
    % spindle num & length
    SpFlag = 0;
    SpCnt = 0;
    for j = 1:fs*epoch
        if FinalResult(j,i) == 100 && SpFlag == 0
            SpindleNum(i) = SpindleNum(i) + 1;
            SpFlag = 1;
            
            for k = j:fs*epoch
                if FinalResult(k,i) == 100
                    SpCnt = SpCnt + 1;
                else
                    break
                end
            end
            
            SpindleLength(i,SpindleNum(i)) = SpCnt/fs;
            
        elseif FinalResult(j,i) == -100
            SpFlag = 0;
            SpCnt = 0;
        end
    end
    
    % plot
    if Plotflag == 1
        if Saveflag ==0
            figure
        end
        subplot(511)
        plot(t,epochdata)
        ylabel('C3-A2')
        axis([0 epoch -100 100])

        subplot(512)
        plot(t,epochdata)
        ylabel('TEO')
        hold on
        plot(t,TsResult(:,i),'r')
        hold off
        axis([0 epoch -100 100])

        subplot(513)
        plot(t,epochdata)
        ylabel('STFT')
        hold on
        plot(t,STFTResult(:,i),'r')
        hold off
        axis([0 epoch -100 100])

        subplot(514)
        plot(t,epochdata)
        ylabel('Power')
        hold on
        plot(t,PWRResult(:,i),'r')
        hold off
        axis([0 epoch -100 100])

        subplot(515)
        plot(t,epochdata)
        ylabel('Final')
        hold on
        plot(t,FinalResult(:,i),'r')
        hold off
        axis([0 epoch -100 100])
        
        if Saveflag ==1
            max_char_len = numel(num2str(L));
            char_len = numel(num2str(i));
            zeropad = max_char_len - char_len;
            savfname = ['./' savedir '/','fig',repmat('0',1,zeropad),num2str(i)];
            saveas(gcf,savfname,'bmp')
        end
    end
    if Plotflag == 0
        waitbar(i/epochnum,h,strcat('Please wait...',num2str(round(i/epochnum*100)),'%'))
    end
end

if Plotflag == 0
    close(h)
end

if SaveSpNumflag == 1
    savfname = ['./' savedir '_spindle.dat'];
    csvwrite(savfname,SpindleNum)
end