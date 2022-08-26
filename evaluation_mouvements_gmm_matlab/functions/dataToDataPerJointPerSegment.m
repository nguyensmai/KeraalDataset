function [ dataOut ] = dataToDataPerJointPerSegment( model, data )
%DATATODATAPERJOINTPERSEGMENT Summary of this function goes here
%   transform data struct to data structure per joint and per segment

for i=1:length(data)
    dataOut{i}.name=data{i}.name;
    if isfield(data{i},'data')
        dataOut{i}.segments{1}=data{i}.data(:,1:model.cuts(1));
        for c=1:length(model.cuts)-1
            dataOut{i}.segments{c+1}=data{i}.data(:,model.cuts(c)+1:model.cuts(c+1));
        end
        dataOut{i}.segments{c+2}=data{i}.data(:,model.cuts(c+1)+1:end);
        dataOut{i}.segmentsKP{1}=data{i}.data(:,1:model.cutsKP(1));
        for c=1:length(model.cutsKP)-1
            dataOut{i}.segmentsKP{c+1}=data{i}.data(:,model.cutsKP(c)+1:model.cutsKP(c+1));
        end
        dataOut{i}.segmentsKP{c+2}=data{i}.data(:,model.cutsKP(c+1)+1:end);
    end
    if isfield(data{i},'global')
        dataOut{i}.global.segments{1}=data{i}.global.data(:,1:model.cuts(1));
        for c=1:length(model.cuts)-1
            dataOut{i}.global.segments{c+1}=data{i}.global.data(:,model.cuts(c)+1:model.cuts(c+1));
        end
        dataOut{i}.global.segments{c+2}=data{i}.global.data(:,model.cuts(c+1)+1:end);
        dataOut{i}.global.segmentsKP{1}=data{i}.global.data(:,1:model.cutsKP(1));
        for c=1:length(model.cutsKP)-1
            dataOut{i}.global.segmentsKP{c+1}=data{i}.global.data(:,model.cutsKP(c)+1:model.cutsKP(c+1));
        end
        dataOut{i}.global.segmentsKP{c+2}=data{i}.global.data(:,model.cutsKP(c+1)+1:end);
    end
    if isfield(data{i},'orientation')
        dataOut{i}.orientation.segments{1}=data{i}.orientation.data(:,1:model.cuts(1));
        for c=1:length(model.cuts)-1
            dataOut{i}.orientation.segments{c+1}=data{i}.orientation.data(:,model.cuts(c)+1:model.cuts(c+1));
        end
        dataOut{i}.orientation.segments{c+2}=data{i}.orientation.data(:,model.cuts(c+1)+1:end);
        dataOut{i}.orientation.segmentsKP{1}=data{i}.orientation.data(:,1:model.cutsKP(1));
        for c=1:length(model.cutsKP)-1
            dataOut{i}.orientation.segmentsKP{c+1}=data{i}.orientation.data(:,model.cutsKP(c)+1:model.cutsKP(c+1));
        end
        dataOut{i}.orientation.segmentsKP{c+2}=data{i}.orientation.data(:,model.cutsKP(c+1)+1:end);
    end
    if isfield(data{i},'position')
        dataOut{i}.position.segments{1}=data{i}.position.data(:,1:model.cuts(1));
        for c=1:length(model.cuts)-1
            dataOut{i}.position.segments{c+1}=data{i}.position.data(:,model.cuts(c)+1:model.cuts(c+1));
        end
        dataOut{i}.position.segments{c+2}=data{i}.position.data(:,model.cuts(c+1)+1:end);
        dataOut{i}.position.segmentsKP{1}=data{i}.position.data(:,1:model.cutsKP(1));
        for c=1:length(model.cutsKP)-1
            dataOut{i}.position.segmentsKP{c+1}=data{i}.position.data(:,model.cutsKP(c)+1:model.cutsKP(c+1));
        end
        dataOut{i}.position.segmentsKP{c+2}=data{i}.position.data(:,model.cutsKP(c+1)+1:end);
    end
end

end

