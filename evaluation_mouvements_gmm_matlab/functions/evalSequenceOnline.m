function [ LL,L1R,L2R,L3R ] = evalSequenceOnline( bodies )
%EVALSEQUENCEONLINE Summary of this function goes here
%   Detailed explanation goes here
%addpath m_fcts
%addpath functions
load modelAssis3AlexNico1LA_Est_20R
nbData = 300; %Number of datapoints

registration=1;

%Train data
dirTrain='../data/Assis1Alexandre/';
fname='SkeletonSequence1.txt';
M=dlmread([dirTrain fname]);
oriMatTrain=[];posMatTrain=[];
for j=1:25
    fO=(j-1)*7+4;
    oriMatTrain=[oriMatTrain M(:,fO:fO+3)];
    fP=(j-1)*7+1;
    posMatTrain=[posMatTrain M(:,fP:fP+2)];
end
%Filtrage
[b,a] = butter(3,0.05);
posMatTrain = filter(b,a,posMatTrain);
oriMatTrain = filter(b,a,oriMatTrain);
oriMatTrain = (estimateOrientationFromPosition( posMatTrain ))';
data=oriMatTrain(21:24,:);%lElbow
data2=oriMatTrain(25:28,:);%lWrist
data3=oriMatTrain(17:20,:);%lShoulder
data4=oriMatTrain(37:40,:);%rElbow
data5=oriMatTrain(41:44,:);%rWrist
data6=oriMatTrain(33:36,:);%rShoulder
in=[data; data2; data3; data4; data5; data6];
ws=21;
[ out,deb ] = removeStart( in, ws, 0.001, 10 );
oriMatTrain=oriMatTrain(:,deb:end);
oriMatTrain = spline(1:size(oriMatTrain,2), oriMatTrain, linspace(1,size(oriMatTrain,2),300)); %Resampling


% dir='data/Assis1Nicolas/';
% fname='SkeletonSequence2.txt';
% M2=dlmread([dir fname]); %M2 is taken from live acquisition
M2=[];
for b=1:length(bodies)
    frame=[];
    for j=1:size(bodies{b}.Position,2)
        frame=[frame bodies{b}.Position(:,j)' bodies{b}.Orientation(:,j)'];
    end
    M2=[M2;frame;];
end

oriMat=[];posMat=[];
for j=1:25
    fO=(j-1)*7+4;
    oriMat=[oriMat M2(:,fO:fO+3)];
    fP=(j-1)*7+1;
    posMat=[posMat M2(:,fP:fP+2)];
end
%Filtrage
[b,a] = butter(3,0.05);
posMat = filter(b,a,posMat);
oriMat = filter(b,a,oriMat);
oriMat = estimateOrientationFromPosition( posMat );
data=oriMat(:,21:24)';%lElbow
data2=oriMat(:,25:28)';%lWrist
data3=oriMat(:,17:20)';%lShoulder
data4=oriMat(:,37:40)';%rElbow
data5=oriMat(:,41:44)';%rWrist
data6=oriMat(:,33:36)';%rShoulder
data7=oriMat(:,5:8)';%mSpine
data8=oriMat(:,81:84)';%mShoulder
data9=oriMat(:,9:12)';%Neck
%data=oriMat(:,:)';
% Detection du début et segmentation
in=[data; data2; data3; data4; data5; data6];
ws=21;
[ out,deb ] = removeStart( in, ws, 0.001, 10 );
out = spline(1:size(out,2), out, linspace(1,size(out,2),nbData)); %Resampling
data=data(:,deb:end);data2=data2(:,deb:end);data3=data3(:,deb:end);
data4=data4(:,deb:end);data5=data5(:,deb:end);data6=data6(:,deb:end);
data7=data7(:,deb:end);data8=data8(:,deb:end);data9=data9(:,deb:end);
data = spline(1:size(data,2), data, linspace(1,size(data,2),nbData)); %Resampling
data2 = spline(1:size(data2,2), data2, linspace(1,size(data2,2),nbData)); %Resampling
data3 = spline(1:size(data3,2), data3, linspace(1,size(data3,2),nbData)); %Resampling
data4 = spline(1:size(data4,2), data4, linspace(1,size(data4,2),nbData)); %Resampling
data5 = spline(1:size(data5,2), data5, linspace(1,size(data5,2),nbData)); %Resampling
data6 = spline(1:size(data6,2), data6, linspace(1,size(data6,2),nbData)); %Resampling
data7 = spline(1:size(data7,2), data7, linspace(1,size(data7,2),nbData)); %Resampling
data8 = spline(1:size(data8,2), data8, linspace(1,size(data8,2),nbData)); %Resampling
data9 = spline(1:size(data9,2), data9, linspace(1,size(data9,2),nbData)); %Resampling
dataP=posMat';
dataP = spline(1:size(dataP,2), dataP, linspace(1,size(dataP,2),nbData)); %Resampling
xIn = [1:nbData]*model.dt;
if registration==1
    for row=1:length(data)
        for col=1:length(data)
            DM(row,col)=norm([logmap(data(:,col), oriMatTrain((5)*4+1:(5)*4+4,row));logmap(data4(:,col), oriMatTrain((9)*4+1:(9)*4+4,row))]);
        end
    end
    [p,q,C] = dp(DM);
    for t=1:300
        [val,ind]=find(p==t);
        if isempty(ind)
            r(t)=q(t);
        else
            r(t)=q(ind(1));
        end
    end
