function [ Lglobal, Lbodypart, Ljoints ] = computeLikelihoods( model, dataTest )
%COMPUTELIKELIHOODS Summary of this function goes here
%   Compute all likelihoods global and locals
%   return Lglobal structure (Lglobal, Lori, Lpos)
%   return Lbodypart likelihood per body parts (global, pos, ori)
%   return Ljoints likelihood per joints (global, pos, ori per joints, same size as dataTest)

xIn = [1:size(dataTest{1}.data,2)]*model.dt;

% Global (orientation + position)
for i=1:model.nbStates
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{1}.data, model.MuMan(2:5,i)); logmap(dataTest{2}.data, model.MuMan(6:9,i)); logmap(dataTest{3}.data, model.MuMan(10:13,i)); logmap(dataTest{4}.data, model.MuMan(14:17,i)); logmap(dataTest{5}.data, model.MuMan(18:21,i)); logmap(dataTest{6}.data, model.MuMan(22:25,i)); logmap(dataTest{7}.data, model.MuMan(26:29,i)); logmap(dataTest{8}.data, model.MuMan(30:33,i)); logmap(dataTest{9}.data, model.MuMan(34:37,i)); dataTest{10}.data-model.MuMan(38:40,i);dataTest{11}.data-model.MuMan(41:43,i);dataTest{12}.data-model.MuMan(44:46,i);dataTest{13}.data-model.MuMan(47:49,i);dataTest{14}.data-model.MuMan(50:52,i);dataTest{15}.data-model.MuMan(53:55,i)], model.Mu(:,i), model.Sigma(:,:,i));
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lglobal{1}.data=LL;Lglobal{1}.score=score;Lglobal{1}.name='Global';

% Orientations
in=1; out=2:28;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{1}.data, model.MuMan(2:5,i)); logmap(dataTest{2}.data, model.MuMan(6:9,i)); logmap(dataTest{3}.data, model.MuMan(10:13,i)); logmap(dataTest{4}.data, model.MuMan(14:17,i)); logmap(dataTest{5}.data, model.MuMan(18:21,i)); logmap(dataTest{6}.data, model.MuMan(22:25,i)); logmap(dataTest{7}.data, model.MuMan(26:29,i)); logmap(dataTest{8}.data, model.MuMan(30:33,i)); logmap(dataTest{9}.data, model.MuMan(34:37,i))], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lglobal{2}.data=LL;Lglobal{2}.score=score;Lglobal{2}.name='Orientations';

% Positions
clear sigma mu L LL
in=1; out=29:46;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); dataTest{10}.data-model.MuMan(38:40,i);dataTest{11}.data-model.MuMan(41:43,i);dataTest{12}.data-model.MuMan(44:46,i);dataTest{13}.data-model.MuMan(47:49,i);dataTest{14}.data-model.MuMan(50:52,i);dataTest{15}.data-model.MuMan(53:55,i)], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lglobal{3}.data=LL;Lglobal{3}.score=score;Lglobal{3}.name='Positions';

% Left Arm Global
Lbodypart{1}.name='Left Arm';
clear sigma mu L LL
in=1; outO=2:10; outP=29:37;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(outO,i)' model.Mu(outP,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(outO)+1)=model.Sigma(in,outO,i);
    sigma(1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(in,outP,i);
    sigma(2:length(outO)+1,1)=model.Sigma(outO,in,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,1)=model.Sigma(outP,in,i);
    sigma(2:length(outO)+1,2:length(outO)+1)=model.Sigma(outO,outO,i);
    sigma(2:length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outO,outP,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,2:length(outO)+1)=model.Sigma(outP,outO,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outP,outP,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{1}.data, model.MuMan(2:5,i)); logmap(dataTest{2}.data, model.MuMan(6:9,i)); logmap(dataTest{3}.data, model.MuMan(10:13,i)); dataTest{10}.data-model.MuMan(38:40,i);dataTest{11}.data-model.MuMan(41:43,i);dataTest{12}.data-model.MuMan(44:46,i)], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{1}.global.data=LL;Lbodypart{1}.global.score=score;Lbodypart{1}.global.name='Left Arm Global';

% Left Arm Orientation
clear sigma mu L LL
in=1; out=2:10;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{1}.data, model.MuMan(2:5,i)); logmap(dataTest{2}.data, model.MuMan(6:9,i)); logmap(dataTest{3}.data, model.MuMan(10:13,i))], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{1}.orientation.data=LL;Lbodypart{1}.orientation.score=score;Lbodypart{1}.orientation.name='Left Arm Orientation';

% Left Arm Postion
clear sigma mu L LL
in=1; out=29:37;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); dataTest{10}.data-model.MuMan(38:40,i);dataTest{11}.data-model.MuMan(41:43,i);dataTest{12}.data-model.MuMan(44:46,i)], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{1}.position.data=LL;Lbodypart{1}.position.score=score;Lbodypart{1}.position.name='Left Arm Position';


% Right Arm Global
Lbodypart{2}.name='Right Arm';
clear sigma mu L LL
in=1; outO=11:19; outP=38:46;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(outO,i)' model.Mu(outP,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(outO)+1)=model.Sigma(in,outO,i);
    sigma(1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(in,outP,i);
    sigma(2:length(outO)+1,1)=model.Sigma(outO,in,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,1)=model.Sigma(outP,in,i);
    sigma(2:length(outO)+1,2:length(outO)+1)=model.Sigma(outO,outO,i);
    sigma(2:length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outO,outP,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,2:length(outO)+1)=model.Sigma(outP,outO,i);
    sigma(length(outO)+2:length(outP)+length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outP,outP,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{4}.data, model.MuMan(14:17,i)); logmap(dataTest{5}.data, model.MuMan(18:21,i)); logmap(dataTest{6}.data, model.MuMan(22:25,i)); dataTest{13}.data-model.MuMan(47:49,i);dataTest{14}.data-model.MuMan(50:52,i);dataTest{15}.data-model.MuMan(53:55,i)], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{2}.global.data=LL;Lbodypart{2}.global.score=score;Lbodypart{2}.global.name='Right Arm Global';

