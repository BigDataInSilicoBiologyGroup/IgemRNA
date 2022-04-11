modelPath = 'Data/Yeast_8_4_0.xls';
trDataPath = 'Data/TranscriptomicsData.xlsx';
mediumDataPath = 'Data/MediumData.xlsx';
growthNotAffectingGeneDel = 1;
meetMinimumReq = 0;
thApproach = 3;
lowerTh = 2;
upperTh = 25;
objective = 'r_2111';
gmAndOperation = 'MIN';
gmOrOperation = 'MAX';
constrAll = 0;
excludeBiomassEq = 0;
percentile=0;
try
    model = createContextSpecificModel(modelPath, trDataPath, mediumDataPath, growthNotAffectingGeneDel, meetMinimumReq, thApproach, lowerTh, upperTh, objective, gmAndOperation, gmOrOperation, constrAll, excludeBiomassEq,percentile);
    disp('createContextSpecificModel.m... OK');
catch e
    disp('createContextSpecificModel.m... NOK');
    disp(e);
end