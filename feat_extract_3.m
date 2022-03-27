function feat = feat_extract_3(data,fs)
    ns = 2;    %�Ҽ{�ɧǰ��D:�h�ݫe��ns��
    feat(:,1:17)=feat_extract_1_test_3(data,fs,ns); %C3,E1,EMG
    % ======================================== %
    % Extract Features 1:
    % 01. 0-4 E (E:EEG)
    % 02. 4-8 E�iPaper���ϥΡj
    % 03. 8-13 E
    % 04. 13-22 E�iPaper���ϥΡj
    % 05. 22-30 E
    % 06. 0-30 E (Total power of 0-30 Hz EEG)
    % 07. �i���ϥΡj
    % 08. �i���ϥΡj
    % 09. Mean(fre.) E (Mean frequency of EEG)
    % 10. Std(fre.) E (Std frequency of EEG)�iPaper���ϥΡj
    % 11. 0-4 O (O:EOG)
    % 12. 0-30 O�iPaper���ϥΡj
    % 13. Mean(fre.) O�iPaper���ϥΡj
    % 14. Std(fre.) O�iPaper���ϥΡj
    % 15. 0-30 M
    % 16. Mean(fre.) M
    % 17. Std(fre.) M�iPaper���ϥΡj
    % ======================================== %

    feat(:,18:20)=feat_extract_2_test_3(data,fs,ns);    %C3
    % ======================================== %
    % Extract Features 2:
    % 18. Alpha ratio
    % 19. Spindle ratio
    % 20. SWS ratio
    % ======================================== %

    feat(:,21:23)=feat_extract_3_test_3(data,fs,ns);    %EMG
    % ======================================== %
    % Extract Features 3:
    % 21. EMG Mean amplitude
    % 22. �i���ϥΡj
    % 23. EEG spindle num(C3)
    % ======================================== %

    feat(:,24:27)=feat_extract_4_test_3(data,fs,ns);    %E1
    % ======================================== %
    % Extract Features 4:
    % 24. EOG Alpha ratio
    % 25. EOG Spindle ratio
    % 26. EOG SWS ratio
    % 27. EOG spindle num
    % ======================================== %

    feat = feat_nor_test_3(feat);