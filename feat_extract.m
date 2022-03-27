function feat_extract(Input_database,OutputDir)

if exist(OutputDir,'dir')~=7
        mkdir(OutputDir);
end

data = load(fullfile(Input_database.folder,Input_database.name)); %load .mat files in the folder
fs = 200; %�ίv���� sample rate
%fs = 512;  %����| sample rate
ns = 2;    %�Ҽ{�ɧǰ��D:�h�ݫe��ns��

%data=load(strcat(filename,'.mat'));
feat(:,1:17)=feat_extract_1_test(data,fs,ns); %C3,E1,EMG
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

feat(:,18:20)=feat_extract_2_test(data,fs,ns);    %C3
% ======================================== %
% Extract Features 2:
% 18. Alpha ratio
% 19. Spindle ratio
% 20. SWS ratio
% ======================================== %

feat(:,21:23)=feat_extract_3_test(data,fs,ns);    %EMG
% ======================================== %
% Extract Features 3:
% 21. EMG Mean amplitude
% 22. �i���ϥΡj
% 23. EEG spindle num(C3)
% ======================================== %

feat(:,24:27)=feat_extract_4_test(data,fs,ns);    %E1
% ======================================== %
% Extract Features 4:
% 24. EOG Alpha ratio
% 25. EOG Spindle ratio
% 26. EOG SWS ratio
% 27. EOG spindle num
% ======================================== %

feat(:,28:41)=feat_extract_5_test(data,fs,ns);     %F4,E2
% ======================================== %
% Extract Features 5:
% 28. 0-4 E (E:EEG)
% 29. 4-8 E�iPaper���ϥΡj
% 30. 8-13 E
% 31. 13-22 E�iPaper���ϥΡj
% 32. 22-30 E
% 33. 0-30 E (Total power of 0-30 Hz EEG)
% 34. �i���ϥΡj
% 35. �i���ϥΡj
% 36. Mean(fre.) E (Mean frequency of EEG)
% 37. Std(fre.) E (Std frequency of EEG)�iPaper���ϥΡj
% 38. 0-4 O (O:EOG)
% 39. 0-30 O�iPaper���ϥΡj
% 40. Mean(fre.) O�iPaper���ϥΡj
% 41. Std(fre.) O�iPaper���ϥΡj
% ======================================== %

feat(:,42:45)=feat_extract_6_test(data,fs,ns);    %F4
% ======================================== %
% Extract Features 6:
% 42. Alpha ratio
% 43. Spindle ratio
% 44. SWS ratio
% 45. EEG spindle num(F4)
% ======================================== %

feat(:,46:49)=feat_extract_7_test(data,fs,ns);    %E2
% ======================================== %
% Extract Features 7:
% 46. EOG Alpha ratio
% 47. EOG Spindle ratio
% 48. EOG SWS ratio
% 49. EOG spindle num
% ======================================== %

feat(:,50:52)=feat_extract_8_test_new(data,fs,ns);    %E2

feat = feat_nor_test(feat);


csvwrite(strcat(OutputDir,Input_database.name(1:end-4),'_feature.dat'),feat);

% feat = feat(:,[1,2,3,5,6,9,11,15,16,18,20,21,23]);
% csvwrite(strcat('feat_',filename,'_13.dat'),feat);