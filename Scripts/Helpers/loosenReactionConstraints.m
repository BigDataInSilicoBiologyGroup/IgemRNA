% GET context-specific models
% SRR8994357, SRR8994358, SRR8994359 (wild type no stress)
% SRR8994378, SRR8994379, SRR8994380 (S47D no stress)
datasetName='SRR8994380';
zeroGeneExpressionThreshold = 0;
modelFileName = strcat('..\Results\Transcriptomics and growth rate none affecting gene deletion\', datasetName, '_0.xls');
model=readCbModel(modelFileName);

% GET growth minimal requirement models
minReqFileName = strcat('..\Results\Minimal Requirements\', datasetName, '_0.xls');
[numbers, text, minReqData] = xlsread(minReqFileName,'Reaction List');
FbaMinData = minReqData(:,12);

result = {};
counter=1;

% Remove problematic constraints
for i=2:1:length(model.ub)
    if model.ub(i-1) < str2double(FbaMinData(i))
        result(counter) = model.rxns(i-1);
        model = changeRxnBounds(model, model.rxns(i-1), 1000, 'u');
        counter = counter + 1;
    end
end

% Optimize
FBAsolutionMin = optimizeCbModel(model,'min'); 
FBAsolutionMax = optimizeCbModel(model,'max');
[minFlux, maxFlux] = fluxVariability(model, 90, 'min');

% Save results
excelFileName = convertStringsToChars(strcat('../Results/Threshold', string(zeroGeneExpressionThreshold),'/', datasetName, '_0.xls'));
writeCbModel(model, excelFileName);
[d1,d2, existingData] = xlsread(excelFileName);

% Format new columns 
FBAMin = ["FBAMin" ;FBAsolutionMin.x];
FBAMax = ["FBAMax" ;FBAsolutionMax.x];
minFlux = ["MinFlux" ;minFlux];
maxFlux = ["MaxFlux" ;maxFlux];

% Add new columns to existing data
newData = [existingData, FBAMin, FBAMax, minFlux, maxFlux];

% Save
writematrix(newData,excelFileName);

