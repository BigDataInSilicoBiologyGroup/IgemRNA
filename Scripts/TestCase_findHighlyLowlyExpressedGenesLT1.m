threshold = 5;
trDataPath = 'Data/TranscriptomicsData.xlsx';
sheetIndex = 1;
try
    findHighlyLowlyExpressedGenesLT1(threshold, trDataPath, sheetIndex);
    disp('findHighlyLowlyExpressedGenesLT1.m... OK');
catch e
    disp('findHighlyLowlyExpressedGenesLT1.m... NOK');
    disp(e);
end