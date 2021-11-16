trDataPath = 'Data/TranscriptomicsData.xlsx';
trData=readtable(trDataPath,'Sheet','SRR8994357_WT'); 
expressionValues = trData.Data;
k = '5';
try
    value = calculatePercentile(expressionValues, k);
    disp('calculatePercentile.m... OK');
catch e
    disp('calculatePercentile.m... NOK');
    disp(e);
end
