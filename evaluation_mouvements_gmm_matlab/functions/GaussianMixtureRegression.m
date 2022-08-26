function [ xhat, uhat, xhatJ, uhatJ ] = GaussianMixtureRegression( model,in,out,outMan,xIn,nbIter )
%GAUSSIANMIXTUREREGRESSION Summary of this function goes here
%   Detailed explanation goes here

nbData = length(xIn);
nbVarOut = length(out);
nbVarOutMan = length(outMan);

uhat = zeros(nbVarOut,nbData);
xhat = zeros(nbVarOutMan,nbData);
uOutTmp = zeros(nbVarOut,model.nbStates,nbData);
SigmaTmp = zeros(model.nbVar,model.nbVar,model.nbStates);
expSigma = zeros(nbVarOut,nbVarOut,nbData);
U0=model.U0;

%Version with single optimization loop
for t=1:nbData
	%Compute activation weight
	for i=1:model.nbStates
		H(i,t) = model.Priors(i) * gaussPDF(xIn(:,t)-model.MuMan(in,i), model.Mu(in,i), model.Sigma(in,in,i));
	end
	H(:,t) = H(:,t) / sum(H(:,t)+realmin);
	
	%Compute conditional mean (with covariance transportation)
	if t==1
		[~,id] = max(H(:,t));
		xhat(:,t) = model.MuMan(outMan,id); %Initial point
	else
		xhat(:,t) = xhat(:,t-1);
	end
	for n=1:nbIter
		for i=1:model.nbStates
			%Transportation of covariance from model.MuMan(outMan,i) to xhat(:,t) 
			Ac = [transp(model.MuMan(2:5,i), xhat(1:4,t));transp(model.MuMan(6:9,i), xhat(5:8,t));transp(model.MuMan(10:13,i), xhat(9:12,t));transp(model.MuMan(14:17,i), xhat(13:16,t));transp(model.MuMan(18:21,i), xhat(17:20,t));transp(model.MuMan(22:25,i), xhat(21:24,t));transp(model.MuMan(26:29,i), xhat(25:28,t));transp(model.MuMan(30:33,i), xhat(29:32,t));transp(model.MuMan(34:37,i), xhat(33:36,t));eye(3);eye(3);eye(3);eye(3);eye(3);eye(3)]';
			U = (blkdiag(1, Ac) * U0(:,:,i)); %First variable in Euclidean space
			SigmaTmp(:,:,i) = U' * U;
			%Gaussian conditioning on the tangent space
			uOutTmp(:,i,t) = [logmap(model.MuMan(2:5,i), xhat(1:4,t));logmap(model.MuMan(6:9,i), xhat(5:8,t));logmap(model.MuMan(10:13,i), xhat(9:12,t));logmap(model.MuMan(14:17,i), xhat(13:16,t));logmap(model.MuMan(18:21,i), xhat(17:20,t));logmap(model.MuMan(22:25,i), xhat(21:24,t));logmap(model.MuMan(26:29,i), xhat(25:28,t));logmap(model.MuMan(30:33,i), xhat(29:32,t));logmap(model.MuMan(34:37,i), xhat(33:36,t));model.MuMan(38:40,i)-xhat(37:39,t);model.MuMan(41:43,i)-xhat(40:42,t);model.MuMan(44:46,i)-xhat(43:45,t);model.MuMan(47:49,i)-xhat(46:48,t);model.MuMan(50:52,i)-xhat(49:51,t);model.MuMan(53:55,i)-xhat(52:54,t)] + SigmaTmp(out,in,i)/SigmaTmp(in,in,i) * (xIn(:,t)-model.MuMan(in,i)); 
		end
		uhat(:,t) = uOutTmp(:,:,t) * H(:,t);
		xhat(:,t) = [expmap(uhat(1:3,t), xhat(1:4,t));expmap(uhat(4:6,t), xhat(5:8,t));expmap(uhat(7:9,t), xhat(9:12,t));expmap(uhat(10:12,t), xhat(13:16,t));expmap(uhat(13:15,t), xhat(17:20,t));expmap(uhat(16:18,t), xhat(21:24,t));expmap(uhat(19:21,t), xhat(25:28,t));expmap(uhat(22:24,t), xhat(29:32,t));expmap(uhat(25:27,t), xhat(33:36,t));uhat(28:30,t)+xhat(37:39,t);uhat(31:33,t)+xhat(40:42,t);uhat(34:36,t)+xhat(43:45,t);uhat(37:39,t)+xhat(46:48,t);uhat(40:42,t)+xhat(49:51,t);uhat(43:45,t)+xhat(52:54,t)];
    end
	
    
	%Compute conditional covariances
    % Pas utile pour GMR
	%for i=1:model.nbStates
	%	expSigma(:,:,t) = expSigma(:,:,t) + H(i,t) * (SigmaTmp(out,out,i) - SigmaTmp(out,in,i)/SigmaTmp(in,in,i) * SigmaTmp(in,out,i));
	%end
end



names={'lElbow ori','lWrist ori','lShoulder ori','rElbow ori','rWrist ori','rShoulder ori','mSpine ori','mShoulder ori','Neck ori','lElbow rel_pos','lWrist rel_pos','lShoulder rel_pos','rElbow rel_pos','rWrist rel_pos','rShoulder rel_pos'};
for j=1:15
    xhatJ{j}.name=names{j};
    uhatJ{j}.name=names{j};
end

end

