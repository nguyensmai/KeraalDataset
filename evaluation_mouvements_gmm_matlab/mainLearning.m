clear all
clc

addpath m_fcts functions

%% Parameters
nbData = 300; %Number of datapoints
nbSamples =2; %Number of demonstrations
trainName={'data/Assis3Maxime/'}; % folders names from where to load data
nspp=2; %number of skeleton sequence per folder
model.nbVar = 46; %Dimension of the tangent space (incl. time)
model.nbVarMan = 55; %Dimension of the manifold (incl. time)
nbIter = 10; %Number of iteration for the Gauss Newton algorithm
nbIterEM = 10; %Number of iteration for the EM algorithm
model.nbStates = 15; %Number of states in the GMM
model.nbVar = 46; %Dimension of the tangent space (incl. time)
model.nbVarMan = 55; %Dimension of the manifold (incl. time)
model.dt = 0.01; %Time step duration
model.params_diagRegFact = 1E-4; %Regularization of covariance
registration=1; % temporal alignment or not
filt=1; % filtering of data or not
est=1; %estimation of orientation from position or kinect quaternions
rem=1; % removal of begining of the sequence (no motion) or not
ws=21; % windows size for segmentation
fastDP=1; %fast temporal alignment (using windows instead of full sequence) or not 


%% Data processing
[model,xIn,uIn,xOut,uOut] = processTrainingData(model,trainName,nspp,registration,fastDP,filt,est,rem,ws,nbData);
% data projected on tangent spaces of the human pose space
u = [uIn; uOut{1}.data; uOut{2}.data; uOut{3}.data; uOut{4}.data; uOut{5}.data; uOut{6}.data; uOut{7}.data; uOut{8}.data; uOut{9}.data; uOut{10}.data; uOut{11}.data; uOut{12}.data; uOut{13}.data; uOut{14}.data; uOut{15}.data];
% original data x (positions 3D and quaternions) in the human pose space
x = [xIn; xOut{1}.data; xOut{2}.data; xOut{3}.data; xOut{4}.data; xOut{5}.data; xOut{6}.data; xOut{7}.data; xOut{8}.data; xOut{9}.data; xOut{10}.data; xOut{11}.data; xOut{12}.data; xOut{13}.data; xOut{14}.data; xOut{15}.data];
model.x=x;

%% GMM learning
[ model ] = learnGMMmodel(model,u,xIn,xOut,nbSamples,nbIterEM,nbIter,nbData);

save('modelExo3','model');
