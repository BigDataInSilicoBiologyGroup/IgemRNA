
model=readCbModel('Yeast_8_4_0_V6.xls');
% GET TRANSCRIPTOMICS DATA
% S4_WT, S5_WT, S6_WT - Wild Type transcriptomics data
% S10_ADE2, S11_ADE2, S12_ADE2 - ADE2 transcriptomics data 
% S19_ADE8, S20_ADE8, S21_ADE8 - ADE8 transcriptomics data 
% S36_ADE4, S37_ADE4, S38_ADE4 - ADE4 transcriptomics data
sheetName = 'S4_WT_old';
filename = 'Transcriptomics_Data.xlsx';
[numbers, text, tr_data] = xlsread(filename,sheetName);
tr_genes = tr_data(:,1);
tr_count = tr_data(:,2);
transcriptomicsData=readtable(filename,'Sheet',sheetName);
geneIds = transcriptomicsData.Geneid;
expressionValues = transcriptomicsData.Data;

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
fileName = 'blackQueen hypothesis data.xlsx';
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
error_percentage = 0.05; % error_percentage = ade8Measurements{8};

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

 
[parsedGPR,corrRxn] = extractGPRs(model);
expressionCol = mapGeneToRxn(model, geneIds, expressionValues, parsedGPR, corrRxn);

gimmeModel = GIMME(model, expressionCol, 1);
imatModel2 = iMAT(model, expressionCol, 1, 10);

% https://github.com/LewisLabUCSD/Context_Specific_Models_from_GeMS/blob/master/Extraction%20Methods/additional_scripts/mapGeneToRxn.m
function expressionCol = mapGeneToRxn(model, gene_names, gene_exp, parsedGPR, corrRxn)
    %Map gene expression to reaction expression using the GPR rules. An AND
    %will be replaced by MIN and an OR will be replaced by MIN.
    %Input:
    %  model - model struct
    %  gene_names - gene identifiers corresponding to gene_exp. Names must
    %               be in the same format as model.genes (column vector)
    %               (as returned by "findUsedGeneLevels.m")
    %  gene_exp - gene FPKM/expression values, corresponding to names (column vector)
    %             (as returned by "findUsedGeneLevels.m")
    %  parsedGPR - GPR matrix as returned by "extractGPRS.m"
    %  corrRxn - reaction cell as returned by "extractGPRS.m"
    %Output
    %  expressionCol - reaction expression, corresponding to model.rxns

    expressionCol = -1*ones(length(model.rxns),1); %-1 means unknown/no data
    for ri = 1:length(corrRxn)
        rxnInd = find(ismember(model.rxns,corrRxn{ri})); %index of current reaction in model reaction array
        genesInRxn = parsedGPR(ri,:); %all genes that play a role in current reaction
        curExprArr = []; %Expression of all genes in the reaction
        for gi = 1:length(genesInRxn)
            if ~isempty(genesInRxn{gi}) %only do this when it is actually a gene, not a ''
                geneInd = find(ismember(gene_names,genesInRxn{gi})); %find index of gene in array of measured genes
                if ~isempty(geneInd) %if the gene is measured
                    curExprArr = [curExprArr, gene_exp(geneInd)]; %#ok<AGROW>
                end
            end
        end
        if ~isempty(curExprArr) %If there is data for any gene in the AND (or for a single gene only)
            curExpr = min(curExprArr);
            if curExpr > expressionCol(rxnInd) %An OR is found which has higher expression
                expressionCol(rxnInd) = curExpr;
            end
        end
    end
    
end

% https://www.egr.msu.edu/changroup/Protocols/Novel%20approach%20to%20reconstruct%20context%20depende_files/extractGPRs.m
function [parsedGPR,corrRxn] = extractGPRs(model)

warning off all

parsedGPR = [];
corrRxn = [];
cnt = 1;

for i = 1:length(model.rxns)
    if length(model.grRules{i}) > 1
        % Parsing each reactions gpr
        [parsing{1,1},parsing{2,1}] = strtok(model.grRules{i},'or');
        for j = 2:1000
            [parsing{j,1},parsing{j+1,1}] = strtok(parsing{j,1},'or');
            if isempty(parsing{j+1,1})==1
                break
            end
        end
        
        for j = 1:length(parsing)
            for k = 1:1000
                [parsing{j,k},parsing{j,k+1}] = strtok(parsing{j,k},'and');
                if isempty(parsing{j,k+1})==1
                    break
                end
            end
        end
        
        for j = 1:size(parsing,1)
            for k = 1:size(parsing,2)
                parsing{j,k} = strrep(parsing{j,k},'(','');
                parsing{j,k} = strrep(parsing{j,k},')','');
                parsing{j,k} = strrep(parsing{j,k},' ','');
            end
        end
        
        for j = 1:size(parsing,1)-1
            newparsing(j,:) = parsing(j,1:length(parsing(j,:))-1);
        end
        
        parsing = newparsing;
        
     
        for j = 1:size(parsing,1)
            for k = 1:size(parsing,2)
                if length(parsing{j,k}) == 0
                    parsing{j,k} = '';                    
                end
            end
        end
        
              
        num = size(parsing,1);
        for j = 1:num
            sizeP = length(parsing(j,:));
            if sizeP > size(parsedGPR,2)
                for k = 1:size(parsedGPR,1)
                    parsedGPR{k,sizeP} = {''};
                end
            end
            
            for l = 1:sizeP          
            parsedGPR{cnt,l} = parsing(j,l);
            end           
            cnt = cnt+1;
        end
        
        for j = 1:num
            corrRxn = [corrRxn;model.rxns(i)];
        end
        
        clear parsing newparsing
        
    end
    
end

for i = 1:size(parsedGPR,1)
    for j = 1:size(parsedGPR,2)
        if isempty(parsedGPR{i,j}) == 1
            parsedGPR{i,j} = {''};
        end
    end
end

i =1 ;
sizeP = size(parsedGPR,1);
while i < sizeP
    if strcmp(parsedGPR{i,1},{''}) == 1
        parsedGPR = [parsedGPR(1:i-1,:);parsedGPR(i+1:end,:)];
        corrRxn = [corrRxn(1:i-1,:);corrRxn(i+1:end,:)];
        sizeP = sizeP-1;        
        i=i-1;
    end
    i = i+1;
end

for i = 1:size(parsedGPR,1)
    for j= 1:size(parsedGPR,2)
        parsedGPR2(i,j) = cellstr(parsedGPR{i,j});
    end
end

parsedGPR = parsedGPR2;
end