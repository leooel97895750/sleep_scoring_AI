function post_result = post_staging_feat_v2(auto_staging,feat)
    corr=corrcoef(feat(:,52),feat(:,51))
    [row_i,col_j] = size(feat);
    for seq_i=1:col_j
       for seq_j = 1:row_i
           if feat(seq_j,seq_i) > 1 
               feat(seq_j,seq_i) = 1;
           elseif feat(seq_j,seq_i) < 0
               feat(seq_j,seq_i) = 0;
           end
       end
    end


    auto_staging_mod1 = auto_staging;
    auto_staging_ini = auto_staging_mod1;
    
    if auto_staging_ini(1) == 1 || auto_staging_ini(1) == 2 || auto_staging_ini(1) == 3 || auto_staging_ini(1) == -1
        auto_staging_ini(1) = 0;
    end   
    if auto_staging_ini(2) == 2 || auto_staging_ini(2) == 3 || auto_staging_ini(2) == -1
        auto_staging_ini(2) = 0;
        if auto_staging_ini(3) == 2 || auto_staging_ini(3) == 3 || auto_staging_ini(3) == -1
            auto_staging_ini(3) = 0;
        end
    end
    for epoch_no = 1:length(auto_staging_ini)-3

        if epoch_no > 1
            if isempty(find(auto_staging_ini(1:epoch_no-1)==1 | auto_staging_ini(1:epoch_no-1)==2)) == 1 && auto_staging_ini(epoch_no) == 3
                auto_staging_ini(epoch_no) = 0;
            end
            if isempty(find(auto_staging_ini(1:epoch_no-1)==2 | auto_staging_ini(1:epoch_no-1)==3)) == 1 && auto_staging_ini(epoch_no) == -1
                auto_staging_ini(epoch_no) = 1;
            end
        end
        if epoch_no > 2
            %original remove
%                 if auto_staging_ini(epoch_no-1) == 1 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no) == 0  %remove(useless)
%                     auto_staging_ini(epoch_no-1) = 0;  %  wake,n1,wake --> wake,wake,wake
%                 end
%              if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 2 & auto_staging_ini(epoch_no+1) == 0 & auto_staging_ini(epoch_no) == 0
%                  auto_staging_ini(epoch_no-1) = 0;
%                  auto_staging_ini(epoch_no-2) = 0;    %  N2,N2,wake,wake --> wake,wake,wake,wake
%              end
             if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no+1) == 0 & auto_staging_ini(epoch_no) == 2
                 auto_staging_ini(epoch_no-1) = 0;
                 auto_staging_ini(epoch_no) = 0;    %  wake,N2,N2,wake --> wake,wake,wake,wake
             end
%              if auto_staging_ini(epoch_no-1) == 0 & auto_staging_ini(epoch_no-2) == 2 & auto_staging_ini(epoch_no) == 0
%                  auto_staging_ini(epoch_no-2) = 0;    %  N2,wake,wake --> wake,wake,wake
%              end
             if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no) == 0
                 auto_staging_ini(epoch_no-1) = 0;  %  wake,N2,wake --> wake,wake,wake
             end
             if auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no) == 0
                 auto_staging_ini(epoch_no-1) = 1;  %  wake,REM,wake --> wake,wake,wake
             end
             if auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no) == 1
                 auto_staging_ini(epoch_no-1) = 1;  %  wake,REM,n1 --> wake,n1,n1
             end
             if auto_staging_ini(epoch_no) == 1 & auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 2
                 auto_staging_ini(epoch_no) = 2;   %  n2,n2,n1 --> n2,n2,n2
             end
             if auto_staging_ini(epoch_no-1) == 0 & auto_staging_ini(epoch_no) == 2 & auto_staging_ini(epoch_no-2) == 2
                 auto_staging_ini(epoch_no-1) = 2;  %  n2,wake,n2  --> n2,n2,n2
             end 

            %smooth Wake
            if auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no) == 2 & auto_staging_ini(epoch_no+1) == 2 & auto_staging_ini(epoch_no+2) == 0
                tmp = [epoch_no-1 epoch_no epoch_no+1];
                if feat(epoch_no,21) >0.3 
                    auto_staging_ini(tmp) = 0;%w,2,2,2,w->w,w,w,w,w,w
                end
            end
            if auto_staging_ini(epoch_no) == 4 && epoch_no<100 
                if feat(epoch_no,21) >0.15
                    auto_staging_ini(epoch_no) = 0;%R->w
                end
            end
            %smooth N1
            if auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) == 4 & auto_staging_ini(epoch_no+2) == 2
                tmp = [epoch_no-1 epoch_no epoch_no+1];
                if feat(tmp,21) >0.15 
                    auto_staging_ini(tmp) = 1;  %  wake,REM,REM,REM,n2 --> wake,n1,n1,n1,n2
                end
            end
            if auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) == 2
                tmp = [epoch_no-1 epoch_no];
                if feat(tmp,21) >0.15 
                    auto_staging_ini(tmp) = 1;  %  wake,REM,REM,n2 --> wake,n1,n1,n2
                end
            end
            if auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no) == -1
                if feat(epoch_no-1,21) >0.15 
                    auto_staging_ini(epoch_no-1) = 1;  %  wake,REM,n2 --> wake,n1,n2
                end
            end
            if auto_staging_ini(epoch_no-2) ~= 4 & auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) ~= -1
                tmp = [epoch_no-1 epoch_no];
               if feat(tmp,51)==0
                    auto_staging_ini(tmp) = 1;  %  n1,REM,REM,n2 --> n1,n1,n1,n2
               end
            end
            if auto_staging_ini(epoch_no-1) ~= 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) ~= -1
                if feat(epoch_no,51)==0    
                    auto_staging_ini(epoch_no) = 1;  %  n1,REM,n2 --> n1,n1,n2
                end
            end
