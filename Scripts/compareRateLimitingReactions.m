threshold =0;
% Rate limitting reactions data
dest = '..\Results\Rate limitting reactions\*S47D*.xls';
S = dir(dest);
count = length(S);

% Wild Type rate limitting reactions data
destWT = '..\Results\Rate limitting reactions\*WT*.xls';
WT = dir(destWT);

sheetName = 'Common_WT';
filename = strcat(WT.folder, '\', WT.name);
[numbers, text, dataWT] = xlsread(filename,sheetName); % Read wild type common data (botthleneck reactions present in all datasets)

resultAll = {};

for i=1:1:length(S)
    if ~contains(S(i).name,'WT') % Walk through all bottleneck reaction files except wt
        nameParts = split(S(i).name,"_"); % Split file name at '_' to get the name of mutant
        org = strrep(nameParts(4),'.xls',''); % Get the name of mutant (example: ADE2) PĒDĒJĀ DAĻA length()
        
        sheetName = char(strcat('Common_', org(1,1))); % example: Common_ADE2
        filename = strcat(S(i).folder, '\', S(i).name); % example: C:\...\Bottleneck_Reactions_ADE2.xls (full path)
        [numbers, text, data] = xlsread(filename,sheetName); % read the mutant common bottleneck reactions
        
        result = {};
        result(1,:) = data(1,:); % copy headers
        counter = 2;
        
        for n=2:1:size(data,1) % Walk through all bottleneck reactions in mutant
            reaction = data(n,1); % Get the Abbreviation of a reaction
            found = 0;
            for k=2:1:length(dataWT) % Search for reaction in wt common bittleneck reactions
                if string(dataWT(k,1)) == string(reaction) % if reaction with the same Abbreviation exists in wt
                    found = 1;
                end
            end
            
            if found == 0 % Write reactions not present in wt to result (is bottleneck in mutant but not in wt)
                result(counter,:) = data(n,:);
                counter = counter + 1;
            end
        end
        
        resultAll{i} = result;
        xlswrite(filename, result, 'Common_Not_Rate_In_WT', 'A1'); % Add new result sheet to excel document (mutant)
    end
end
