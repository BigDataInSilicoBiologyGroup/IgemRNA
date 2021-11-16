function value = findTranscriptionValue(geneId, trData)
    geneIds = trData.Geneid;
    expressionValues = trData.Data;
    for k=1:1:length(geneIds)
       if strcmp(geneId, geneIds(k))
           value = expressionValues(k);
       end
   end
end