% Right Arm Orientation
clear sigma mu L LL
in=1; out=11:19;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{4}.data, model.MuMan(14:17,i)); logmap(dataTest{5}.data, model.MuMan(18:21,i)); logmap(dataTest{6}.data, model.MuMan(22:25,i))], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{2}.orientation.data=LL;Lbodypart{2}.orientation.score=score;Lbodypart{2}.orientation.name='Right Arm Orientation';

% Right Arm Position
clear sigma mu L LL
in=1; out=38:46;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); dataTest{13}.data-model.MuMan(47:49,i);dataTest{14}.data-model.MuMan(50:52,i);dataTest{15}.data-model.MuMan(53:55,i)], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{2}.position.data=LL;Lbodypart{2}.position.score=score;Lbodypart{2}.position.name='Right Arm Position';

% Colonne Global (only position)
Lbodypart{3}.name='Colonne';
clear sigma mu L LL
in=1; out=20:28;
for i=1:model.nbStates
    mu=[model.Mu(in,i)' model.Mu(out,i)']';
    sigma(1,1)= model.Sigma(in, in,i);
    sigma(1,2:length(out)+1)=model.Sigma(in,out,i);
    sigma(2:length(out)+1,1)=model.Sigma(out,in,i);
    sigma(2:length(out)+1,2:length(out)+1)=model.Sigma(out,out,i);
    L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{7}.data, model.MuMan(26:29,i)); logmap(dataTest{8}.data, model.MuMan(30:33,i)); logmap(dataTest{9}.data, model.MuMan(34:37,i))], mu, sigma);
end
LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
Lbodypart{3}.global.data=LL;Lbodypart{3}.global.score=score;Lbodypart{3}.global.name='Colonne Global';

% Per Joints
jointNames={'lElbow','lWrist','lShoulder','rElbow','rWrist','rShoulder','mSpine','mShoulder','Neck'};
in=1; outO=2:4; outP=29:31; outMO=2:5; outMP=38:40;
for j=1:length(jointNames)
    Ljoints{j}.name=jointNames{j};
    % Global
    if j<=6
        clear sigma mu L LL
        for i=1:model.nbStates
            mu=[model.Mu(in,i)' model.Mu(outO,i)' model.Mu(outP,i)']';
            sigma(1,1)= model.Sigma(in, in,i);
            sigma(1,2:length(outO)+1)=model.Sigma(in,outO,i);
            sigma(1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(in,outP,i);
            sigma(2:length(outO)+1,1)=model.Sigma(outO,in,i);
            sigma(length(outO)+2:length(outP)+length(outO)+1,1)=model.Sigma(outP,in,i);
            sigma(2:length(outO)+1,2:length(outO)+1)=model.Sigma(outO,outO,i);
            sigma(2:length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outO,outP,i);
            sigma(length(outO)+2:length(outP)+length(outO)+1,2:length(outO)+1)=model.Sigma(outP,outO,i);
            sigma(length(outO)+2:length(outP)+length(outO)+1,length(outO)+2:length(outP)+length(outO)+1)=model.Sigma(outP,outP,i);
            L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{j}.data, model.MuMan(outMO,i)); dataTest{j+9}.data-model.MuMan(outMP,i)], mu, sigma);
        end
        LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
        Ljoints{j}.global.data=LL;Ljoints{j}.global.score=score;Ljoints{j}.global.name=sprintf('%s Global',jointNames{j});
    end
    % Orientations
    clear sigma mu L LL
    for i=1:model.nbStates
        mu=[model.Mu(in,i)' model.Mu(outO,i)']';
        sigma(1,1)= model.Sigma(in, in,i);
        sigma(1,2:length(outO)+1)=model.Sigma(in,outO,i);
        sigma(2:length(outO)+1,1)=model.Sigma(outO,in,i);
        sigma(2:length(outO)+1,2:length(outO)+1)=model.Sigma(outO,outO,i);
        L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); logmap(dataTest{j}.data, model.MuMan(outMO,i))], mu, sigma);
    end
    LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
    if j<=6
        Ljoints{j}.orientation.data=LL;Ljoints{j}.orientation.score=score;Ljoints{j}.orientation.name=sprintf('%s Orientation',jointNames{j});
    else
        Ljoints{j}.global.data=LL;Ljoints{j}.global.score=score;Ljoints{j}.global.name=sprintf('%s Global',jointNames{j});
    end
    if j<=6
        % Positions
        clear sigma mu L LL
        for i=1:model.nbStates
            mu=[model.Mu(in,i)' model.Mu(outP,i)']';
            sigma(1,1)= model.Sigma(in, in,i);
            sigma(1,2:length(outP)+1)=model.Sigma(in,outP,i);
            sigma(2:length(outP)+1,1)=model.Sigma(outP,in,i);
            sigma(2:length(outP)+1,2:length(outP)+1)=model.Sigma(outP,outP,i);
            L(i,:) = model.Priors(i) * gaussPDF([xIn-model.MuMan(1,i); dataTest{j+9}.data-model.MuMan(outMP,i)], mu, sigma);
        end
        LL=log(sum(L));LL(LL<-2000)=-2000;score=mean(LL);
        Ljoints{j}.position.data=LL;Ljoints{j}.position.score=score;Ljoints{j}.position.name=sprintf('%s Position',jointNames{j});
    end
    % increment
    outO=outO+3; outP=outP+3; outMO=outMO+4; outMP=outMP+3;
end

end
