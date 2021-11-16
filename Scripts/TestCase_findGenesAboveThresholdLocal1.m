threshold = 5;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 1;
try
    genes = findGenesAboveThresholdLocal1(threshold, trDataPath, sheetIndex);
    disp('findGenesAboveThresholdLocal1.m... OK');
catch e
    disp('findGenesAboveThresholdLocal1.m... NOK');
    disp(e);
end