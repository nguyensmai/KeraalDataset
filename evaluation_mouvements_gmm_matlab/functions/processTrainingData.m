function [ model,xIn, uIn, xOut, uOut ] = processTrainingData( model,trainName, nspp,registration,fastDP,filt,est,rem,ws,nbData )
%PROCESSTRAININGDATA Summary of this function goes here
%   whole process of training data in one function for clarity

uIn=[];
for i=1:15
    uOut{i}.data=[];
end
for tn=1:length(trainName)
    for i=1:nspp
        fname=sprintf('SkeletonSequence%i.txt',i);
        [oriMatTrain,posMatTrain,dataTrain] = loadData(trainName{tn},fname,filt,est,rem,ws,nbData);
        out=[dataTrain{1}.data; dataTrain{2}.data; dataTrain{3}.data; dataTrain{4}.data; dataTrain{5}.data; dataTrain{6}.data];
        [ cuts,variation ] = segmentSequence( out, ws, 0.05 );
        v=variation(cuts);
        cuts(v>0.1)=[];
        %plot(variation);
        [ cutsKP,variationKP ] = segmentSequenceKeyPose( out, ws, 0.02 );
        if isempty(uIn)
            model.cuts=cuts;model.cutsKP=cutsKP;
        end
        if registration==1
            if isempty(uIn)
                for d=1:15
                    uRef{d}.data=dataTrain{d}.data;
                end
            else
               [dataTrain] = temporalAlignment(uRef,dataTrain,fastDP);
            end
        end
        uIn = [uIn, [1:nbData]*model.dt];
        for d=1:length(uOut)
            uOut{d}.data=[uOut{d}.data dataTrain{d}.data];
        end
    end
end
xIn = uIn;
for d=1:length(uOut)
    xOut{d}.data=uOut{d}.data;
    if d<10
        uOut{d}.data=logmap(uOut{d}.data, [0; 1; 0; 0]);
    end
end

end

