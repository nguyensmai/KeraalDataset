function [ axe, sign ] = explainErrorPosition( loglik, train, test )
%EXPLAINERRORPOSITION Summary of this function goes here
%   Explain the error in term of position
%   loglik is the likelihood of the corresponding segment
%   train is the training data position
%   test is the testing data position
%   axe is the corresponding axe of detected error (most) ('X','Y' or 'Z')
%   sign is the sign of axe ('positive' or 'negative')

[val,t]=min(loglik);
diff=train(:,t)-test(:,t);
[val,coord] = max(abs(diff));
if coord==1
    axe='Z';
else
    if coord==2
        axe='Y';
    else
        axe='X';
    end
end
if val>0
    sign='positive';
else
    sign='negative';
end

end