%                 if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 1 & auto_staging_ini(epoch_no) == 1  %remove(useless)
%                     auto_staging_ini(epoch_no-1) = 1;  %  n1,n2,n1 --> n1,n1,n1
%                 end

            %smooth REM
                if auto_staging_ini(epoch_no-1) == 0 & auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no) == 4  %remove(useless)
                     if feat(epoch_no-1,15) < 0.6 | feat(epoch_no-1,19) < 0.5 | feat(epoch_no-1,21) < 0.3 | feat(epoch_no-1,51) > 0
                         auto_staging_ini(epoch_no-1) = -1;  %  REM,Wake,REM --> REM,REM,REM
                     end
                end
%                 if auto_staging_ini(epoch_no-1) == 1 & auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no) == 4  %remove(useless)
%                     auto_staging_ini(epoch_no-1) = -1;  %  REM,N1,REM --> REM,REM,REM
%                 end
            if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no) == -1
                if   feat(epoch_no-1,15) < 0.6| feat(epoch_no-1,19) < 0.5 | feat(epoch_no-1,21) < 0.3 | feat(epoch_no-1,51) > 0%feat(epoch_no-1,4) > 0.2  %remove real N2  feat(epoch_no-1,15) < 0.6 | feat(epoch_no-1,19) < 0.1 | feat(epoch_no-1,21) < 0.3 |feat(epoch_no-1,22) < 0.4 |feat(epoch_no-1,25) < 0.1 |feat(epoch_no-1,27) < 0.1 | feat(epoch_no-1,43) < 0.1 |feat(epoch_no-1,45) < 0.2 | feat(epoch_no-1,47) < 0.1 | feat(epoch_no-1,49) < 0.1
                    auto_staging_ini(epoch_no-1) = -1;  %  REM,N2,REM --> REM,REM,REM
                end
            end
            if epoch_no>10
                if auto_staging_ini(epoch_no-10) == 4 & auto_staging_ini(epoch_no-9) == 4 & auto_staging_ini(epoch_no) == 4 
                    tmp1 = [epoch_no-8 epoch_no-7 epoch_no-6 epoch_no-5 epoch_no-4 epoch_no-3 epoch_no-2 epoch_no-1];
                    if  auto_staging_ini(tmp1)~=0 
                        if feat(tmp1,15) < 0.6 | feat(tmp1,19) < 0.5 | feat(tmp1,21) < 0.3 | feat(tmp1,51) > 0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp1) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
                if auto_staging_ini(epoch_no-9) == 4 & auto_staging_ini(epoch_no-8) == 4 & auto_staging_ini(epoch_no) == -1
                    tmp1 = [epoch_no-7 epoch_no-6 epoch_no-5 epoch_no-4 epoch_no-3 epoch_no-2 epoch_no-1];
                     if auto_staging_ini(tmp1)~=0 
                        if feat(tmp1,15) < 0.6| feat(tmp1,19) < 0.5 |feat(tmp1,21) < 0.3 | feat(tmp1,51) > 0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp1) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                     end
                end
                if auto_staging_ini(epoch_no-8) == 4 & auto_staging_ini(epoch_no-7) == 4 & auto_staging_ini(epoch_no) == 4 
                    tmp1 = [epoch_no-6 epoch_no-5 epoch_no-4 epoch_no-3 epoch_no-2 epoch_no-1];
                    if auto_staging_ini(tmp1)~=0 
                        if feat(tmp1,15) < 0.6 | feat(tmp1,19) < 0.5|feat(tmp1,21) < 0.3 | feat(tmp1,51) > 0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp1) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
                if auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no+3) == -1
                    tmp1 = [epoch_no-1 epoch_no epoch_no+1 epoch_no+2];
                    if auto_staging_ini(tmp1)~=0 
                        if feat(tmp1,15) < 0.6| feat(tmp1,19) < 0.5 |feat(tmp1,21) < 0.3 | feat(tmp1,51) > 0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp1) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
                if auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no+2) == -1
                    tmp2 = [epoch_no-1 epoch_no epoch_no+1];
                    if auto_staging_ini(tmp2)~=0 
                        if feat(tmp2,15) < 0.6| feat(tmp2,19) < 0.5 |feat(tmp2,21) < 0.3 | feat(tmp2,51)>0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp2) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
                if auto_staging_ini(epoch_no-2) == 4 & auto_staging_ini(epoch_no+1) == -1
                    tmp3 = [epoch_no-1 epoch_no];
                    if auto_staging_ini(tmp3)~=0 
                        if feat(tmp3,15) < 0.6| feat(tmp3,19) < 0.5 |feat(tmp3,21) < 0.3 | feat(tmp3,51)>0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp3) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
                if auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no+1) == -1
                    tmp3 = [epoch_no];
                    if auto_staging_ini(tmp3)~=0 
                        if feat(tmp3,15) < 0.6| feat(tmp3,19) < 0.5 |feat(tmp3,21) < 0.3 | feat(tmp3,51)>0%feat(tmp1,4) > 0.2  %remove real N2
                            auto_staging_ini(tmp3) = -1;  %  REM,X,REM --> REM,REM,REM
                        end
                    end
                end
            end
            if (auto_staging_ini(epoch_no-1) == 2 || auto_staging_ini(epoch_no-1) == 1 )&& auto_staging_ini(epoch_no) == 4 && (auto_staging_ini(epoch_no+1) == 2 || auto_staging_ini(epoch_no+1) == 1)
                if feat(epoch_no,21) > 0.1 
                    auto_staging_ini(epoch_no) = auto_staging_ini(epoch_no-1);  %  N1/2,REM,N1/2 --> N1/2,N1,N1/2
                end
            end
            %smooth N2
            if auto_staging_ini(epoch_no-1) == 1 & auto_staging_ini(epoch_no) == 2 & auto_staging_ini(epoch_no-2) == 2
                auto_staging_ini(epoch_no-1) = 2;  %  n2,n1,n2  --> n2,n2,n2
            end
            if auto_staging_ini(epoch_no-2) == 2 &auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) == 2
                auto_staging_ini(epoch_no-1) = 2;  %  n2,n2,REM,n2  --> n2,n2,n2,n2
            end
            if  auto_staging_ini(epoch_no-2) ~= 4 & auto_staging_ini(epoch_no-1)~= 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) == -1& auto_staging_ini(epoch_no+2) == -1& auto_staging_ini(epoch_no+3) ~= -1
                tmp = [epoch_no+1 epoch_no-1 epoch_no];
                if feat(tmp,51)==0
                    auto_staging_ini(tmp) = 2;  %  n2,n2,REM,REM,REM,n1 --> n2,n2,n2,n2,n2,n1
                end
            end
            if auto_staging_ini(epoch_no-2) ~= 4 &auto_staging_ini(epoch_no-1) ~= 4 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) == 4 & auto_staging_ini(epoch_no+2) ~= -1
                tmp = [epoch_no-1 epoch_no];
                if feat(tmp,51)==0
                    auto_staging_ini(tmp) = 2;  %  n2,n2,REM,REM,n1 --> n2,n2,n2,n2,n1
                end
            end
            if auto_staging_ini(epoch_no-2) ~=-1 & auto_staging_ini(epoch_no-1) ~=-1 & auto_staging_ini(epoch_no) == 4 & auto_staging_ini(epoch_no+1) ~= -1
                if feat(epoch_no-1,51)==0
                    auto_staging_ini(epoch_no-1) = 2;  %  n2, n2,REM,n1 -->  n2,n2,n2,n1
                end
            end
            if epoch_no>10
                if auto_staging_ini(epoch_no-2) == 2 & auto_staging_ini(epoch_no-1) == 3 & auto_staging_ini(epoch_no) == 2
                    if feat(epoch_no-1,44) < 0.83   %remove real N3
                        auto_staging_ini(epoch_no-1) = 2;   %  n2,n3,n2 --> n2,n2,n2     
                    end
                end
                if auto_staging_ini(epoch_no-2) == 2 & auto_staging_ini(epoch_no-1) == 3 & auto_staging_ini(epoch_no) == 3 & auto_staging_ini(epoch_no+1) == 2
                    if feat(epoch_no-1,44) < 0.83   %remove real N3
                        auto_staging_ini(epoch_no) = 2;
                        auto_staging_ini(epoch_no-1) = 2;   %  n2,n3,n3,n2 --> n2,n2,n2,n2     
                    end
                end
                if auto_staging_ini(epoch_no-3) == 2 &auto_staging_ini(epoch_no-2) == 3 & auto_staging_ini(epoch_no-1) == 3 & auto_staging_ini(epoch_no) == 3 & auto_staging_ini(epoch_no+1) == 2
                    if feat(epoch_no-1,44) < 0.83   %remove real N3
                        auto_staging_ini(epoch_no-2) = 2;
                        auto_staging_ini(epoch_no-1) = 2;   %  n2,n3,n3,n2 --> n2,n2,n2,n2
                        auto_staging_ini(epoch_no) = 2;
                    end
                end
                if auto_staging_ini(epoch_no-4) == 2 &auto_staging_ini(epoch_no-3) == 3&auto_staging_ini(epoch_no-2) == 3 & auto_staging_ini(epoch_no-1) == 3 & auto_staging_ini(epoch_no) == 3 & auto_staging_ini(epoch_no+1) == 2
                    if feat(epoch_no-1,44) < 0.83   %remove real N3
                        auto_staging_ini(epoch_no-3) = 2;
                        auto_staging_ini(epoch_no-2) = 2;
                        auto_staging_ini(epoch_no-1) = 2;   %  n2,n3,n3,n2 --> n2,n2,n2,n2
                        auto_staging_ini(epoch_no) = 2;
                    end
                end
            end
            %smooth N3
            if auto_staging_ini(epoch_no-2) == 3 & auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no) == 2 & auto_staging_ini(epoch_no+1) == 2 & auto_staging_ini(epoch_no+2) == 3
                tmp5 = [epoch_no-1 epoch_no epoch_no+1];
                if feat(tmp5,1) > 0.3 | feat(tmp5,28) > 0.4 | feat(tmp5,31) < 0.4 | feat(tmp5,42) < 0.4 | feat(tmp5,44) > 0.3  %remove real N2
                    auto_staging_ini(tmp5) = 3;   %  n3,n2,n2,n2,n3 --> n3,n3,n3,n3,n3
                end
            end
            if auto_staging_ini(epoch_no-2) == 3 & auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no) == 2 & auto_staging_ini(epoch_no+1) == 3
                tmp4 = [epoch_no-1 epoch_no];
                if feat(tmp4,1) > 0.3 | feat(tmp4,28) > 0.4 | feat(tmp4,31) < 0.4 | feat(tmp4,42) < 0.4 | feat(tmp4,44) > 0.3  %remove real N2
                    auto_staging_ini(tmp4) = 3;   %  n3,n2,n2,n3 --> n3,n3,n3,n3
                end
            end
            if auto_staging_ini(epoch_no-1) == 2 & auto_staging_ini(epoch_no-2) == 3 & auto_staging_ini(epoch_no) == 3
                if feat(epoch_no-1,1) > 0.3 || feat(epoch_no-1,28) > 0.4 || feat(epoch_no-1,31) < 0.4 || feat(epoch_no-1,42) < 0.4 || feat(epoch_no-1,44) > 0.3  %remove real N2
                    auto_staging_ini(epoch_no-1) = 3;   %  n3,n2,n3 --> n3,n3,n3
                end
            end

            %else
            if auto_staging_ini(epoch_no-1) == 4 & auto_staging_ini(epoch_no-2) == 0 & auto_staging_ini(epoch_no) == 2
                auto_staging_ini(epoch_no-1) = 1;  %  W,REM,n2 --> W,n1,n2
            end
        end
    end
    post_result = auto_staging_ini;

end