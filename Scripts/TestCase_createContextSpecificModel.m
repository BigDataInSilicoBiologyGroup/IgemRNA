modelPath = 'Data/Yeast_8_4_0.xls';
trDataPath = 'Data/TranscriptomicData.xlsx';
mediumDataPath = 'Data/MediumData.xlsx';
growthNotAffectingGeneDel = 1;
meetMinimumReq = 0;
thApproach = 3;
lowerTh = 2;
upperTh = 25;
objective = 'r_2111';
gmMAX = 1;
constrAll = 0;
excludeBiomassEq = 0;
try
    model = createContextSpecificModel(modelPath, trDataPath, mediumDataPath, growthNotAffectingGeneDel, meetMinimumReq, thApproach, lowerTh, upperTh, objective, gmMAX, constrAll, excludeBiomassEq);
    disp('createContextSpecificModel.m... OK');
catch e
    disp('createContextSpecificModel.m... NOK');
    disp(e);
end