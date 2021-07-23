model=readCbModel('..\Data\Yeast_8_4_0_V6.xls');
result = cell(3991,5);
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

% SET REACTION BOUNDS BASED ON TRANSCRIPTOMICS DATA
% for i=1:1:length(model.rxns)
%     
%     result{i,1} = model.rxns{i};
%     result{i,2} = model.grRules{i};
%     
%     % No associated genes
%     if model.grRules{i} == "" 
%         result{i,3} = 'No associated genes';
%         
%     % One Gene (expression does not contain brackets)
%     elseif ~contains(model.grRules{i},"(")
%         result{i,3} = 'One Gene';
%         value = findTranscriptionValue(model.grRules{i});
%         if value ~= 0
%             result{i,5} = findTranscriptionValue(model.grRules{i});
%         end
%         
%     % Gene combination AND + OR (expression contains double brackets)
%     elseif contains(model.grRules{i},"((") || contains(model.grRules{i},"))")
% 
%         result{i,3} = 'AND + OR';
%         value = model.grRules{i};
% 
%         %Split ORs
%         ands = split(model.grRules{i},"or");
%         orsToCompare = [];
% 
%         for k=1:1:length(ands)
%             %Split ANDs
%             operands = split(ands(k));
%             andsToCompare = [];
% 
%             for l=1:1:length(operands)
%                 if ~ismember(operands{l},logicalOperators) && operands(l)~=""
%                     tr_Val = findTranscriptionValue(operands{l});
%                     andsToCompare = [andsToCompare tr_Val];
%                 end
%             end
%             orsToCompare = [orsToCompare min(andsToCompare)];
%         end
% 
%         operands = split(model.grRules{i});
%         for l=1:1:length(operands)
%             if ~ismember(operands{l},logicalOperators)
%                 tr_Val = findTranscriptionValue(operands{l});
%                 value = strrep(value,operands{l},num2str(tr_Val));
%             end
%         end
%         result{i,4} = value;
%         result{i,5} = max(orsToCompare);
% 
%     % Gene combination AND
%     elseif contains(model.grRules{i},"and")
%         result{i,3} = 'AND only';
%         value = model.grRules{i};
%         operands = split(model.grRules{i});
%         numbersToCompare = [];
%         
%         for l=1:1:length(operands)
%             if ~ismember(operands{l},logicalOperators)
%                 tr_Val = findTranscriptionValue(operands{l});
%                 numbersToCompare = [numbersToCompare tr_Val];
%                 value = strrep(value,operands{l},num2str(tr_Val));
%             end
%         end
%         result{i,4} = value;
%         result{i,5} = min(numbersToCompare);
%         
%     % Gene combination OR
%     elseif contains(model.grRules{i},"or")
%         result{i,3} = 'OR only';
%         value = model.grRules{i};
%         operands = split(model.grRules{i});
%         numbersToCompare = [];
%         
%         for l=1:1:length(operands)
%             if ~ismember(operands{l},logicalOperators)
%                 tr_Val = findTranscriptionValue(operands{l});
%                 numbersToCompare = [numbersToCompare tr_Val];
%                 value = strrep(value,operands{l},num2str(tr_Val));
%             end
%         end
%         result{i,4} = value;
%         result{i,5} = max(numbersToCompare);
%     end
%     
%     %Set reaction bounds
%     if ~isempty(result{i,5})
%         % Irreversible only
%         if model.lb(i) == 0
%             % 30% error
%             withError = round(result{i,5} * 1.3,2);
%             model = changeRxnBounds(model,model.rxns{i},withError,'u');
%         end
%     end
% end

% Delete genes
[model, hasEffect, constrRxnNames, deletedGenes] = deleteModelGenes(model, genes_to_delete);  

FBAsolutionMin = optimizeCbModel(model,'min'); 
FBAsolutionMax = optimizeCbModel(model,'max');
% [minFlux, maxFlux] = fluxVariability(model, 90, 'min');

% Save results
excelFileName = convertStringsToChars(strcat('../Results/Threshold', string(zeroGeneExpressionThreshold),'/', sheetName, '_0.xls'));
writeCbModel(model, excelFileName);
[d1,d2, existingData] = xlsread(excelFileName);

FBAMin = ["FBAMin" ;FBAsolutionMin.x];
FBAMax = ["FBAMax" ;FBAsolutionMax.x];
% minFlux = ["MinFlux" ;minFlux];
% maxFlux = ["MaxFlux" ;maxFlux];

newData = [existingData, FBAMin, FBAMax];  % , minFlux, maxFlux to append the new column with existing data.
writematrix(newData,excelFileName);

function value = findTranscriptionValue(geneId)
    global geneIds
    global expressionValues
    for k=1:1:length(geneIds)
       if strcmp(geneId, geneIds(k))
           value = expressionValues(k);
       end
   end
end



