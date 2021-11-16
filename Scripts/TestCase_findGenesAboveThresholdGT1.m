threshold = 10;
trDataPath = 'Data/TranscriptomicsData.xlsx';
trData=readtable(trDataPath,'Sheet','SRR8994357_WT'); 
geneNames = trData.Geneid;
expressionValues = trData.Data;
try
    findGenesAboveThresholdGT1(threshold, geneNames, expressionValues);
    disp('findGenesAboveThresholdGT1.m... OK');
catch e
    disp('findGenesAboveThresholdGT1.m... NOK');
    disp(e);
end