function genes = findGenesBelowThreshold(threshold, geneNames, expressionValues)
    cnt = 1;
    for i=1:1:length(geneNames)
        if threshold > expressionValues(i)
            genes{cnt,1} = geneNames{i};
            genes{cnt,2} = expressionValues(i);
            cnt = cnt + 1;
        end
    end
end