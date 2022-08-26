function [ diff ] = computeTestErrorFeatures( train,test,bounds,bp )
%COMPUTETESTERRORFEATURES Summary of this function goes here
%   Compute error feature of the test segment

diff=[];
    for t=bounds(1):bounds(2)
        for i=(bp-1)*3+1:(bp-1)*3+3            
            diff=[diff logmap(test{i}.data(:,t),train{i}.data(:,t))'];
        end
        if bp<3
            for i=(bp-1)*3+10:(bp-1)*3+12           
                diff=[diff (train{i}.data(:,t)-test{i}.data(:,t))'];
            end
        end
    end

end

