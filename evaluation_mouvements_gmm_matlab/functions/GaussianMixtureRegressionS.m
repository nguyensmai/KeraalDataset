function [ xhatJ, uhatJ ] = GaussianMixtureRegressionS( model,xIn,nbIter )
%GAUSSIANMIXTUREREGRESSION Summary of this function goes here
%   Detailed explanation goes here

nbData = length(xIn);
names={'lElbow ori','lWrist ori','lShoulder ori','rElbow ori','rWrist ori','rShoulder ori','mSpine ori','mShoulder ori','Neck ori','lElbow rel_pos','lWrist rel_pos','lShoulder rel_pos','rElbow rel_pos','rWrist rel_pos','rShoulder rel_pos'};
in=1; out=2:4; outMan=2:5;
for j=1:9
    [ xhatJ{j}.data,uhatJ{j}.data ] = GMRRiemannian( model,nbData,in,out,outMan,xIn,nbIter);
    out=out+3;outMan=outMan+4;
    xhatJ{j}.name=names{j};uhatJ{j}.name=names{j};
end

in=1; out=2:4; outMan=38:40;
for j=10:15
    mu=[model.MuMan(1,:); model.MuMan(outMan,:)];
    for c=1:model.nbStates
        Sig(1,1,c)=model.Sigma(1,1,c);
        Sig(1,2:4,c)=model.Sigma(1,outMan-9,c);
        Sig(2:4,1,c)=model.Sigma(outMan-9,1,c);
        Sig(2:4,2:4,c)=model.Sigma(outMan-9,14:16,c);
    end
    [xhatJ{j}.data, uhatJ{j}.data] = GMRMax(model.Priors, mu, Sig, xIn(1:nbData), in, out);
    xhatJ{j}.name=names{j};uhatJ{j}.name=names{j};
    outMan=outMan+3;
end


end