else
    r=[1:nbData];
end
xOut1 = data(:,r);
xOut2 = data2(:,r);
xOut3 = data3(:,r);
xOut4 = data4(:,r);
xOut5 = data5(:,r);
xOut6 = data6(:,r);
xOut7 = data7(:,r);
xOut8 = data8(:,r);
xOut9 = data9(:,r);
%x=[xIn; xOut1;];
%x=[xIn; xOut2; xOut5 ];
%x=[xIn; xOut1; xOut2; xOut4; xOut5 ];
%x=[xIn; xOut7; xOut8; xOut9; ];
%x=[xIn; xOut1; xOut2; xOut3; xOut4; xOut5; xOut6 ];
%x=[xIn; xOut1; xOut2; xOut3; xOut4; xOut5; xOut6; xOut7; xOut8 ];
[ cuts,variation ] = segmentSequence( [xOut1; xOut2; xOut3; xOut4; xOut5; xOut6 ], ws, 0.0005 );

for i=1:model.nbStates
    %L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i))], model.Mu(:,i), model.Sigma(:,:,i));
    %L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i))], model.Mu(:,i), model.Sigma(:,:,i));
    %L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i)); logmap(xOut4, model.MuMan(10:13,i)); logmap(xOut5, model.MuMan(14:17,i))], model.Mu(:,i), model.Sigma(:,:,i));
    %L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i)); logmap(xOut3, model.MuMan(10:13,i)); logmap(xOut4, model.MuMan(14:17,i)); logmap(xOut5, model.MuMan(18:21,i)); logmap(xOut6, model.MuMan(22:25,i))], model.Mu(:,i), model.Sigma(:,:,i));
    %L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i)); logmap(xOut3, model.MuMan(10:13,i)); logmap(xOut4, model.MuMan(14:17,i)); logmap(xOut5, model.MuMan(18:21,i)); logmap(xOut6, model.MuMan(22:25,i)); logmap(xOut7, model.MuMan(26:29,i)); logmap(xOut8, model.MuMan(30:33,i))], model.Mu(:,i), model.Sigma(:,:,i));
    L(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i)); logmap(xOut3, model.MuMan(10:13,i))], model.Mu(:,i), model.Sigma(:,:,i));
end

LL=log(sum(L));
score=mean(LL);
%LL(LL<1E-4)=1E-4;
%LL=sum(log(LL));
%LLm=LL/size(L,2);


in=1; out=2:4; outMan=2:5;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:4)=model.Sigma(in,out,i);
    sigma(2:4,1)=model.Sigma(out,in,i);
    sigma(2:4,2:4)=model.Sigma(out,out,i);
    L1R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(outMan,i))], mu, sigma);
