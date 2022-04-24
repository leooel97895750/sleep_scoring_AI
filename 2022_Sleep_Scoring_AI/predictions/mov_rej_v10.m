% 去除movement
function output = mov_rej(input)
% ===========================================
% 0     1       2       3       4      5
% Wake  S1      S2      SWS     REM     Mov
% ===========================================
    L = length(input);
    output = input;
    for i = 2:L-3
        if output(i) == 5
            if output(i-1) == 0 || output(i+1) == 0
                output(i) = 0;
            else 
                output(i) = output(i-1);
            end
        end
    end
    output(output == 5) = 0;
end