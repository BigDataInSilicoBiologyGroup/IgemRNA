function main(inputData)

    t = datetime('now');
    strt = datestr(t);
    d = strrep(strt,':','-');
    
    thresholdingApproach = 1;
    if inputData.localT1 == 1
        thresholdingApproach = 2;
    elseif inputData.localT2 == 1
        thresholdingApproach = 3;
    end
    
    LowerGlobalThresholdVal = str2num(inputData.lowerGlobal);
    UpperGlobalThresholdVal = str2num(inputData.upperGlobal);
    
    nonOptTasks = [inputData.filterHighlyLowlyExpressedGenes inputData.filterLowlyExpressedGenes inputData.ComparePhenotypeGenes];
    postOptTasks = [inputData.filterNonFluxReactions inputData.filterRateLimittingReactions inputData.calculateFluxShifts];
    
    % Non-opt tasks
    if any(nonOptTasks(:) == 1)   
        % Get transcriptomics data sheet names
        trSheets = sheetnames(inputData.trDataPath);
        
        % Process all phenotypes
        if inputData.filterHighlyLowlyExpressedGenes == 1 || inputData.filterLowlyExpressedGenes == 1
            for i=1:1:height(trSheets) 
                
                trData=readtable(inputData.trDataPath,'Sheet',trSheets{i});    
                
                % Calculate percentile
                if inputData.percentile == 1        
                    LowerGlobalThresholdVal = calculatePercentile(trData.Data, inputData.lowerGlobal);
                    UpperGlobalThresholdVal = calculatePercentile(trData.Data, inputData.upperGlobal);
                end
                
                if inputData.globalT1 == 1 % No local rules
                    % filterLowlyExpressedGenes GT1
                    if inputData.filterLowlyExpressedGenes == 1
                        lowlyExpressedGenes = findGenesBelowThresholdGT1(LowerGlobalThresholdVal, trData.Geneid, trData.Data);
                        folderName = strcat('Results non-optimization/Lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_GT1_', string(LowerGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, lowlyExpressedGenes);
                    end
                    
                    % filterHighlyLowlyExpressedGenes GT1
                    if inputData.filterHighlyLowlyExpressedGenes == 1
                        geneExpressionLevels = findHighlyLowlyExpressedGenesGT1(LowerGlobalThresholdVal, trData.Geneid, trData.Data);
                        folderName = strcat('Results non-optimization/Highly-lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_GT1_', string(LowerGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, geneExpressionLevels);
                    end
                    
                elseif inputData.localT1 == 1 % Must apply local rules (multiple tr datasets)
                    % filterLowlyExpressedGenes LT1
                    if inputData.filterLowlyExpressedGenes == 1
                        lowlyExpressedGenes = findGenesBelowThresholdLocal1(LowerGlobalThresholdVal, inputData.trDataPath, i);
                        folderName = strcat('Results non-optimization/Lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_LT1_', string(LowerGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, lowlyExpressedGenes);
                    end
                    
                    % filterHighlyLowlyExpressedGenes LT1
                    if inputData.filterHighlyLowlyExpressedGenes == 1
                        geneExpressionLevels = findHighlyLowlyExpressedGenesLT1(LowerGlobalThresholdVal, inputData.trDataPath, i);
                        folderName = strcat('Results non-optimization/Highly-lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_LT1_', string(LowerGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, geneExpressionLevels);
                    end

                else % inputData.localT2 == 1
                    % filterLowlyExpressedGenes LT1
                    if inputData.filterLowlyExpressedGenes == 1
                        lowlyExpressedGenes = findGenesBelowThresholdLocal2(LowerGlobalThresholdVal, UpperGlobalThresholdVal, inputData.trDataPath, i);
                        folderName = strcat('Results non-optimization/Lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_LT2_', string(LowerGlobalThresholdVal), '_', string(UpperGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, lowlyExpressedGenes);
                    end
                    
                    % filterHighlyLowlyExpressedGenes LT1
                    if inputData.filterHighlyLowlyExpressedGenes == 1
                        geneExpressionLevels = findHighlyLowlyExpressedGenesLT2(LowerGlobalThresholdVal, UpperGlobalThresholdVal, inputData.trDataPath, i);
                        folderName = strcat('Results non-optimization/Highly-lowly expressed genes/',d,'/');
                        excelFileName = strcat(trSheets{i}, '_LT2_', string(LowerGlobalThresholdVal), '_', string(UpperGlobalThresholdVal), '.xls');
                        saveResults(folderName, excelFileName, geneExpressionLevels);
                    end
                end
            end
        end        

        % Process selected phenotypes (or one to all)
        if inputData.ComparePhenotypeGenes == 1
            % ComparePhenotypeGenes
            if string(inputData.nonOptCompareTarget) == "All"
                trSheets = sheetnames(inputData.trDataPath);
                for j=1:1:height(trSheets)
                    if trSheets{j} ~= string(inputData.nonOptCompareSource)
                        result = findUpDownRegulatedGenes(inputData.nonOptCompareSource, trSheets{j}, inputData.trDataPath);
                        folderName = strcat('Results non-optimization/Gene expression level comparison/',d,'/');
                        excelFileName = strcat(inputData.nonOptCompareSource, '_compared_to_', trSheets{j}, '.xls');
                        saveResults(folderName, excelFileName, result);
                    end
                end
            else
                result = findUpDownRegulatedGenes(inputData.nonOptCompareSource, inputData.nonOptCompareTarget, inputData.trDataPath);
                folderName = strcat('Results non-optimization/Gene expression level comparison/',d,'/');
                excelFileName = strcat(inputData.nonOptCompareSource, '_compared_to_', inputData.nonOptCompareTarget, '.xls');
                saveResults(folderName, excelFileName, result);
            end
        end
    end

    % Post-opt tasks
    if any(postOptTasks(:) == 1)
        
        % Start CobraToolbox
        if inputData.initCobraNoUpdates == 1
            initCobraToolbox(false);
        else
            initCobraToolbox(true);
        end
        
        % Calculate minimum requirements for transcriptomics validation
        if inputData.meetMinimumGrowthReq == 1
            calculateMinimumRequirements(inputData.modelPath,inputData.trDataPath,inputData.mediumDataPath,inputData.growthNotAffectingGeneDel, thresholdingApproach, LowerGlobalThresholdVal, UpperGlobalThresholdVal, inputData.objectiveFunction, inputData.percentile);
        end
        
        % Integrate transcriptomics in the model
        if inputData.useExistingModels ~= 1
            createContextSpecificModel(inputData.modelPath,inputData.trDataPath,inputData.mediumDataPath,inputData.growthNotAffectingGeneDel, inputData.meetMinimumGrowthReq, thresholdingApproach, LowerGlobalThresholdVal, UpperGlobalThresholdVal, inputData.objectiveFunction, inputData.gmMAX, inputData.constrAll, inputData.excludeBiomassEquation, inputData.biomassId);
        end
        
        if inputData.filterNonFluxReactions == 1
            dest = strcat('Results post-optimization\Context-specific models\*.xls');
            S = dir(dest);
            count = length(S);
            phenotypes = {};
            cnt = 1;
            
            for i=1:1:count
                temp = split(S(i).name,'_');
                phenotype = replace(temp(length(temp)),'.xls','');
                if ~any(strcmp(phenotypes,phenotype))
                    phenotypes(cnt) = phenotype;
                    filterNonFluxReactions(phenotype);
                    cnt = cnt + 1;
                end
            end
        end
        
        if inputData.filterRateLimittingReactions == 1
            dest = strcat('Results post-optimization\Context-specific models\*.xls');
            S = dir(dest);
            count = length(S);
            phenotypes = {};
            cnt = 1;
            
            for i=1:1:count
                temp = split(S(i).name,'_');
                phenotype = replace(temp(length(temp)),'.xls','');
                if ~any(strcmp(phenotypes,phenotype))
                    phenotypes(cnt) = phenotype;
                    cnt = cnt + 1;
                    filterRateLimittingReactions(phenotype);
                end
            end
        end
        
        if inputData.calculateFluxShifts == 1
            calculateFluxShifts(inputData.fluxShiftsSource, inputData.fluxShiftsTarget);
        end
       
    end
    f = msgbox('Operation Completed!');  
end