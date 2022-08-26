function [ cuts, variation ] = segmentSequence( in, ws, thres )
%SEGMENTSEQUENCE Summary of this function goes here
%   Detailed explanation goes here
    variation=nan(1,size(in,2));
    for t=round(ws/2):size(in,2)-floor(ws/2)
        sigma=0;
        for w=-floor(ws/2):1:floor(ws/2)
            for d=1:size(in,1)/4
                muMan= in((d-1)*4+1:(d-1)*4+4,t);
                sigma = sigma + norm(logmap(in((d-1)*4+1:(d-1)*4+4,t+w),muMan))^2;
            end
        end
        sigma=sigma/ws;
        variation(t)=sigma;
    end
    [maxtab, mintab]=peakdet(variation, thres);
    if size(mintab,2)>0
        cuts=mintab(:,1)';
    else
        cuts=[];
    end
end

