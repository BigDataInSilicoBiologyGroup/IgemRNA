function compareGeneExpressionLevels(sourceDataSet, targetDataSet, trFilePath)
    
    trSourceData=readtable(trFilePath, 'Sheet', sourceDataSet);
    sourceGeneIds = trSourceData.Geneid;
    sourceExprValues = trSourceData.Data;
    
    trTargetData=readtable(trFilePath, 'Sheet', targetDataSet);
    targetGeneIds = trTargetData.Geneid;
    targetExprValues = trTargetData.Data;
    
    result = cell(height(targetGeneIds), 4);
    result(1,1) = cellstr('GeneId');
    result(1,2) = cellstr(strcat(targetDataSet,'_ExpressionValue(target)'));
    result(1,3) = cellstr(strcat(sourceDataSet,'_ExpressionValue(source)'));
    result(1,4) = cellstr('Up/Down regulated');
    
    for i=1:1:height(targetGeneIds)
        for j=1:1:height(sourceGeneIds)
            if string(sourceGeneIds(j))==string(targetGeneIds(i)) % find corresponding gene
                result(i+1,1) = targetGeneIds(i);
                result(i+1,2) = num2cell(targetExprValues(i));
                result(i+1,3) = num2cell(sourceExprValues(j));
                % compare expression values
                if targetExprValues(i) < sourceExprValues(j)
                    result(i+1,4) = cellstr('down');
                elseif targetExprValues(i) > sourceExprValues(j)
                    result(i+1,4) = cellstr('up');
                else
                    result(i+1,4) = cellstr('equal');
                end
                break
            end
        end
    end
    resultFileName = strcat('..\Results non-optimization\Gene expression level comparison\',targetDataSet,'_compared_to_', sourceDataSet,'.xls');
    writecell(result,resultFileName);
end