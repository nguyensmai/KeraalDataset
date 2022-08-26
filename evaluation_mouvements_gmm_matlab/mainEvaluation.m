clear all
clc

addpath m_fcts functions

%% Parameters
nbData = 300; %Number of datapoints
seuil=-200; % Threshold used for computing score in percentage. The more close it is to zero, the more strict is the evaluation
registration=1; % temporal alignment or not
filt=1; % filtering of data or not
est=1; %estimation of orientation from position or kinect quaternions
rem=1; % removal of begining of the sequence (no motion) or not
ws=21; % windows size for segmentation
fastDP=1; %fast temporal alignment (using windows instead of full sequence) or not 

%% load data
% model
load modelExo3

% data train for temporal alignment
dirTrain='data/Assis3Maxime/';
fnameTrain='SkeletonSequence1.txt';
[oriMatTrain,posMatTrain,dataTrain] = loadData(dirTrain,fnameTrain,filt,est,rem,ws,nbData);

% data test
dirTest='data/Assis1Maxime/';
fnameTest='SkeletonSequence3.txt';
[oriMatTest_,posMatTest_,dataTest_] = loadData(dirTest,fnameTest,filt,est,rem,ws,nbData);
dataTest{1}=dataTest_;oriMatTestLong{1}=oriMatTest_;posMatTestLong{1}=posMatTest_;

%% Evaluate sequence
for rep=1:length(dataTest)
    % temporal alignment
    if registration==1
        [dataTestAligned,r,allPoses,poses,motion,distFI] = temporalAlignmentEval(model, dataTrain,dataTest{rep},fastDP);
        posMatTest=posMatTestLong{rep}(:,r);
    else
        dataTestAligned=dataTest{rep};
    end

    % compute likelihoods
    [Lglobal,Lbodypart,Ljoints] = computeLikelihoods(model,dataTestAligned);

    % get scores
    seuils=[seuil seuil seuil seuil seuil seuil];minseuils=[-500 -500 -500 -500 -500 -500]; %default values
    [Sglobal,Sbodypart,Sjoints] = computeScores(model,Lglobal,Lbodypart,Ljoints,seuils,minseuils);
    scoreLA=[Sbodypart{1}.global.global Sbodypart{1}.global.perSegment];
    scoreRA=[Sbodypart{2}.global.global Sbodypart{2}.global.perSegment];
    scoreCol=[Sbodypart{3}.global.global Sbodypart{3}.global.perSegment];
    % For each score, the first value corresponds to global score for the
    % whole sequence, and then for each temporal segment
   
end