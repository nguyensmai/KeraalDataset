function [ output_args ] = displaySequenceDouble( h,model,posMat,posMat2,up )
%DISPLAYSEQUENCE Summary of this function goes here
%   Detailed explanation goes here
figure(h);
c=1;
trans=posMat(7:9,1)-posMat2(7:9,1);
posMat2=posMat2+repmat(trans,size(posMat2,1)/length(trans),size(posMat2,2));
if up==1
    xlmini=min(min(min(posMat(1:3:34,:))),min(min(posMat2(1:3:34,:))))-0.1;
    xlmaxi=max(max(max(posMat(1:3:34,:))),max(max(posMat2(1:3:34,:))))+0.1;
else
    xlmini=min(min(min(posMat(1:3:58,:))),min(min(posMat2(1:3:58,:))))-0.1;
    xlmaxi=max(max(max(posMat(1:3:58,:))),max(max(posMat2(1:3:58,:))))+0.1;
end
if up==1
    ylmini=min(min(min(posMat(2:3:35,:))),min(min(posMat2(2:3:35,:))))-0.1;
    ylmaxi=max(max(max(posMat(2:3:35,:))),max(max(posMat2(2:3:35,:))))+0.1;
else
    ylmini=min(min(min(posMat(2:3:59,:))),min(min(posMat2(2:3:59,:))))-0.1;
    ylmaxi=max(max(max(posMat(2:3:59,:))),max(max(posMat2(2:3:59,:))))+0.1;    
end
for t=15:size(posMat,2)
    subplot(1,2,1),drawSkel(posMat(:,t)',[0 0 1],2,up);
    xlim([xlmini xlmaxi]);
    ylim([ylmini ylmaxi]);
    texte='training';
    %texte=sprintf('Frame %i', t);
    text(0.3,-0.4,texte);
    axis off;
    subplot(1,2,2),drawSkel(posMat2(:,t)',[1 0 0],2,up);
    xlim([xlmini xlmaxi]);
    ylim([ylmini ylmaxi]);
    texte='test';
    %texte=sprintf('Frame %i', t);
    text(0.3,-0.4,texte);
    axis off;
    pause(0.03);
    if c<=length(model.cuts) && t==model.cuts(c)
        c=c+1;
        pause(3);
    end
    if t<size(posMat,2)
        clf;
    end
end

end

function drawSkel (P, col, lw, up)
    %colonne
    line([P(1,1) P(1,4) P(1,7) P(1,10)], [P(1,2) P(1,5) P(1,8) P(1,11)], [P(1,3) P(1,6) P(1,9) P(1,12)],'Color',col,'LineWidth',lw);
    %bras gauche
    line([P(1,7) P(1,13) P(1,16) P(1,19) P(1,22)], [P(1,8) P(1,14) P(1,17) P(1,20) P(1,23)], [P(1,9) P(1,15) P(1,18) P(1,21) P(1,24)],'Color',col,'LineWidth',lw);
    %bras droit
    line([P(1,7) P(1,25) P(1,28) P(1,31) P(1,34)], [P(1,8) P(1,26) P(1,29) P(1,32) P(1,35)], [P(1,9) P(1,27) P(1,30) P(1,33) P(1,36)],'Color',col,'LineWidth',lw);
    if up==0
        %jambe gauche
        line([P(1,1) P(1,37) P(1,40) P(1,43) P(1,46)], [P(1,2) P(1,38) P(1,41) P(1,44) P(1,47)], [P(1,3) P(1,39) P(1,42) P(1,45) P(1,48)],'Color',col,'LineWidth',lw);
        %jambe droite
        line([P(1,1) P(1,49) P(1,52) P(1,55) P(1,58)], [P(1,2) P(1,50) P(1,53) P(1,56) P(1,59)], [P(1,3) P(1,51) P(1,54) P(1,57) P(1,60)],'Color',col,'LineWidth',lw);
    end
end

