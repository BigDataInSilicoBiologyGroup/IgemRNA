threshold=6;
trDataPath = 'Data/TranscriptomicsData.xlsx';
trData=readtable(trDataPath,'Sheet','SRR8994357_WT'); 
geneNames = trData.Geneid;
expressionValues = trData.Data;
try
    findHighlyLowlyExpressedGenesGT1(threshold, geneNames, expressionValues);
    disp('findHighlyLowlyExpressedGenesGT1.m... OK');
catch e
    disp('findHighlyLowlyExpressedGenesGT1.m... NOK');
    disp(e);
end