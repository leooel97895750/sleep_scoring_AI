function feat = run_feat_chun(data,fs)

 h = waitbar(0,'Please wait...');
% pause(.5)
% 
% waitbar(.33,h,'Loading data');
% pause(1)
% 
% waitbar(.67,h,'Processing data');
feat = feat_extract_chun(data,fs);
% pause(1)

 waitbar(1,h,'Finish');
% pause(1)
save('feature.mat','feat');
close(h);