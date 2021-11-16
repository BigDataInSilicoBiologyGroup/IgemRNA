lowerThreshold = 0;
upperThreshold = 50;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 4;
try
    findGenesAboveThresholdLocal2(lowerThreshold, upperThreshold, trDataPath, sheetIndex);
    disp('findGenesAboveThresholdLocal2.m... OK');
catch e
    disp('findGenesAboveThresholdLocal2.m... NOK');
    disp(e);
end