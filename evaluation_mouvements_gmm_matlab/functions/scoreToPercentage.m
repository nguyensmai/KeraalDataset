function [ percentage ] = scoreToPercentage( score,seuil,minseuil )
%SCORETOPERCENTAGE Summary of this function goes here
%   transform a score scalar or vector into percentage according to a
%   threshold
%   if score is greater or equal than zero, we consider 100%
%   if score is lower than minseuil, we consider 0%

score(score>0)=0;score(score<minseuil)=minseuil;
for c=1:length(score)
    if score(c)<=(seuil)
        percentage(c) = round((0.5 - (((score(c)-seuil)/(-500-seuil)))*0.5)*100);
    else
        percentage(c) = round((1 - ((score(c)/seuil)*0.5))*100);
    end
end

end

