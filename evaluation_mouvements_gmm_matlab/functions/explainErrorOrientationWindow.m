function [ axe, sign ] = explainErrorOrientationWindow( loglik, train, sigma,test, factor )
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
cpt=1;
for tw=t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB
    proj(:,cpt)=logmap(test(:,tw),train(:,tw));
    cpt=cpt+1;
end
%diff=test(:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB)-train(:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
sigWin=sigma(:,:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
for w=1:size(proj,2)
    proj(:,w)=proj(:,w)./diag(sigWin(:,:,w));
end
projM=mean(proj,2);
qmean=train(:,t);
qtest=expmap(projM,qmean);
emean=rad2deg(quaternionToEuler(qmean));
etest=rad2deg(quaternionToEuler(qtest));
ediff=etest-emean;
%diff=test(:,t)-train(:,t);
%sig=diag(sigma(:,:,t));
%diffM=diffM./sig;
%sigWin=sigma(:,:,t-floor(ws/2)+decA-decB:t+floor(ws/2)+decA-decB);
%sigWinM(:,:)=diag(mean(sigWin,3));
[val,coord] = max(abs(ediff));
%[val,coord] = max(abs(diffM./(power(sigWinM,2))));
if coord==1
    axe='X';
else
    if coord==2
        axe='Y';
    else
        axe='Z';
    end
end
if val>0
    sign='positive';
else
    sign='negative';
end

end

