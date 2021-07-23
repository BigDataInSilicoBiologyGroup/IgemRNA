function [model, genesBelowLocalThreholds, localThresholds] = applyLocalThresholds(model, transciptomicsData, globalLowerThreshold, globalUpperThreshod)
    disp('Hello');
    
    geneExpressionIntervals = cell(length(transciptomicsData{1},3)); % GeneId, array with expression values, Mean
    for i=1:1:length(transciptomicsData)
        sampleData = transciptomicsData{i};
        
    end
    
    
    if isempty(globalUpperThreshod)%apply local thresholds to all genes with expression level global lower threshold
        for i=1:1:length(transciptomicsData)
            for j=1:1:length(transciptomicsData{i})
                trDataSample = transciptomicsData{i};
                if trDataSample{2,j} > globalLowerThreshold
                    trDataAllGeneSamples = cell(1, length(transciptomicsData));
                    
                    
                end
            end
        end
        

    else %apply local thresholds to genes with expression level between upper and lower global thesholds
        for i=1:1:length(transciptomicsData)
            for j=1:1:length(transciptomicsData{i})
                trDataSample = transciptomicsData{i};
                if  (globalUpperThreshod > trDataSample{2,j}) && (trDataSample{2,j} > globalLowerThreshold)
                    %apply local th
                end
            end
        end
    end
end