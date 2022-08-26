function model = init_tensorGMM_timeBased(Data, model)
% Initialization of TP-GMM with equal bins splitting.
%
% Writing code takes time. Polishing it and making it available to others takes longer! 
% If some parts of the code were useful for your research of for a better understanding 
% of the algorithms, please reward the authors by citing the related publications, 
% and consider making your own research available in this way.
%
% @article{Calinon15,
%   author="Calinon, S.",
%   title="A Tutorial on Task-Parameterized Movement Learning and Retrieval",
%   journal="Intelligent Service Robotics",
%   year="2015"
% }
%
% Copyright (c) 2015 Idiap Research Institute, http://idiap.ch/
% Written by Sylvain Calinon, http://calinon.ch/
% 
% This file is part of PbDlib, http://www.idiap.ch/software/pbdlib/
% 
% PbDlib is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 3 as
% published by the Free Software Foundation.
% 
% PbDlib is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with PbDlib. If not, see <http://www.gnu.org/licenses/>.


diagRegularizationFactor = 1E-4; %Optional regularization term

DataAll = reshape(Data, size(Data,1)*size(Data,2), size(Data,3)); %Matricization/flattening of tensor

TimingSep = linspace(min(DataAll(1,:)), max(DataAll(1,:)), model.nbStates+1);
Mu = zeros(model.nbFrames*model.nbVar, model.nbStates);
Sigma = zeros(model.nbFrames*model.nbVar, model.nbFrames*model.nbVar, model.nbStates);
for i=1:model.nbStates
	idtmp = find( DataAll(1,:)>=TimingSep(i) & DataAll(1,:)<TimingSep(i+1));
	Mu(:,i) = mean(DataAll(:,idtmp),2);
	Sigma(:,:,i) = cov(DataAll(:,idtmp)') + eye(size(DataAll,1))*diagRegularizationFactor;
	model.Priors(i) = length(idtmp);
end
model.Priors = model.Priors / sum(model.Priors);

%Reshape GMM parameters into a tensor
for m=1:model.nbFrames
	for i=1:model.nbStates
		model.Mu(:,m,i) = Mu((m-1)*model.nbVar+1:m*model.nbVar,i);
		model.Sigma(:,:,m,i) = Sigma((m-1)*model.nbVar+1:m*model.nbVar,(m-1)*model.nbVar+1:m*model.nbVar,i);
	end
end