end
L1R=log(sum(L1R));
% 
in=1; out=5:7; outMan=6:9;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:4)=model.Sigma(in,out,i);
    sigma(2:4,1)=model.Sigma(out,in,i);
    sigma(2:4,2:4)=model.Sigma(out,out,i);
    L2R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut2, model.MuMan(outMan,i))], mu, sigma);
end
L2R=log(sum(L2R));

in=1; out=8:10; outMan=10:13;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:4)=model.Sigma(in,out,i);
    sigma(2:4,1)=model.Sigma(out,in,i);
    sigma(2:4,2:4)=model.Sigma(out,out,i);
    L3R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut3, model.MuMan(outMan,i))], mu, sigma);
end
L3R=log(sum(L3R));

% in=1; out=11:13; outMan=14:17;
% for i=1:model.nbStates
%     mu=[model.Mu(in,i)' model.Mu(out,i)']';
%     sigma(1,1)= model.Sigma(in, in,i);
%     sigma(1,2:4)=model.Sigma(in,out,i);
%     sigma(2:4,1)=model.Sigma(out,in,i);
%     sigma(2:4,2:4)=model.Sigma(out,out,i);
%     L4R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut4, model.MuMan(outMan,i))], mu, sigma);
% end
% L4R=log(sum(L4R));
% 
% in=1; out=14:16; outMan=18:21;
% for i=1:model.nbStates
%     mu=[model.Mu(in,i)' model.Mu(out,i)']';
%     sigma(1,1)= model.Sigma(in, in,i);
%     sigma(1,2:4)=model.Sigma(in,out,i);
%     sigma(2:4,1)=model.Sigma(out,in,i);
%     sigma(2:4,2:4)=model.Sigma(out,out,i);
%     L5R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut5, model.MuMan(outMan,i))], mu, sigma);
% end
% L5R=log(sum(L5R));
% 
% in=1; out=17:19; outMan=22:25;
% for i=1:model.nbStates
%     mu=[model.Mu(in,i)' model.Mu(out,i)']';
%     sigma(1,1)= model.Sigma(in, in,i);
%     sigma(1,2:4)=model.Sigma(in,out,i);
%     sigma(2:4,1)=model.Sigma(out,in,i);
%     sigma(2:4,2:4)=model.Sigma(out,out,i);
%     L6R(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut6, model.MuMan(outMan,i))], mu, sigma);
% end
% L6R=log(sum(L6R));
% 
% in=1; out=2:10; outMan=2:13;
% for i=1:model.nbStates
%     mu=[model.Mu(in,i)' model.Mu(out,i)']';
%     sigma(1,1)= model.Sigma(in, in,i);
%     sigma(1,2:10)=model.Sigma(in,out,i);
%     sigma(2:10,1)=model.Sigma(out,in,i);
%     sigma(2:10,2:10)=model.Sigma(out,out,i);
%     LleftArm(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut1, model.MuMan(2:5,i)); logmap(xOut2, model.MuMan(6:9,i)); logmap(xOut3, model.MuMan(10:13,i))], mu, sigma);
% end
% LleftArm=log(sum(LleftArm));
% 
% in=1; out=11:19; outMan=14:25;
% for i=1:model.nbStates
%     mu=[model.Mu(in,i)' model.Mu(out,i)']';
%     sigma(1,1)= model.Sigma(in, in,i);
%     sigma(1,2:10)=model.Sigma(in,out,i);
%     sigma(2:10,1)=model.Sigma(out,in,i);
%     sigma(2:10,2:10)=model.Sigma(out,out,i);
%     LrightArm(i,:) = model.Priors(i) * gaussPDF([xIn(:,1:300)-model.MuMan(1,i); logmap(xOut4, model.MuMan(14:17,i)); logmap(xOut5, model.MuMan(18:21,i)); logmap(xOut6, model.MuMan(22:25,i))], mu, sigma);
% end
% LrightArm=log(sum(LrightArm));



% A=1:100;
% plot(A);




end

