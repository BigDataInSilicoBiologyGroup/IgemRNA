modelPath = 'Data/Yeast_8_4_0.xls';
trDataPath = 'Data/TranscriptomicsData.xlsx';
mediumDataPath = 'Data/MediumData.xlsx';
growthNotAffectingGeneDel = 0;
thApproach = 3;
lowerTh = 5;
upperTh = 50;
objective = 'r_2111';
percentile = 0;
try
    calculateMinimumRequirements(modelPath, trDataPath, mediumDataPath, growthNotAffectingGeneDel, thApproach, lowerTh, upperTh, objective, percentile);
    disp('calculateMinimumRequirements.m... OK');
catch e
    disp('calculateMinimumRequirements.m... NOK');
    disp(e);
end