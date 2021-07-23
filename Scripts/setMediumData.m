% Read model
model=readCbModel('..\Data\Yeast_8_4_0_V6.xls');

% Read medium data
fileName = '..\Data\MediumData.xlsx';
sheet = 'wildtype'; % wildtype, ade2, ade4, ade8
[numbers, text, mediumData] = xlsread(fileName,sheet);

% Set bounds for external metabolites
 for n=2:1:length(mediumData)
     disp(mediumData{n,1} + " " + round(mediumData{n,2},3) + " " + round(mediumData{n,3},3));
     model = changeRxnBounds(model,mediumData{n,1}, round(mediumData{n,2},3), 'l');
     model = changeRxnBounds(model,mediumData{n,1}, round(mediumData{n,3},3), 'u');
 end

% Set objective function (r_2033 pyruvate exchange)
model = changeObjective(model,'r_2033');

FBAsolutionMin = optimizeCbModel(model,'min'); 
FBAsolutionMax = optimizeCbModel(model,'max');

% Save Data
excelFileName = '..\Results\WildTypeTest_2.xls';
writeCbModel(model, excelFileName);





