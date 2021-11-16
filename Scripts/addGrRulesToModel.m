function model = addGrRulesToModel(modelSbml)
    grRules = cell(length(modelSbml.rules),1);
    for i=1:1:length(modelSbml.rules)
        rule = modelSbml.rules{i};
        grRule = strrep(strrep(rule,'&','and'),'|','or');
        geneIndices = unique(extractBetween(rule,'x(',')'));
        for j=1:1:length(geneIndices)
            replace = char(strcat('x(',geneIndices{j},')'));
            geneName = modelSbml.genes{str2double(geneIndices{j})};
            grRule = strrep(grRule,replace,geneName);
        end
        grRules{i} = grRule;
    end
    modelSbml.grRules = grRules;
    model = modelSbml;
end