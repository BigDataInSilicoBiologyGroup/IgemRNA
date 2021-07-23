function [tissuemodel, resultGPR, FBAsolutionMin, FBAsolutionMax] = transcriptomicsDataIntegration(model, transcriptomicsData, globalThresholds, genesToDelete)
    
    global geneIds 
    global expressionValues
    geneIds = transcriptomicsData(:,1);
    expressionValues = transcriptomicsData(:,2);
    
    resultGPR = cell(3991,5);
    logicalOperators = ["and" "or" "(" ")" "((" "))"];

% Acconding to the specific yeast case
%     if contains(sheetName,"ADE2")
%         genes_to_delete{1} = 'YOR128C';
%     elseif contains(sheetName,"ADE8")
%         genes_to_delete{1} = 'YDR408C';
%     elseif contains(sheetName,"ADE4")
%         genes_to_delete{1} = 'YMR300C';
%     else
%         counter = 1;
%     end

    % SET REACTION BOUNDS BASED ON TRANSCRIPTOMICS DATA
    for i=1:1:length(model.rxns)
        resultGPR{i,1} = model.rxns{i};
        resultGPR{i,2} = model.grRules{i};

        % No associated genes
        if model.grRules{i} == "" 
            resultGPR{i,3} = 'No associated genes';

        % One Gene (expression does not contain brackets)
        elseif ~contains(model.grRules{i},"(")
            resultGPR{i,3} = 'One Gene';
            value = findTranscriptionValue(model.grRules{i});
            if value ~= 0
                resultGPR{i,5} = findTranscriptionValue(model.grRules{i});
            end

        % Gene combination AND + OR (expression contains double brackets)
        elseif contains(model.grRules{i},"((") || contains(model.grRules{i},"))")

            resultGPR{i,3} = 'AND + OR';
            value = model.grRules{i};

            %Split ORs
            ands = split(model.grRules{i},"or");
            orsToCompare = [];

            for k=1:1:length(ands)
                %Split ANDs
                operands = split(ands(k));
                andsToCompare = [];

                for l=1:1:length(operands)
                    if ~ismember(operands{l},logicalOperators) && operands(l)~=""
                        tr_Val = findTranscriptionValue(operands{l});
                        andsToCompare = [andsToCompare tr_Val];
                    end
                end
                orsToCompare = [orsToCompare min(andsToCompare)]; % MAX/SUM
            end

            operands = split(model.grRules{i});
            for l=1:1:length(operands)
                if ~ismember(operands{l},logicalOperators)
                    tr_Val = findTranscriptionValue(operands{l});
                    value = strrep(value,operands{l},num2str(tr_Val));
                end
            end
            resultGPR{i,4} = value;
            resultGPR{i,5} = max(orsToCompare);

        % Gene combination AND
        elseif contains(model.grRules{i},"and")
            resultGPR{i,3} = 'AND only';
            value = model.grRules{i};
            operands = split(model.grRules{i});
            numbersToCompare = [];

            for l=1:1:length(operands)
                if ~ismember(operands{l},logicalOperators)
                    tr_Val = findTranscriptionValue(operands{l});
                    numbersToCompare = [numbersToCompare tr_Val];
                    value = strrep(value,operands{l},num2str(tr_Val));
                end
            end
            resultGPR{i,4} = value;
            resultGPR{i,5} = min(numbersToCompare);

        % Gene combination OR
        elseif contains(model.grRules{i},"or")
            resultGPR{i,3} = 'OR only';
            value = model.grRules{i};
            operands = split(model.grRules{i});
            numbersToCompare = [];

            for l=1:1:length(operands)
                if ~ismember(operands{l},logicalOperators)
                    tr_Val = findTranscriptionValue(operands{l});
                    numbersToCompare = [numbersToCompare tr_Val];
                    value = strrep(value,operands{l},num2str(tr_Val));
                end
            end
            resultGPR{i,4} = value;
            resultGPR{i,5} = max(numbersToCompare); % MAX/SUM
        end

        %Set reaction bounds
        if ~isempty(resultGPR{i,5})
            %check if reaction has one direction (lower bound == 0)
            if model.lb(i) == 0
                model = changeRxnBounds(model,model.rxns{i},resultGPR{i,5},'u');
            end
        end
    end


    % Delete genes
    [model, hasEffect, constrRxnNames, deletedGenes] = deleteModelGenes(model, genesToDelete);  


    % GET EXPERIMENTAL DATA FOR TRANSPORT REACTIONS
    % 5 - Wild Type
    % 6 - ade1
    % 7 - ade16/17
    % 8 - ade2
    % 9 - ade4
    % 10 - ade5,7
    % 11 - ade6
    % 12 - ade8
    rowNumber = 5;
    fileName = '../Data/blackQueen hypothesis data.xlsx';
    [numbers, text, all] = xlsread(fileName,'SD+');
    ade8Measurements = all(rowNumber,:);
    growthRate = ade8Measurements{2};
    glucose = ade8Measurements{3};
    ethanol = ade8Measurements{4};
    glycerol = ade8Measurements{5};
    acetate = ade8Measurements{6};
    CO2 = ade8Measurements{7};
    adenineMin = ade8Measurements{9};
    adenineMax = ade8Measurements{10};
    error_percentage = 0.05;

    % Reaction constraints
    % Growth rate (r_2111)
    model = changeRxnBounds(model,'r_2111', growthRate,'b');
    % model = changeRxnBounds(model,'r_2111', (growthRate - growthRate * error_percentage),'l');
    % model = changeRxnBounds(model,'r_2111', (growthRate + growthRate * error_percentage),'u');

    % D-glucose exchange (r_1714)
    model = changeRxnBounds(model,'r_1714',(glucose + glucose * error_percentage),'l');
    model = changeRxnBounds(model,'r_1714',0,'u');

    % ethanol exchange (r_1761)
    model = changeRxnBounds(model,'r_1761',(ethanol - ethanol * error_percentage),'l');
    model = changeRxnBounds(model,'r_1761',(ethanol + ethanol * error_percentage),'u');

    % glycerol exchange (r_1808)
    model = changeRxnBounds(model,'r_1808',(glycerol - glycerol * error_percentage),'l');
    model = changeRxnBounds(model,'r_1808',(glycerol + glycerol * error_percentage),'u');

    % acetate exchange (r_1634)
    model = changeRxnBounds(model,'r_1634',(acetate - acetate * error_percentage),'l');
    model = changeRxnBounds(model,'r_1634',(acetate + acetate * error_percentage),'u');

    % carbon dioxide exchange (r_1672)
    model = changeRxnBounds(model,'r_1672',(CO2 - CO2 * error_percentage),'l');
    model = changeRxnBounds(model,'r_1672',(CO2 + CO2 * error_percentage),'u');

    % adenine exchange (r_1639)
    model = changeRxnBounds(model,'r_1639',(adenineMax + adenineMax * error_percentage),'l');
    model = changeRxnBounds(model,'r_1639',(adenineMin - adenineMin * error_percentage),'u');

    % Objective (r_2033	pyruvate exchange)
    model = changeObjective(model,'r_2033');
    
    % Deactivete biomass equation (r_4041 biomass pseudoreaction) OPTIONAL
%     model = changeRxnBounds(model,'r_4041',0,'u');
    
    tissuemodel = model; 
    FBAsolutionMin = optimizeCbModel(model,'min'); 
    FBAsolutionMax = optimizeCbModel(model,'max');
    
%     [minFlux, maxFlux] = fluxVariability(model, 90, 'min');
% 
%     excelFileName = strcat(sheetName, '_test.xls');
%     writeCbModel(model, excelFileName);
%     [d1,d2, existingData] = xlsread(excelFileName);
% 
%     FBAMin = ["FBAMin" ;FBAsolutionMin.x];
%     FBAMax = ["FBAMax" ;FBAsolutionMax.x];
%     minFlux = ["MinFlux" ;minFlux];
%     maxFlux = ["MaxFlux" ;maxFlux];
% 
%     newData = [existingData, FBAMin, FBAMax, minFlux, maxFlux];  % to append the new column with existing data.
%     xlswrite(excelFileName, newData, 'Reaction List', 'A1');  % to write new data into excel sheet.

end


function value = findTranscriptionValue(geneId)
    global geneIds
    global expressionValues
    for k=1:1:length(geneIds)
       if strcmp(geneId, geneIds{k})
           value = expressionValues{k};
       end
   end
end
