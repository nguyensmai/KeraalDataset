function [ out,deb ] = removeStart( in, ws, thres, dec )
%REMOVESTART Summary of this function goes here
%   Detailed explanation goes here

    for t=round(ws/2):size(in,2)-floor(ws/2)
        sigma=0;
        for w=-floor(ws/2):1:floor(ws/2)
            for d=1:size(in,1)/4
                muMan= in((d-1)*4+1:(d-1)*4+4,t);
                sigma = sigma + norm(logmap(in((d-1)*4+1:(d-1)*4+4,t+w),muMan))^2;
            end
        end
        sigma=sigma/ws;
        if sigma>thres
            deb=max(1,t-dec);
            out=in(:,deb:end);
            return
        end
    end
    deb=1;
    out=in;
end

