function [ oriMat ] = estimateOrientationFromPosition( posMat )
%ESTIMATEORIENTATIONFROMPOSITION Summary of this function goes here
%   Detailed explanation goes here
    
    % defined bases for each joint
    bases=[
        0 0 0;%bSpine
        0 1 0;%mSpine
        0 1 0;%Neck
        0 1 0;%Head
        0 1 0;%lShoulder
        0 1 0;%lElbow
        0 1 0;%lWrist
        0 1 0;%lHand
        0 1 0;%rShoulder
        0 1 0;%rElbow
        0 1 0;%rWrist
        0 1 0;%rHand
        0 1 0;%lHip
        0 1 0;%lKnee
        0 1 0;%lAnkle
        0 1 0;%lFoot
        0 1 0;%rHip
        0 1 0;%rKnee
        0 1 0;%rAnkle
        0 1 0;%rFoot
        0 1 0;%mShoulder
        0 1 0;%lTip
        0 1 0;%lThumb
        0 1 0;%rTip
        0 1 0;%rThumb
        ];
    dirs=zeros(size(posMat));
    dirs(:,1:3)=zeros(size(posMat,1),3);%bSpine
    dirs(:,4:6)=posMat(:,4:6)-posMat(:,1:3);%mSpine
    dirs(:,7:9)=posMat(:,7:9)-posMat(:,61:63);%Neck
    dirs(:,10:12)=posMat(:,10:12)-posMat(:,7:9);%Head
    dirs(:,13:15)=posMat(:,13:15)-posMat(:,61:63);%lShoulder
    dirs(:,16:18)=posMat(:,16:18)-posMat(:,13:15);%lElbow
    dirs(:,19:21)=posMat(:,19:21)-posMat(:,16:18);%lWrist
    dirs(:,22:24)=posMat(:,22:24)-posMat(:,19:21);%lHand
    dirs(:,25:27)=posMat(:,25:27)-posMat(:,61:63);%rShoulder
    dirs(:,28:30)=posMat(:,28:30)-posMat(:,25:27);%rElbow
    dirs(:,31:33)=posMat(:,31:33)-posMat(:,28:30);%rWrist
    dirs(:,34:36)=posMat(:,34:36)-posMat(:,31:33);%rHand
    dirs(:,37:39)=posMat(:,37:39)-posMat(:,1:3);%lHip
    dirs(:,40:42)=posMat(:,40:42)-posMat(:,37:39);%lKnee
    dirs(:,43:45)=posMat(:,43:45)-posMat(:,40:42);%lAnkle
    dirs(:,46:48)=posMat(:,46:48)-posMat(:,43:45);%lFoot
    dirs(:,49:51)=posMat(:,49:51)-posMat(:,1:3);%rHip
    dirs(:,52:54)=posMat(:,52:54)-posMat(:,49:51);%rKnee
    dirs(:,55:57)=posMat(:,55:57)-posMat(:,52:54);%rAnkle
    dirs(:,58:60)=posMat(:,58:60)-posMat(:,55:57);%rFoot
    dirs(:,61:63)=posMat(:,61:63)-posMat(:,4:6);%mShoulder
    dirs(:,64:66)=posMat(:,64:66)-posMat(:,19:21);%lTip
    dirs(:,67:69)=posMat(:,67:69)-posMat(:,22:24);%lThumb
    dirs(:,70:72)=posMat(:,70:72)-posMat(:,31:33);%rTip
    dirs(:,73:75)=posMat(:,73:75)-posMat(:,34:36);%rThumb
    oriMat=[];
    for t=1:size(posMat,1)
        oriVec=zeros(1,4*25);
        for b=1:25 %bones
            fO=(b-1)*4;
            fP=(b-1)*3;
            oriVec(1,fO+1:fO+4)=compute_q_from_dirbase(dirs(t,fP+1:fP+3),bases(b,:));
        end
        oriMat=[oriMat oriVec'];
    end
    oriMat(isnan(oriMat))=0;
    oriMat=oriMat';
end

function q = compute_q_from_dirbase(dir,base)
    normD=sqrt(dir(1)^2+dir(2)^2+dir(3)^2);
    normB=norm(base);
    dir=dir/normD;
    a=cross(dir,base);
    w=dot(dir,base);
    q=[w a(1) a(2) a(3)];
    normq=sqrt(q(1)^2+q(2)^2+q(3)^2+q(4)^2);
    q(1)=q(1)+normq;
    normq=sqrt(q(1)^2+q(2)^2+q(3)^2+q(4)^2);
    q=q/normq;
end