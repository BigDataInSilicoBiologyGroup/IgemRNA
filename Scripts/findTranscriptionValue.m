function value = findTranscriptionValue(geneId, trData)
    geneIds = trData.Geneid;
    expressionValues = trData.Data;
    index = find(strcmp(trData.Geneid, geneId));
    value = expressionValues(index);
end