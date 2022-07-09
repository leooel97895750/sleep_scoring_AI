clear 
close all

inputDir = 'G:\共用雲端硬碟\Sleep center data\auto_detection\sleep_scoring_AI\2022_Sleep_Scoring_AI\2022result\result_answer\';

AHI5 = [60,52,53,47,48,66,9,19,3,34,58,63,27,61,44];
AHI5_30 = [59,62,56,55,33,37,31,22,6,43,15,50,12,23];
AHI30 = [26,41,11,8,10,30,36,29,51,16,5,42,14,24,20];

cmatrix = zeros(6, 7);

for i = AHI30
    stage_file = dir(join([inputDir  string(i) '.dat.csv'], ''));
    hyp = load(fullfile(stage_file.folder, stage_file.name));
    answer = hyp(:, 1); % 標準答案
    auto = hyp(:, 4); % 自動判讀經模糊

    for j = 1:length(answer)
        for k = 0:4
            for p = 0:4
                if answer(j) == k && auto(j) == p
                    cmatrix(k+1, p+1) = cmatrix(k+1, p+1) + 1;
                end
            end
        end
    end
end

% 計算總和 and Agreement
for i = 1:5
    cmatrix(i, 6) = sum(cmatrix(i, 1:5));
    cmatrix(i, 7) = (cmatrix(i, i) / cmatrix(i, 6)) * 100;
end

cmatrix(6, 6) = sum(cmatrix(1:5, 6));
cmatrix(6, 7) = ((cmatrix(1, 1) + cmatrix(2, 2) + cmatrix(3, 3) + cmatrix(4, 4) + cmatrix(5, 5)) / cmatrix(6, 6)) * 100;
