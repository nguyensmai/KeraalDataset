function [ resultSegment, resultSegmentKP ] = explainErrors( Sbodypart, Sjoints, Ljoints, dataTrain, dataTest, seuilP )
%EXPLAINERRORS Summary of this function goes here
%   Explain Errors in detail for each body parts if they are dected (below
%   seuilP %) and for each temporal segment
%   Ljoints is likelihoods for bodyparts and joints
%   Sbodypart, Sjoints are scores (in %) for bodyparts and joints
%   seuilP corresponds to the threshold used to detect errors (in %)
%   resultSegment is the structure of detected errors for each segment
%   resultSegmentKP is the structure of detected errors for each segmentKP

for b=1:length(Sbodypart)
    resultSegment{b}.name=Sbodypart{b}.name;
    for s=1:length(Sbodypart{b}.global.perSegment)
        if Sbodypart{b}.global.perSegment(s)<seuilP
            scores=[];
            for j=1:3
                if b<=2
                    scores=[scores Sjoints{(b-1)*3+j}.orientation.perSegment(s) Sjoints{(b-1)*3+j}.position.perSegment(s)];
                else
                    scores=[scores Sjoints{(b-1)*3+j}.global.perSegment(s)];
                end
            end
            [mini,ind] = min(scores);
            resultSegment{b}.results(s).score=mini;
            if b<=2
                switch ind
                    case 1
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+1}.name);
                        resultSegment{b}.results(s).type='orientation';
                    case 2
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+1}.name);
                        resultSegment{b}.results(s).type='position';
                        [axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+1}.position.segments{s},dataTrain{(b-1)*3+10}.segments{s},dataTest{(b-1)*3+10}.segments{s});
                        resultSegment{b}.results(s).axe=axe;
                        resultSegment{b}.results(s).sign=sign;
                    case 3
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+2}.name);
                        resultSegment{b}.results(s).type='orientation';
                    case 4
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+2}.name);
                        resultSegment{b}.results(s).type='position';
                        [axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+2}.position.segments{s},dataTrain{(b-1)*3+11}.segments{s},dataTest{(b-1)*3+11}.segments{s});
                        resultSegment{b}.results(s).axe=axe;
                        resultSegment{b}.results(s).sign=sign;
                    case 5
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+3}.name);
                        resultSegment{b}.results(s).type='orientation';
                    case 6
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+3}.name);
                        resultSegment{b}.results(s).type='position';
                        [axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+3}.position.segments{s},dataTrain{(b-1)*3+12}.segments{s},dataTest{(b-1)*3+12}.segments{s});
                        resultSegment{b}.results(s).axe=axe;
                        resultSegment{b}.results(s).sign=sign;
                end
            else
                switch ind
                    case 1
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+1}.name);
                        resultSegment{b}.results(s).type='orientation';
                        %[axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+1}.global.data,dataTrain{(b-1)*3+1}.data,dataTest{(b-1)*3+1}.data);
                        %resultSegment{b}(s).explanation.axe=axe;
                        %resultSegment{b}(s).explanation.sign=sign;
                    case 2
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+2}.name);
                        resultSegment{b}.results(s).type='orientation';
                        %[axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+2}.global.data,dataTrain{(b-1)*3+2}.data,dataTest{(b-1)*3+2}.data);
                        %resultSegment{b}(s).explanation.axe=axe;
                        %resultSegment{b}(s).explanation.sign=sign;
                    case 3
                        resultSegment{b}.results(s).joint=sprintf('%s',Sjoints{(b-1)*3+3}.name);
                        resultSegment{b}.results(s).type='orientation';
                        %[axe,sign] = explainErrorPosition(Ljoints{(b-1)*3+3}.global.data,dataTrain{(b-1)*3+3}.data,dataTest{(b-1)*3+3}.data);
                        %resultSegment{b}(s).explanation.axe=axe;
                        %resultSegment{b}(s).explanation.sign=sign;
                end
            end
        else
            resultSegment{b}.results(s).score=Sbodypart{b}.global.perSegment(s);
            resultSegment{b}.results(s).type='OK';
        end
    end
end
resultSegmentKP=0;

end

