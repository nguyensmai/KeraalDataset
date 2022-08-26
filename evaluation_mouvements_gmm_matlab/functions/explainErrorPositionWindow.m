function [ axe, sign ] = explainErrorPositionWindow( loglik, train, sigma,test, factor )
%EXPLAINERRORPOSITION Summary of this function goes here
%   Explain the error in term of position
%   loglik is the likelihood of the corresponding segment
%   train is the training data position
%   test is the testing data position
%   axe is the corresponding axe of detected error (most) ('X','Y' or 'Z')
%   sign is the sign of axe ('positive' or 'negative')

[val,t]=min(loglik);
ws=round(length(loglik)*factor);
decB=0;decA=0;
if t-floor(ws/2)<1
    decA=1+abs(t-floor(ws/2));
end
if t+floor(ws/2)>length(loglik)
    decB = t+floor(ws/2)-length(loglik);
end
diff=test(:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB)-train(:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
sigWin=sigma(:,:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
for w=1:size(diff,2)
    diff(:,w)=diff(:,w)./diag(sigWin(:,:,w));
end
diffM=mean(diff,2);
%diff=test(:,t)-train(:,t);
%sig=diag(sigma(:,:,t));
%diffM=diffM./sig;
%sigWin=sigma(:,:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
%sigWinM(:,:)=diag(mean(sigWin,3));
[val,coord] = max(abs(diffM));
%[val,coord] = max(abs(diffM./(power(sigWinM,2))));
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

