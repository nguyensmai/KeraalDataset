function [ e ] = quaternionToEuler( q )
%QUATERNIONTOEULER Summary of this function goes here
%   Detailed explanation goes here
    xsqr = q(2)*q(2);
    ysqr = q(3)*q(3);
    zsqr = q(4)*q(4);
    
    t0 = 2*(q(1)*q(2)+q(3)*q(4));
    t1 = 1 - 2*(xsqr+ysqr);
    roll = atan2(t0,t1);
    
    t2 = 2*(q(1)*q(3) - q(4)*q(2));
    if t2>1
        t2=1;
    end
    if t2<(-1)
        t2=(-1);
    end
    pitch=asin(t2);
    
    t3 = 2*(q(1)*q(4) + q(2)*q(3));
    t4 = 1 - 2*(ysqr+zsqr);
    yaw = atan2(t3,t4);
    
    e=[roll pitch yaw];

end

