lowerThreshold = 0;
upperThreshold = 50;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 4;
try
    findGenesBelowThresholdLocal2(lowerThreshold, upperThreshold, trDataPath, sheetIndex);
    disp('findGenesBelowThresholdLocal2.m... OK');
catch e
    disp('findGenesBelowThresholdLocal2.m... NOK');
    disp(e);
end