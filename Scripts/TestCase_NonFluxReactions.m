threshold = 0; % 0-5
dataSet = 'S47D'; % WT; S47D
dest = strcat('..\Results post-optimization\*', dataSet, '*.xls');
S = dir(dest);
count = length(S);

result = {};
resultAll = {}; % zero reaction for each dataset
commonZeroReactions = {}; % common

for i=1:1:count
    sheetName = 'Reaction List';
    filename = strcat(S(i).folder, '\', S(i).name);
    [numbers, text, data] = xlsread(filename,sheetName);
    
    result(1,:) = data(1,:);
    counter = 2;
    for n=2:1:length(data)
        lb = string(data(n,5));
        ub = string(data(n,6));
        if lb == "0" && ub == "0"
            result(counter,:) = data(n,:);
            counter = counter + 1;
        end
    end
    resultAll{i} = result;
    result = {};
end


% Atrast kop?g?s
repeatTimes = length(resultAll); % Reaction has to repeat in each dataset
result1 = resultAll{1,1}; % first dataset to walk through
commonZeroReactions(1,:) = result1(1,:); % copy headers
counter = 2; % used to fill commonZeroReactions

for n=2:1:length(result1) % walk through first dataset abbreviations 
    reactionAbbr = string(result1(n,1));
    foundTimes = 1;

    for k=2:1:length(resultAll) % search other datasets for abbreviation
        data = resultAll{k}; 
        for s=2:1:length(data)
            if string(data(s,1)) == reactionAbbr
               foundTimes = foundTimes + 1; 
            end
        end
    end

    if foundTimes == repeatTimes % if found in each dataset copy to commonZeroReactions
        commonZeroReactions(counter,:) = result1(n,:);
        counter = counter + 1;
    end
end

excelFileName = strcat('..\Results post-optimization\Non-flux reactions\','non-flux reactions_', dataSet, '.xls');
for n=1:1:length(resultAll)
    sheet1Name = strrep(S(n).name,'.xls','');
    xlswrite(excelFileName, resultAll{n}, sheet1Name, 'A1');
end

sheetName = strcat('Common_', dataSet);
xlswrite(excelFileName, commonZeroReactions, sheetName, 'A1');