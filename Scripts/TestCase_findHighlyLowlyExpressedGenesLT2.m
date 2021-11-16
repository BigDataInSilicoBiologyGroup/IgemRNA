lowerThreshold = 0;
upperThreshold = 50;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 4;
try
    findHighlyLowlyExpressedGenesLT2(lowerThreshold, upperThreshold, trDataPath, sheetIndex);
    disp('findHighlyLowlyExpressedGenesLT2.m... OK');
catch e
    disp('findHighlyLowlyExpressedGenesLT2.m... NOK');
    disp(e);
end