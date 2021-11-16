threshold = 5;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 1;
try
    findGenesBelowThresholdLocal1(threshold, trDataPath, sheetIndex);
    disp('findGenesBelowThresholdLocal1.m... OK');
catch e
    disp('findGenesBelowThresholdLocal1.m... NOK');
    disp(e);
end