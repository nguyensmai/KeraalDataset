function [ feedback ] = getFeedback( scoreAll,scoreRA,scoreLA,scoreCol,model,svmmodels,train,test,motion,allPoses,poses )
%GETFEEDBACK Summary of this function goes here
%   Detailed explanation goes here
% Get feedback from error

% Si pas de mouvement on renvoit le code et on sort
if motion==0
    errorCode=501;
    feedback(1)=0;feedback(2)=errorCode;feedback(3)=scoreAll(1);feedback(4)=0;
    return
end
% Si bon score mais pas toutes les poses on renvoit le code et on sort
if allPoses==0
    l=length(poses==1);
    if mean(scoreAll(2:l+1))>=80
        errorCode=502;
        feedback(1)=0;feedback(2)=errorCode;feedback(3)=50;feedback(4)=0;
        return
    end
end

% calcul de la pire erreur
[pireRA, segRA] = min(scoreRA(2:end-1));
[pireLA, segLA] = min(scoreLA(2:end-1));
[pireCol, segCol] = min(scoreCol(2:end-1));
[pireAll, bp] = min([pireLA pireRA pireCol]);
if bp==3
    [errorCode]=classifyError(model,svmmodels,train,test,bp,segCol);
    feedback(1)=3;feedback(2)=errorCode;feedback(4)=segCol;
else
    if bp==2
        [errorCodeRA]=classifyError(model,svmmodels,train,test,bp,segRA);
        bodyPart=2;
        if pireRA<50 && pireLA<50
            [errorCodeLA]=classifyError(model,svmmodels,train,test,1,segLA);
            if errorCodeRA==errorCodeLA
				bodyPart=4;
            end
        end
        if errorCodeRA==402 || errorCodeRA==403
            bodyPart=3;
        end            
        feedback(1)=bodyPart;feedback(2)=errorCodeRA;feedback(4)=segRA;
    else
        [errorCodeLA]=classifyError(model,svmmodels,train,test,bp,segLA);
        bodyPart=1;
        if pireRA<50 && pireLA<50
            [errorCodeRA]=classifyError(model,svmmodels,train,test,2,segRA);
            if errorCodeLA==errorCodeRA
                bodyPart=4;
            end
        end
        if errorCodeLA==402 || errorCodeLA==403
            bodyPart=3;
        end 
        feedback(1)=bodyPart;feedback(2)=errorCodeLA;feedback(4)=segLA;
    end
end
feedback(3)=scoreAll(1);

end

