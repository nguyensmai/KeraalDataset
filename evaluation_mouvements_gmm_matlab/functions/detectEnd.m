function [ d ] = detectEnd( trainD, testD,ori )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

d = zeros(1,size(testD{1}.data,2));
for col=1:size(testD{1}.data,2)
    if ori==1
        d(1,col)=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,1));logmap(testD{2}.data(:,col), trainD{2}.data(:,1));logmap(testD{3}.data(:,col), trainD{3}.data(:,1));logmap(testD{4}.data(:,col), trainD{4}.data(:,1));logmap(testD{5}.data(:,col), trainD{5}.data(:,1));logmap(testD{6}.data(:,col), trainD{6}.data(:,1))]);
    else
        d(1,col)=norm([testD{10}.data(:,col) - trainD{10}.data(:,1);testD{11}.data(:,col) - trainD{11}.data(:,1);testD{12}.data(:,col) - trainD{12}.data(:,1);testD{13}.data(:,col) - trainD{13}.data(:,1);testD{14}.data(:,col) - trainD{14}.data(:,1);testD{15}.data(:,col) - trainD{15}.data(:,1)]);
    end
end

end

