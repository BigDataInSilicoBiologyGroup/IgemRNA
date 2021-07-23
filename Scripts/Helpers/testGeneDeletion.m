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
                genes_to_delete{counter} = tr_genes{i};
                counter = counter + 1;
            end
        end
    end
end

results = cell(length(genes_to_delete),6);
[grRatio, grRateKO, grRateWT, hasEffect, delRxns] = singleGeneDeletion(model, 'FBA', genes_to_delete);
results(:,1) = genes_to_delete;
results(:,2) = num2cell(grRatio);
results(:,3) = num2cell(grRateKO);
results(1,4) = num2cell(grRateWT);
results(:,5) = num2cell(hasEffect);

for i=1:1:length(genes_to_delete)
    str = strjoin(delRxns{i,1},'\t');
    results{i,6} = str;
end

headers = cell(1,6);
headers{1} = 'GeneId';
headers{2} = 'grRatio';
headers{3} = 'grRateKO';
headers{4} = 'grRateWT';
headers{5} = 'hasEffect';
headers{6} = 'delRxns';
fullResult = [headers; results];

excelFileName = convertStringsToChars(strcat('../Results/SingleGeneDeletionResults/', sheetName, '.xls'));
writecell(fullResult,excelFileName);


