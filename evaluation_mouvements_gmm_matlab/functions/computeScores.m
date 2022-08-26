function [ Sglobal, Sbodypart, Sjoints ] = computeScores( model, Lglobal, Lbodypart, Ljoints,seuils,minseuils )
%COMPUTESCORES Summary of this function goes here
%   compute all scores according to thresholds (global and per segments)
%   model is the corresponding trained model to obtain segmentation results
%   Lglobal, Lbodypart and Ljoints are likelihood
%   seuils are the threshold vector of length 6 corresponding to global, global ori or
%   pos, body part, body part ori or pos, joint and joint ori or pos
%   minseuils are the minimal threshold vector of length 6 corresponding to global, global ori or
%   pos, body part, body part ori or pos, joint and joint ori or pos.
%   minimal threshold is used to set to 0 all value below

%   return Sglobal structure (Sglobal, Sori, Spos)
%   return Sbodypart scores per body parts (global, pos, ori)
%   return Sjoints scores per joints (global, pos, ori per joints, same size as dataTest)

% Global
for i=1:length(Lglobal)
    Sglobal{i}.name = Lglobal{i}.name;
    Sglobal{i}.global = mean(Lglobal{i}.data(:,model.cuts(1):end));
    Sglobal{i}.perSegment(1) = mean(Lglobal{i}.data);
    for c=1:length(model.cuts)-1
        Sglobal{i}.perSegment(c+1)=mean(Lglobal{i}.data(model.cuts(c)+1:model.cuts(c+1)));
    end
    Sglobal{i}.perSegment(length(model.cuts)+1)=mean(Lglobal{i}.data(model.cuts(length(model.cuts))+1:end));
    Sglobal{i}.perSegmentKP(1) = mean(Lglobal{i}.data(1:model.cutsKP(1)));
    for c=1:length(model.cutsKP)-1
        Sglobal{i}.perSegmentKP(c+1)=mean(Lglobal{i}.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
    end
    Sglobal{i}.perSegmentKP(length(model.cutsKP)+1)=mean(Lglobal{i}.data(model.cutsKP(length(model.cutsKP))+1:end));
    if i==1
        Sglobal{i}.global = scoreToPercentage(Sglobal{i}.global,seuils(1),minseuils(1));
        Sglobal{i}.perSegment = scoreToPercentage(Sglobal{i}.perSegment,seuils(1),minseuils(1));
        Sglobal{i}.perSegmentKP = scoreToPercentage(Sglobal{i}.perSegmentKP,seuils(1),minseuils(1));
    else
        Sglobal{i}.global = scoreToPercentage(Sglobal{i}.global,seuils(2),minseuils(2));
        Sglobal{i}.perSegment = scoreToPercentage(Sglobal{i}.perSegment,seuils(2),minseuils(2));
        Sglobal{i}.perSegmentKP = scoreToPercentage(Sglobal{i}.perSegmentKP,seuils(2),minseuils(2));
    end
end

% Body parts
for i=1:length(Lbodypart)
    if i<=2
        Sbodypart{i}.name = Lbodypart{i}.name;
        Sbodypart{i}.global.name = Lbodypart{i}.global.name;
        Sbodypart{i}.orientation.name = Lbodypart{i}.orientation.name;
        Sbodypart{i}.position.name = Lbodypart{i}.position.name;
        Sbodypart{i}.global.global = mean(Lbodypart{i}.global.data);
        Sbodypart{i}.orientation.global = mean(Lbodypart{i}.orientation.data);
        Sbodypart{i}.position.global = mean(Lbodypart{i}.position.data);
        Sbodypart{i}.global.perSegment(1) = mean(Lbodypart{i}.global.data(1:model.cuts(1)));
        Sbodypart{i}.orientation.perSegment(1) = mean(Lbodypart{i}.orientation.data(1:model.cuts(1)));
        Sbodypart{i}.position.perSegment(1) = mean(Lbodypart{i}.position.data(1:model.cuts(1)));
        for c=1:length(model.cuts)-1
            Sbodypart{i}.global.perSegment(c+1)=mean(Lbodypart{i}.global.data(model.cuts(c)+1:model.cuts(c+1)));
            Sbodypart{i}.orientation.perSegment(c+1)=mean(Lbodypart{i}.orientation.data(model.cuts(c)+1:model.cuts(c+1)));
            Sbodypart{i}.position.perSegment(c+1)=mean(Lbodypart{i}.position.data(model.cuts(c)+1:model.cuts(c+1)));
        end
        Sbodypart{i}.global.perSegment(length(model.cuts)+1)=mean(Lbodypart{i}.global.data(model.cuts(length(model.cuts))+1:end));
        Sbodypart{i}.orientation.perSegment(length(model.cuts)+1)=mean(Lbodypart{i}.orientation.data(model.cuts(length(model.cuts))+1:end));
        Sbodypart{i}.position.perSegment(length(model.cuts)+1)=mean(Lbodypart{i}.position.data(model.cuts(length(model.cuts))+1:end));
        Sbodypart{i}.global.perSegmentKP(1) = mean(Lbodypart{i}.global.data(1:model.cutsKP(1)));
        Sbodypart{i}.orientation.perSegmentKP(1) = mean(Lbodypart{i}.orientation.data(1:model.cutsKP(1)));
        Sbodypart{i}.position.perSegmentKP(1) = mean(Lbodypart{i}.position.data(1:model.cutsKP(1)));
        for c=1:length(model.cutsKP)-1
            Sbodypart{i}.global.perSegmentKP(c+1)=mean(Lbodypart{i}.global.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
            Sbodypart{i}.orientation.perSegmentKP(c+1)=mean(Lbodypart{i}.orientation.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
            Sbodypart{i}.position.perSegmentKP(c+1)=mean(Lbodypart{i}.position.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
        end
        Sbodypart{i}.global.perSegmentKP(length(model.cutsKP)+1)=mean(Lbodypart{i}.global.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sbodypart{i}.orientation.perSegmentKP(length(model.cutsKP)+1)=mean(Lbodypart{i}.orientation.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sbodypart{i}.position.perSegmentKP(length(model.cutsKP)+1)=mean(Lbodypart{i}.position.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sbodypart{i}.global.global = scoreToPercentage(Sbodypart{i}.global.global,seuils(3),minseuils(3));
        Sbodypart{i}.global.perSegment = scoreToPercentage(Sbodypart{i}.global.perSegment,seuils(3),minseuils(3));
        Sbodypart{i}.global.perSegmentKP = scoreToPercentage(Sbodypart{i}.global.perSegmentKP,seuils(3),minseuils(3));
        Sbodypart{i}.orientation.global = scoreToPercentage(Sbodypart{i}.orientation.global,seuils(4),minseuils(4));
        Sbodypart{i}.orientation.perSegment = scoreToPercentage(Sbodypart{i}.orientation.perSegment,seuils(4),minseuils(4));
        Sbodypart{i}.orientation.perSegmentKP = scoreToPercentage(Sbodypart{i}.orientation.perSegmentKP,seuils(4),minseuils(4));
        Sbodypart{i}.position.global = scoreToPercentage(Sbodypart{i}.position.global,seuils(4),minseuils(4));
        Sbodypart{i}.position.perSegment = scoreToPercentage(Sbodypart{i}.position.perSegment,seuils(4),minseuils(4));
        Sbodypart{i}.position.perSegmentKP = scoreToPercentage(Sbodypart{i}.position.perSegmentKP,seuils(4),minseuils(4));
    else
        Sbodypart{i}.name = Lbodypart{i}.name;
        Sbodypart{i}.global.name = Lbodypart{i}.global.name;
        Sbodypart{i}.global.global = mean(Lbodypart{i}.global.data);
        Sbodypart{i}.global.perSegment(1) = mean(Lbodypart{i}.global.data(1:model.cuts(1)));
        for c=1:length(model.cuts)-1
            Sbodypart{i}.global.perSegment(c+1)=mean(Lbodypart{i}.global.data(model.cuts(c)+1:model.cuts(c+1)));
        end
        Sbodypart{i}.global.perSegment(length(model.cuts)+1)=mean(Lbodypart{i}.global.data(model.cuts(length(model.cuts))+1:end));
        Sbodypart{i}.global.perSegmentKP(1) = mean(Lbodypart{i}.global.data(1:model.cutsKP(1)));
        for c=1:length(model.cutsKP)-1
            Sbodypart{i}.global.perSegmentKP(c+1)=mean(Lbodypart{i}.global.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
        end
        Sbodypart{i}.global.perSegmentKP(length(model.cutsKP)+1)=mean(Lbodypart{i}.global.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sbodypart{i}.global.global = scoreToPercentage(Sbodypart{i}.global.global,seuils(4),minseuils(4));
        Sbodypart{i}.global.perSegment = scoreToPercentage(Sbodypart{i}.global.perSegment,seuils(4),minseuils(4));
        Sbodypart{i}.global.perSegmentKP = scoreToPercentage(Sbodypart{i}.global.perSegmentKP,seuils(4),minseuils(4));
    end
end
% joints
for i=1:length(Ljoints)
    if i<=6
        Sjoints{i}.name = Ljoints{i}.name;
        Sjoints{i}.global.name = Ljoints{i}.global.name;
        Sjoints{i}.orientation.name = Ljoints{i}.orientation.name;
        Sjoints{i}.position.name = Ljoints{i}.position.name;
        Sjoints{i}.global.global = mean(Ljoints{i}.global.data);
        Sjoints{i}.orientation.global = mean(Ljoints{i}.orientation.data);
        Sjoints{i}.position.global = mean(Ljoints{i}.position.data);
        Sjoints{i}.global.perSegment(1) = mean(Ljoints{i}.global.data(1:model.cuts(1)));
        Sjoints{i}.orientation.perSegment(1) = mean(Ljoints{i}.orientation.data(1:model.cuts(1)));
        Sjoints{i}.position.perSegment(1) = mean(Ljoints{i}.position.data(1:model.cuts(1)));
        for c=1:length(model.cuts)-1
            Sjoints{i}.global.perSegment(c+1)=mean(Ljoints{i}.global.data(model.cuts(c)+1:model.cuts(c+1)));
            Sjoints{i}.orientation.perSegment(c+1)=mean(Ljoints{i}.orientation.data(model.cuts(c)+1:model.cuts(c+1)));
            Sjoints{i}.position.perSegment(c+1)=mean(Ljoints{i}.position.data(model.cuts(c)+1:model.cuts(c+1)));
        end
        Sjoints{i}.global.perSegment(length(model.cuts)+1)=mean(Ljoints{i}.global.data(model.cuts(length(model.cuts))+1:end));
        Sjoints{i}.orientation.perSegment(length(model.cuts)+1)=mean(Ljoints{i}.orientation.data(model.cuts(length(model.cuts))+1:end));
        Sjoints{i}.position.perSegment(length(model.cuts)+1)=mean(Ljoints{i}.position.data(model.cuts(length(model.cuts))+1:end));
        Sjoints{i}.global.perSegmentKP(1) = mean(Ljoints{i}.global.data(1:model.cutsKP(1)));
        Sjoints{i}.orientation.perSegmentKP(1) = mean(Ljoints{i}.orientation.data(1:model.cutsKP(1)));
        Sjoints{i}.position.perSegmentKP(1) = mean(Ljoints{i}.position.data(1:model.cutsKP(1)));
        for c=1:length(model.cutsKP)-1
            Sjoints{i}.global.perSegmentKP(c+1)=mean(Ljoints{i}.global.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
            Sjoints{i}.orientation.perSegmentKP(c+1)=mean(Ljoints{i}.orientation.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
            Sjoints{i}.position.perSegmentKP(c+1)=mean(Ljoints{i}.position.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
        end
        Sjoints{i}.global.perSegmentKP(length(model.cutsKP)+1)=mean(Ljoints{i}.global.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sjoints{i}.orientation.perSegmentKP(length(model.cutsKP)+1)=mean(Ljoints{i}.orientation.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sjoints{i}.position.perSegmentKP(length(model.cutsKP)+1)=mean(Ljoints{i}.position.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sjoints{i}.global.global = scoreToPercentage(Sjoints{i}.global.global,seuils(5),minseuils(5));
        Sjoints{i}.global.perSegment = scoreToPercentage(Sjoints{i}.global.perSegment,seuils(5),minseuils(5));
        Sjoints{i}.global.perSegmentKP = scoreToPercentage(Sjoints{i}.global.perSegmentKP,seuils(5),minseuils(5));
        Sjoints{i}.orientation.global = scoreToPercentage(Sjoints{i}.orientation.global,seuils(6),minseuils(6));
        Sjoints{i}.orientation.perSegment = scoreToPercentage(Sjoints{i}.orientation.perSegment,seuils(6),minseuils(6));
        Sjoints{i}.orientation.perSegmentKP = scoreToPercentage(Sjoints{i}.orientation.perSegmentKP,seuils(6),minseuils(6));
        Sjoints{i}.position.global = scoreToPercentage(Sjoints{i}.position.global,seuils(6),minseuils(6));
        Sjoints{i}.position.perSegment = scoreToPercentage(Sjoints{i}.position.perSegment,seuils(6),minseuils(6));
        Sjoints{i}.position.perSegmentKP = scoreToPercentage(Sjoints{i}.position.perSegmentKP,seuils(6),minseuils(6));
    else
        Sjoints{i}.name = Ljoints{i}.name;
        Sjoints{i}.global.name = Ljoints{i}.global.name;
        Sjoints{i}.global.global = mean(Ljoints{i}.global.data);
        Sjoints{i}.global.perSegment(1) = mean(Ljoints{i}.global.data(1:model.cuts(1)));
        for c=1:length(model.cuts)-1
            Sjoints{i}.global.perSegment(c+1)=mean(Ljoints{i}.global.data(model.cuts(c)+1:model.cuts(c+1)));
        end
        Sjoints{i}.global.perSegment(length(model.cuts)+1)=mean(Ljoints{i}.global.data(model.cuts(length(model.cuts))+1:end));
        Sjoints{i}.global.perSegmentKP(1) = mean(Ljoints{i}.global.data(1:model.cutsKP(1)));
        for c=1:length(model.cutsKP)-1
            Sjoints{i}.global.perSegmentKP(c+1)=mean(Ljoints{i}.global.data(model.cutsKP(c)+1:model.cutsKP(c+1)));
        end
        Sjoints{i}.global.perSegmentKP(length(model.cutsKP)+1)=mean(Ljoints{i}.global.data(model.cutsKP(length(model.cutsKP))+1:end));
        Sjoints{i}.global.global = scoreToPercentage(Sjoints{i}.global.global,seuils(6),minseuils(6));
        Sjoints{i}.global.perSegment = scoreToPercentage(Sjoints{i}.global.perSegment,seuils(6),minseuils(6));
        Sjoints{i}.global.perSegmentKP = scoreToPercentage(Sjoints{i}.global.perSegmentKP,seuils(6),minseuils(6));
    end
end

