function [result,scores] = multisvmMax(models,TestSet,errorModel)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 
%
%This code was written by Cody Neuburger cneuburg@fau.edu
%Florida Atlantic University, Florida USA
%This code was adapted and cleaned from Anand Mishra's multisvm function
%found at http://www.mathworks.com/matlabcentral/fileexchange/33170-multi-class-support-vector-machine/
% Modif Maxime: learning of model is already done

% u=unique(GroupTrain);
% numClasses=length(u);
% result = zeros(length(TestSet(:,1)),1);
% scores = zeros(length(TestSet(:,1)),1);
% 
% %build models
% for k=1:numClasses
%     %Vectorized statement that binarizes Group
%     %where 1 is the current class and 0 is all other classes
%     G1vAll=(GroupTrain==u(k));
%     %models(k) = svmtrain(TrainingSet,G1vAll);
%     models{k} = fitcsvm(TrainingSet,G1vAll);
%     %models{k} = fitSVMPosterior(fitcsvm(TrainingSet,G1vAll));
% end

if isobject(errorModel)==0
    %classify test cases
    for j=1:size(TestSet,1)
        for k=1:length(models)
            [label,score] = predict(models{k},TestSet(j,:));
            s(k)=score(2);
            if (label)
            %if(svmclassify(models(k),TestSet(j,:))) 
                break;
            end
        end
        s=1;
        [maxi,ind]=max(s);
        result(j) = ind;
        scores(j) = maxi;
    end
else
    for j=1:size(TestSet,1)
        % check if it is a recognized error
        [label,score] = predict(errorModel,TestSet(j,:));
        if score>-1
            for k=1:length(models)
                [label,score] = predict(models{k},TestSet(j,:));
                s(k)=score(2);
                %if (label)
                %if(svmclassify(models(k),TestSet(j,:))) 
                %    break;
                %end
            end
            [maxi,ind]=max(s);
            result(j) = ind;
            scores(j) = maxi;
        else
            result(j)=0;
            scores(j)=-1;
        end
    end
end