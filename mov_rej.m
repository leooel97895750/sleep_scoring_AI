function output = mov_rej(input)
% ===========================================
% 0     1       2       3       4      5
% Wake  S1      S2      SWS     REM     Mov
% ===========================================

    L = length(input);
    output = input;
    for i = 2:L-3
        if output(i) == -2
            if output(i-1) == 0 || output(i+1) == 0
                output(i) = 0;
%             elseif output(i-1) == output(i+1)
%                 output(i) = output(i+1);
            else 
                output(i) = output(i-1);
            end
        end
    end
    output(output == -2) = 0;
end