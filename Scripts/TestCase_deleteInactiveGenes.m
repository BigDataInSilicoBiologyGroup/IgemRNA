model=readCbModel('Data/Yeast_8_4_0.xls');
trData=readtable('Data/TranscriptomicsData.xlsx','Sheet','SRR8994357_WT');
trDataPath = 'Data/TranscriptomicsData.xlsx';
thApproach=3;
lowerTh=0;
upperTh=30;
sheetIndex=1;
growthNotAffectingGeneDel=0;
percentile=0;
try
    model = deleteInactiveGenes(model, trData, trDataPath, thApproach, lowerTh, upperTh, sheetIndex, growthNotAffectingGeneDel,percentile);
    disp('deleteInactiveGenes.m... OK');
catch e 
    disp('deleteInactiveGenes.m... NOK');
    disp(e);
end