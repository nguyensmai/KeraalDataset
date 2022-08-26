function [ oriMat, posMat, data ] = loadData( dir, fname, filt, est, rem, ws, resampleSize )
%LOADDATA Summary of this function goes here
%   load orientation and relative position data
%   parmaeters to filter (filt) data estimate orientation from positions (est) and to remove start (rem) may be turned on
%   Default values are used for filtering and removing start
%   return the whole matrices as well as data structure corresponding to
%   each joint orientation and relative position of arm joints


% load data
M=dlmread([dir fname]);
oriMat=[];posMat=[];
for j=1:25
    fO=(j-1)*7+4;
    oriMat=[oriMat M(:,fO:fO+3)];
    fP=(j-1)*7+1;
    posMat=[posMat M(:,fP:fP+2)];
end

% Filtering
if filt==1
    [b,a] = butter(3,0.05);
    posMat = filter(b,a,posMat);
    oriMat = filter(b,a,oriMat);
end

% Estimation
if est==1
    oriMat = estimateOrientationFromPosition( posMat );
end

% data structure
data{1}.data=oriMat(:,21:24)';data{1}.name='lElbow ori';
data{2}.data=oriMat(:,25:28)';data{2}.name='lWrist ori';
data{3}.data=oriMat(:,17:20)';data{3}.name='lShoulder ori';
data{4}.data=oriMat(:,37:40)';data{4}.name='rElbow ori';
data{5}.data=oriMat(:,41:44)';data{5}.name='rWrist ori';
data{6}.data=oriMat(:,33:36)';data{6}.name='rShoulder ori';
data{7}.data=oriMat(:,5:8)';data{7}.name='mSpine ori';
data{8}.data=oriMat(:,81:84)';data{8}.name='mShoulder ori';
data{9}.data=oriMat(:,9:12)';data{9}.name='Neck ori';
data{10}.data=(posMat(:,16:18)-posMat(:,7:9))';data{10}.name='lElbow rel_pos';
data{11}.data=(posMat(:,19:21)-posMat(:,7:9))';data{11}.name='lWrist rel_pos';
data{12}.data=(posMat(:,13:15)-posMat(:,7:9))';data{12}.name='lShoulder rel_pos';
data{13}.data=(posMat(:,28:30)-posMat(:,7:9))';data{13}.name='rElbow rel_pos';
data{14}.data=(posMat(:,31:33)-posMat(:,7:9))';data{14}.name='rWrist rel_pos';
data{15}.data=(posMat(:,25:27)-posMat(:,7:9))';data{15}.name='rShoulder rel_pos';
oriMat=oriMat';posMat=posMat';

% removing start
if rem==1
    in=[data{1}.data; data{2}.data; data{3}.data; data{4}.data; data{5}.data; data{6}.data];
    [ out,deb ] = removeStart( in, ws, 0.001, 10 );
    oriMat=oriMat(:,deb:end);posMat=posMat(:,deb:end);
    for i=1:length(data)
        data{i}.data=data{i}.data(:,deb:end);
    end
end

% resampling
for i=1:length(data)
    data{i}.data = spline(1:size(data{i}.data,2), data{i}.data, linspace(1,size(data{i}.data,2),resampleSize));
end
oriMat = spline(1:size(oriMat,2), oriMat, linspace(1,size(oriMat,2),resampleSize));
posMat = spline(1:size(posMat,2), posMat, linspace(1,size(posMat,2),resampleSize));

end

