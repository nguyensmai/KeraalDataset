function [ errorCode ] = classifyError( model,svmmodels,train,test,bp,numseg )
%CLASSIFYERROR Summary of this function goes here
%   Detailed explanation goes here
% SVM Classification of error and transformation to error code

cuts=[0 model.cuts length(train{1}.data)];
bounds=[cuts(numseg)+1 cuts(numseg+1)];
[ diff ] = computeTestErrorFeatures( train,test,bounds,bp );
if isfield(svmmodels{numseg}.bodypart{bp},'errorModel')==1
    [result,score] = multisvmMax(svmmodels{numseg}.bodypart{bp}.models,diff,svmmodels{numseg}.bodypart{bp}.errorModel);
else
    [result,score] = multisvmMax(svmmodels{numseg}.bodypart{bp}.models,diff,0);
end
exo = svmmodels{numseg}.exercise;
if score<-0.2
    errorCode=600;
else
    switch exo
        case 1
            switch result
                case 1
                    errorCode=301;
                case 2
                    errorCode=304;
                case 3
                    errorCode=402;
                otherwise
                    errorCode=600;                    
            end
        case 2
            switch result
                case 1
                    errorCode=306;
                case 2
                    errorCode=403;
                case 3
                    errorCode=401;
                otherwise
                    errorCode=600;
            end
        case 3
            switch result
                case 1
                    errorCode=301;
                case 2
                    errorCode=406;
                case 3
                    errorCode=401;
                otherwise
                    errorCode=600;
            end
        otherwise
            errorCode=600;    
    end
end
end

