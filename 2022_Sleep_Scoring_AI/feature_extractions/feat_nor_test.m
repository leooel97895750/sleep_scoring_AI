% 標準化
function feat_nor = feat_nor_test(feat)

feat_52 = feat;
[si_a, si_b] = size(feat_52);
feat_new_dis = zeros(si_a,52);
for feat_no = 1:52
        feat_ratio_arr = sort(feat_52(:, feat_no));  % 指定feature
        len_data = length(feat_ratio_arr);
        max_feat_ratio = mean(feat_ratio_arr((len_data - floor(len_data/10)) :len_data));
        min_feat_ratio = mean(feat_ratio_arr( 1 : (1+ floor(len_data/10))));

        min_base = 0;
        max_base = 1;

        feat_new_dis(:,feat_no) = min_base + ((feat_52(:,feat_no) - min_feat_ratio) ./ (max_feat_ratio - min_feat_ratio)) * (max_base - min_base);  % 指定feature
end 
feat_nor = feat_new_dis;