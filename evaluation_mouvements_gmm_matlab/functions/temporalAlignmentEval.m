function [ out,r,performedEntirely,poseTracking,motionStarted,distFromInit] = temporalAlignmentEval( model, trainD, testD, fast )
%TEMPORALALIGNMENT Summary of this function goes here
%   Dynamic programming to align two sequences train and test
%   fast may be set to 1 to speed process by using small windows of 70
%   Add tracking of keyposes to check if movement is entirely performed
%   Add movement from initial pose to check if movement is started

% Compute distances
keypose=1;
prevDist=5;
poseTracking=zeros(1,length(model.cuts));
motionStarted=0;
distFromInit=[];

performedEntirely=0;
out=testD;
if fast==1
    resampleSize=10;
else
    resampleSize=1;
end
% rtemp = spline(1:size(trainD{1}.data,2), 1:size(trainD{1}.data,2), linspace(1,length(out{1}.data),resampleSize));
% for i=1:length(trainD)
%     trainD{i}.data = spline(1:size(trainD{i}.data,2), trainD{i}.data, linspace(1,size(trainD{i}.data,2),resampleSize));
%     testD{i}.data = spline(1:size(testD{i}.data,2), testD{i}.data, linspace(1,size(testD{i}.data,2),resampleSize));
% end
%DM=ones(size(testD{1}.data,2),size(testD{1}.data,2))*5;
icol=0;irow=0;
for row=1:resampleSize:size(testD{1}.data,2)+1
    if row>size(testD{1}.data,2)
        row=size(testD{1}.data,2);
    end
    irow=irow+1;
    icol=0;
    kf(irow)=row;
    for col=1:resampleSize:size(testD{1}.data,2)+1
        if col>size(testD{1}.data,2)
            col=size(testD{1}.data,2);
        end
        icol=icol+1;
        if fast==1
            if (abs(row-col)<150)
                DM(irow,icol)=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,row));logmap(testD{2}.data(:,col), trainD{2}.data(:,row));logmap(testD{3}.data(:,col), trainD{3}.data(:,row));logmap(testD{4}.data(:,col), trainD{4}.data(:,row));logmap(testD{5}.data(:,col), trainD{5}.data(:,row));logmap(testD{6}.data(:,col), trainD{6}.data(:,row))]);
            end
        else
            DM(irow,icol)=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,row));logmap(testD{2}.data(:,col), trainD{2}.data(:,row));logmap(testD{3}.data(:,col), trainD{3}.data(:,row));logmap(testD{4}.data(:,col), trainD{4}.data(:,row));logmap(testD{5}.data(:,col), trainD{5}.data(:,row));logmap(testD{6}.data(:,col), trainD{6}.data(:,row))]);
        end
        % keyposeTracking
        if irow==1 && performedEntirely==0
            dist=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,model.cuts(keypose)));logmap(testD{2}.data(:,col), trainD{2}.data(:,model.cuts(keypose)));logmap(testD{3}.data(:,col), trainD{3}.data(:,model.cuts(keypose)));logmap(testD{4}.data(:,col), trainD{4}.data(:,model.cuts(keypose)));logmap(testD{5}.data(:,col), trainD{5}.data(:,model.cuts(keypose)));logmap(testD{6}.data(:,col), trainD{6}.data(:,model.cuts(keypose)))]);
            if prevDist<1.7 && dist>prevDist
                poseTracking(keypose)=1;
                keypose=keypose+1;
                if keypose>length(model.cuts)
                    performedEntirely=1;
                else
                    dist=norm([logmap(testD{1}.data(:,col), trainD{1}.data(:,model.cuts(keypose)));logmap(testD{2}.data(:,col), trainD{2}.data(:,model.cuts(keypose)));logmap(testD{3}.data(:,col), trainD{3}.data(:,model.cuts(keypose)));logmap(testD{4}.data(:,col), trainD{4}.data(:,model.cuts(keypose)));logmap(testD{5}.data(:,col), trainD{5}.data(:,model.cuts(keypose)));logmap(testD{6}.data(:,col), trainD{6}.data(:,model.cuts(keypose)))]);
                end
            end
            prevDist=dist;
            if col==size(testD{1}.data,2) && dist<1.4 && keypose==length(model.cuts) && poseTracking(keypose)==0
                poseTracking(keypose)=1;
                performedEntirely=1;
            end
        end
        % distance from init
        if irow==1
            distFI=norm([logmap(testD{1}.data(:,col), testD{1}.data(:,1));logmap(testD{2}.data(:,col), testD{2}.data(:,1));logmap(testD{3}.data(:,col), testD{3}.data(:,1));logmap(testD{4}.data(:,col), testD{4}.data(:,1));logmap(testD{5}.data(:,col), testD{5}.data(:,1));logmap(testD{6}.data(:,col), testD{6}.data(:,1))]);
            if distFI<1.4
                distFromInit=[distFromInit 0];
            else
                distFromInit=[distFromInit 1];
            end
        end
    end
end
%poseTracking
if (sum(distFromInit)/length(distFromInit))>0.2
    motionStarted=1;
end
%imagesc(DM);
% dynamic programming
[p,q,C] = dp(DM);
%imagesc(DM);hold on; plot(q,p,'r-');
% alignment
r=zeros(1,size(DM,2));
for t=1:size(DM,2)
    [val,ind]=find(p==t);
    if isempty(ind)
        r(t)=p(t);
    else
        r(t)=q(ind(1));
    end
end
if performedEntirely==1 && r(end)<max(p)
    r(end-1)=r(end-2);
    r(end)=r(end-2);
end
r=kf(r);
rfull=zeros(1,300);
rfull(kf)=r;
for i=1:length(r)-1
    if r(i)==r(i+1)
        temp=ones(1,resampleSize-1)*r(i);
    else
        %if i==(length(r)-1)*50
        %    temp=spline(1:resampleSize-2, r(i)+1:r(i+1), linspace(1,resampleSize-2,resampleSize-2));
        %else
            %temp=spline(1:resampleSize-1, r(i)+1:r(i+1)-1, linspace(1,length(r(i)+1:r(i+1)-1),resampleSize-1));
        temp=round(linspace(r(i)+1,r(i+1)-1,resampleSize-1));
            %temp=spline(1:resampleSize-1, r(i)+1:r(i+1)-2, linspace(1,length(r(i)+1:r(i+1)-2),resampleSize-1));
        %end
    end
    rfull((i-1)*resampleSize+2:i*resampleSize)=temp;
end

%out = testD;
r=rfull;
%check is any r=0
for i=1:length(rfull)
    if r(i)==0
        if i==1
            r(i)=1;
        else
            r(i)=r(i-1);
        end
    end
end
for i=1:length(testD)
    out{i}.data = testD{i}.data(:,r);
    %out{i}.data = spline(1:size(out{i}.data,2), out{i}.data, linspace(1,size(out{i}.data,2),size(testD{i}.data,2)));
end

end

