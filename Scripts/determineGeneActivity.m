function determineGeneActivity(thApproach, glower, gupper, trFilePath)
    [status, sheets, format] = xlsfinfo(trFilePath);

    
    for i=1:1:length(sheets)
        trTargetData=readtable(trFilePath,'Sheet',sheets{i});
        geneIds = trTargetData.Geneid;
        expressionValues = trTargetData.Data;
        result = cell(height(geneIds),4);
        sheetNameParts = split(sheets(i),"_");
        phenotypeName = sheetNameParts(2);
        resultFileName = strcat('..\Results non-optimization\Highly-lowly expressed genes\',sheets(i));
        
        switch thApproach
            case 1 % GT1 - one dataset
                 disp('GT1');
            case 2 % LT1 - multiple datasets
                resultFileName = strcat(resultFileName,'_LT1_',string(glower),'_',string(gupper),'.xls');
                
                allSheets = [];
                cnt = 1;
                allExpressionValues = [];
                
                for k=1:1:length(sheets)
                    if contains(sheets{k},phenotypeName)
                        allSheets{cnt} = sheets{k};
                        trData=readtable(trFilePath,'Sheet',sheets{k});
                        allExpressionValues(:,cnt)=trData.Data;
                        cnt = cnt +1;
                    end
                end
                
                for j=1:1:height(geneIds)
                    minVal = min(allExpressionValues(j,:));
                    maxVal = max(allExpressionValues(j,:));
                    expressionState = '';
                    localThApplied = 0;
                    if minVal < glower && maxVal < glower
                        expressionState = 'low';
                    elseif minVal <= glower && maxVal >= glower
                        %calculate mean
                        mean = sum(allExpressionValues(j,:))/length(allExpressionValues(j,:));
                        if expressionValues(j) >= mean
                            expressionState = 'high';
                        else 
                            expressionState = 'low';
                        end
                        localThApplied = 1;
                    elseif  minVal > glower
                        expressionState = 'high';
                    end
                    result(j,1) = geneIds(j);
                    result(j,2) = num2cell(expressionValues(j));
                    result(j,3) = cellstr(expressionState);
                    result(j,4) = num2cell(localThApplied);
                end
                writecell(result,resultFileName);
            case 3 % LT2 - miltiple datasets    
                disp('LT2');
        end
    end
end