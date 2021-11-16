modelPath = 'Data/Yeast_8_4_0.xls';
trDataPath = 'Data/TranscriptomicsData.xlsx';
mediumDataPath = 'Data/MediumData.xlsx';
growthNotAffectingGeneDel = 1;
thApproach = 3;
lowerTh = 5;
upperTh = 50;
objective = 'r_2111';
try
    calculateMinimumRequirements(modelPath, trDataPath, mediumDataPath, growthNotAffectingGeneDel, thApproach, lowerTh, upperTh, objective);
    disp('calculateMinimumRequirements.m... OK');
catch e
    disp('calculateMinimumRequirements.m... NOK');
    disp(e);
end