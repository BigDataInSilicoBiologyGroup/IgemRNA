% File from which take metabolite names
filename = 'Yeast_8_4_0_V6.xls';
[numbers, text, data] = xlsread(filename,'Reaction List');
reactions = data(:,3);
[numbers, text, data] = xlsread(filename,'Metabolite List');
abbreviations = data(:,1);
descriptions = data(:,2);

% Files to dechiper
threshold = 3;
dest = strcat('Threshold', string(threshold), '\Stacionars stavoklis\Results\*.xls');
S = dir(dest);

 for i=1:1:length(S)
    filename = strcat(S(i).folder, '\', S(i).name); 
    [~,sheet_names]=xlsfinfo(filename);
    
    for n=1:1:length(sheet_names)
        [numbers, text, data] = xlsread(filename,sheet_names{n});
        result = cell(length(data),1);
        result{1} = 'Reaction with metabolite names';
        for k=2:1:length(data)
            reaction = data(k,3);
            components = split(reaction);
            reaction_deciphered = "";

            for l=1:1:length(components)
                if startsWith(components{l},'s','IgnoreCase',true)
                    % Is metabolite
                    for j=2:1:length(abbreviations)
                        if strcmp(abbreviations{j},components{l})
                            reaction_deciphered = reaction_deciphered + descriptions{j} + ' ';
                        end
                    end
                else
                    reaction_deciphered = reaction_deciphered + components{l} + ' ';
                    % Is symbol
                end
                result{k} = char(reaction_deciphered);
            end
        end
        
        % write result to excel
        [d1,d2, existingData] = xlsread(filename,sheet_names{n});
        newData = [existingData(:,1),existingData(:,2),existingData(:,3),result,existingData(:,4),existingData(:,5),existingData(:,6),existingData(:,7),existingData(:,8),existingData(:,9),existingData(:,10),existingData(:,11),existingData(:,12),existingData(:,13),existingData(:,14),existingData(:,15)]; 
        xlswrite(filename, newData, sheet_names{n}, 'A1');  % to write new data into excel sheet.
    end
end