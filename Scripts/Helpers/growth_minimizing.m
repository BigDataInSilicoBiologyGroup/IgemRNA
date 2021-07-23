model=readCbModel('..\Data\Yeast_8_4_0_V6.xls');
zeroGeneExpressionThreshold = 0;
logicalOperators = ["and" "or" "(" ")" "((" "))"];
global geneIds
global expressionValues

% GET TRANSCRIPTOMICS DATA
% SRR8994357, SRR8994358, SRR8994359 (wild type no stress)
% SRR8994378, SRR8994379, SRR8994380 (S47D no stress)
sheetName = 'SRR8994380';
filename = '..\Data\TranscriptomicsTestData.xlsx';
[numbers, text, tr_data] = xlsread(filename,sheetName);
tr_genes = tr_data(:,1);
tr_count = tr_data(:,2);
transcriptomicsData=readtable(filename,'Sheet',sheetName);
geneIds = transcriptomicsData.Geneid;
expressionValues = transcriptomicsData.Data;

% DELETE NON EXPRESSED GENES
genes_to_delete = {};
counter = 1;

% Non expressed genes
for i=2:1:length(tr_genes)
    if tr_count{i} <= zeroGeneExpressionThreshold % Only genes that are not expressed
        for n=1:1:length(model.genes)
            if strcmp(tr_genes{i}, model.genes{n}) % Metabolic genes only
                % Test is gene deletions affects growth
                [grRatio, grRateKO, grRateWT, hasEffect, delRxns] = singleGeneDeletion(model, 'FBA', tr_genes(i));
                if grRatio == 1
                    genes_to_delete{counter} = tr_genes{i};
                    counter = counter + 1;
                end
            end
        end
    end
end

% Delete genes
[model, hasEffect, constrRxnNames, deletedGenes] = deleteModelGenes(model, genes_to_delete);  

% Set medium data
fileName = '..\Data\MediumData.xlsx';
sheet = 'Sheet1'; % Should be the phenotype name
[numbers, text, mediumData] = xlsread(fileName,sheet);

% Set bounds for external metabolites
for n=2:1:height(mediumData)
     model = changeRxnBounds(model,mediumData{n,1}, mediumData{n,2}, 'l');
     model = changeRxnBounds(model,mediumData{n,1}, mediumData{n,3}, 'u');
end

% Optimize 
FBAsolutionMin = optimizeCbModel(model,'min'); 

%Save
excelFileName = convertStringsToChars(strcat('../Results/Threshold', string(zeroGeneExpressionThreshold),'/', sheetName, '_0.xls'));
writeCbModel(model, excelFileName);
[d1,d2, existingData] = xlsread(excelFileName);
FBAMin = ["FBAMin" ;FBAsolutionMin.x];
newData = [existingData, FBAMin];  % to append the new column with existing data.
writematrix(newData,excelFileName);
