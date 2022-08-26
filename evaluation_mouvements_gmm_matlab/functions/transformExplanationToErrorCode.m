function [ errorCodeSegment ] = transformExplanationToErrorCode( resultSegment )
%TRANSFORMEXPLANATIONTOERRORCODE Summary of this function goes here
%   Detailed explanation goes here

for bp=1:length(resultSegment)
    for s=1:length(resultSegment{1}.results)
        if strcmp(resultSegment{bp}.results(s).type,'OK')==1
            errorCodeSegment{bp}(s)=200;
        else
            if strcmp(resultSegment{bp}.results(s).type,'position')==1
                if strcmp(resultSegment{bp}.results(s).axe,'X')==1
                    if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                        errorCodeSegment{bp}(s)=303;
                    else
                        errorCodeSegment{bp}(s)=302;
                    end
                else
                    if strcmp(resultSegment{bp}.results(s).axe,'Y')==1
                        if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                            errorCodeSegment{bp}(s)=301;
                        else
                            errorCodeSegment{bp}(s)=300;
                        end
                    else
                        if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                            errorCodeSegment{bp}(s)=304;
                        else
                            errorCodeSegment{bp}(s)=305;
                        end
                    end
                end
                    
            else
                if bp==3
                    if strcmp(resultSegment{bp}.results(s).axe,'X')==1
                        if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                            errorCodeSegment{bp}(s)=404;
                        else
                            errorCodeSegment{bp}(s)=405;
                        end
                    else
                        if strcmp(resultSegment{bp}.results(s).axe,'Y')==1
                            if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                                errorCodeSegment{bp}(s)=408;
                            else
                                errorCodeSegment{bp}(s)=409;
                            end
                        else
                            if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                                errorCodeSegment{bp}(s)=402;
                            else
                                errorCodeSegment{bp}(s)=403;
                            end
                        end
                    end
                else
                    if strcmp(resultSegment{bp}.results(s).axe,'X')==1
                        if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                            errorCodeSegment{bp}(s)=401;
                        else
                            errorCodeSegment{bp}(s)=400;
                        end
                    else
                        if strcmp(resultSegment{bp}.results(s).axe,'Y')==1
                            if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                                errorCodeSegment{bp}(s)=407;
                            else
                                errorCodeSegment{bp}(s)=406;
                            end
                        else
                            if strcmp(resultSegment{bp}.results(s).sign,'positive')==1
                                errorCodeSegment{bp}(s)=401;
                            else
                                errorCodeSegment{bp}(s)=400;
                            end
                        end
                    end
                end
            end
        end
    end
end

end

