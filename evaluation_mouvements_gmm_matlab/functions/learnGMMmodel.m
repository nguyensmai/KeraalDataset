function [ model ] = learnGMMmodel( model,u,xIn,xOut,nbSamples,nbIterEM,nbIter,nbData )
%LEARNGMMMODEL Summary of this function goes here
%   Detailed explanation goes here
model = init_GMM_kbins(u, model, nbSamples);
model.MuMan = [model.Mu(1,:); expmap(model.Mu(2:4,:), [0; 1; 0; 0]); expmap(model.Mu(5:7,:), [0; 1; 0; 0]);expmap(model.Mu(8:10,:), [0; 1; 0; 0]);expmap(model.Mu(11:13,:), [0; 1; 0; 0]);expmap(model.Mu(14:16,:), [0; 1; 0; 0]);expmap(model.Mu(17:19,:), [0; 1; 0; 0]);expmap(model.Mu(20:22,:), [0; 1; 0; 0]);expmap(model.Mu(23:25,:), [0; 1; 0; 0]);expmap(model.Mu(26:28,:), [0; 1; 0; 0]);model.Mu(29:31,:);model.Mu(32:34,:);model.Mu(35:37,:);model.Mu(38:40,:);model.Mu(41:43,:);model.Mu(44:46,:)]; %Center on the manifold
model.Mu = zeros(model.nbVar,model.nbStates); %Center in the tangent plane at point MuMan of the manifold

x=model.x;
uTmp = zeros(model.nbVar,nbData*nbSamples,model.nbStates);
avg_loglik=[];
for nb=1:nbIterEM
	%E-step
	L = zeros(model.nbStates,size(x,2));
	for i=1:model.nbStates
        L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(xOut{1}.data, model.MuMan(2:5,i)); logmap(xOut{2}.data, model.MuMan(6:9,i)); logmap(xOut{3}.data, model.MuMan(10:13,i)); logmap(xOut{4}.data, model.MuMan(14:17,i)); logmap(xOut{5}.data, model.MuMan(18:21,i)); logmap(xOut{6}.data, model.MuMan(22:25,i)); logmap(xOut{7}.data, model.MuMan(26:29,i)); logmap(xOut{8}.data, model.MuMan(30:33,i)); logmap(xOut{9}.data, model.MuMan(34:37,i)); xOut{10}.data-model.MuMan(38:40,i);xOut{11}.data-model.MuMan(41:43,i);xOut{12}.data-model.MuMan(44:46,i);xOut{13}.data-model.MuMan(47:49,i);xOut{14}.data-model.MuMan(50:52,i);xOut{15}.data-model.MuMan(53:55,i)], model.Mu(:,i), model.Sigma(:,:,i));
    end
    GAMMA = L ./ repmat(sum(L,1)+realmin, model.nbStates, 1);
	GAMMA2 = GAMMA ./ repmat(sum(GAMMA,2),1,nbData*nbSamples);
    GAMMA2(isnan(GAMMA2))=0;% Ajout Max
    avg_loglik=[avg_loglik (-log(mean(sum(L))))];
	%M-step
	for i=1:model.nbStates
		%Update Priors
		model.Priors(i) = sum(GAMMA(i,:)) / (nbData*nbSamples);
		%Update MuMan
		for n=1:nbIter
            uTmp(:,:,i) = [xIn-model.MuMan(1,i); logmap(xOut{1}.data, model.MuMan(2:5,i)); logmap(xOut{2}.data, model.MuMan(6:9,i)); logmap(xOut{3}.data, model.MuMan(10:13,i)); logmap(xOut{4}.data, model.MuMan(14:17,i)); logmap(xOut{5}.data, model.MuMan(18:21,i)); logmap(xOut{6}.data, model.MuMan(22:25,i)); logmap(xOut{7}.data, model.MuMan(26:29,i)); logmap(xOut{8}.data, model.MuMan(30:33,i)); logmap(xOut{9}.data, model.MuMan(34:37,i)); xOut{10}.data-model.MuMan(38:40,i); xOut{11}.data-model.MuMan(41:43,i); xOut{12}.data-model.MuMan(44:46,i); xOut{13}.data-model.MuMan(47:49,i); xOut{14}.data-model.MuMan(50:52,i); xOut{15}.data-model.MuMan(53:55,i)];
			model.MuMan(:,i) = [(model.MuMan(1,i)+uTmp(1,:,i))*GAMMA2(i,:)'; expmap(uTmp(2:4,:,i)*GAMMA2(i,:)', model.MuMan(2:5,i)); expmap(uTmp(5:7,:,i)*GAMMA2(i,:)', model.MuMan(6:9,i)); expmap(uTmp(8:10,:,i)*GAMMA2(i,:)', model.MuMan(10:13,i)); expmap(uTmp(11:13,:,i)*GAMMA2(i,:)', model.MuMan(14:17,i));expmap(uTmp(14:16,:,i)*GAMMA2(i,:)', model.MuMan(18:21,i));expmap(uTmp(17:19,:,i)*GAMMA2(i,:)', model.MuMan(22:25,i));expmap(uTmp(20:22,:,i)*GAMMA2(i,:)', model.MuMan(26:29,i));expmap(uTmp(23:25,:,i)*GAMMA2(i,:)', model.MuMan(30:33,i));expmap(uTmp(26:28,:,i)*GAMMA2(i,:)', model.MuMan(34:37,i));(model.MuMan(38:40,i)+uTmp(29:31,:,i))*GAMMA2(i,:)';(model.MuMan(41:43,i)+uTmp(32:34,:,i))*GAMMA2(i,:)';(model.MuMan(44:46,i)+uTmp(35:37,:,i))*GAMMA2(i,:)';(model.MuMan(47:49,i)+uTmp(38:40,:,i))*GAMMA2(i,:)';(model.MuMan(50:52,i)+uTmp(41:43,:,i))*GAMMA2(i,:)';(model.MuMan(53:55,i)+uTmp(44:46,:,i))*GAMMA2(i,:)'];
        end
		%Update Sigma
		model.Sigma(:,:,i) = uTmp(:,:,i) * diag(GAMMA2(i,:)) * uTmp(:,:,i)' + eye(size(u,1)) * model.params_diagRegFact;
	end
end
%Eigendecomposition of Sigma
for i=1:model.nbStates
	[V,D] = eig(model.Sigma(:,:,i));
	U0(:,:,i) = V * D.^.5;
end
model.U0=U0;
end

