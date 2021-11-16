threshold=6;
trDataPath = 'Data/TranscriptomicsData.xlsx';
trData=readtable(trDataPath,'Sheet','SRR8994357_WT'); 
geneNames = trData.Geneid;
expressionValues = trData.Data;
try
    findGenesBelowThresholdGT1(threshold, geneNames, expressionValues);
    disp('findGenesBelowThresholdGT1.m... OK');
catch e
    disp('findGenesBelowThresholdGT1.m... NOK');
    disp(e);
end