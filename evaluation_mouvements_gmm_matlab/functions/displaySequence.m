function [ output_args ] = displaySequence( posMat,up )
%DISPLAYSEQUENCE Summary of this function goes here
%   Detailed explanation goes here

for t=15:size(posMat,2)
    drawSkel(posMat(:,t)',[0 0 1],2,up);
    xlim([-0.8 1]);
    if up==1
        ylim([-0.6 0.5]);
    else
        ylim([-1.4 0.5]);
    end
    %texte=sprintf('Frame %i', t);
    %text(0.6,0.3,texte);
    pause(0.03);
    clf;
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

