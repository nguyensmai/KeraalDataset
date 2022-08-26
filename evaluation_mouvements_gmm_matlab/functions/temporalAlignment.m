function [ out,r ] = temporalAlignment( trainD, testD, fast )
%TEMPORALALIGNMENT Summary of this function goes here
%   Dynamic programming to align two sequences train and test
%   fast may be set to 1 to speed process by using small windows of 70

% Compute distances
DM=ones(size(testD{1}.data,2),size(testD{1}.data,2))*5;
for row=1:size(testD{1}.data,2)
    for col=1:size(testD{1}.data,2)
        if fast==1
            if (abs(row-col)<70)
                DM(row,col)=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,row));logmap(testD{2}.data(:,col), trainD{2}.data(:,row));logmap(testD{3}.data(:,col), trainD{3}.data(:,row));logmap(testD{4}.data(:,col), trainD{4}.data(:,row));logmap(testD{5}.data(:,col), trainD{5}.data(:,row));logmap(testD{6}.data(:,col), trainD{6}.data(:,row))]);
            end
        else
            DM(row,col)=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,row));logmap(testD{2}.data(:,col), trainD{2}.data(:,row));logmap(testD{3}.data(:,col), trainD{3}.data(:,row));logmap(testD{4}.data(:,col), trainD{4}.data(:,row));logmap(testD{5}.data(:,col), trainD{5}.data(:,row));logmap(testD{6}.data(:,col), trainD{6}.data(:,row))]);
        end
    end
end

% dynamic programming
[p,q,C] = dp(DM);

% alignment
r=zeros(1,size(testD{1}.data,2));
for t=1:size(testD{1}.data,2)
    [val,ind]=find(p==t);
    if isempty(ind)
        r(t)=p(t);
    else
        r(t)=q(ind(1));
    end
end

% out
out = testD;
for i=1:length(testD)
    out{i}.data = testD{i}.data(:,r);
end

end

