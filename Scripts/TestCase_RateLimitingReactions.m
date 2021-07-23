threshold = 0; % 0-5
dataSet = 'S47D'; % WT; S47D
dest = strcat('..\Results post-optimization\*', dataSet, '*.xls');
S = dir(dest);
count = length(S);

result = {};
resultAll = {}; % zero reaction for each dataset
commonBottleneckReactions = {}; % common

for i=1:1:count
    sheetName = 'Reaction List';
    filename = strcat(S(i).folder, '\', S(i).name);
    [numbers, text, data] = xlsread(filename,sheetName);
    
    result(1,:) = data(1,:);
    counter = 2;
    for n=2:1:length(data)
        ub = str2double(data{n,6});
        maxFlux = str2double(data{n,15});
        if ub == maxFlux && ub ~= 0 && maxFlux ~= 1000% && GPR not empty
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
commonBottleneckReactions(1,:) = result1(1,:); % copy headers
counter = 2; % used to fill commonZeroReactions

for n=2:1:height(result1) % walk through first dataset abbreviations 
    reactionAbbr = string(result1(n,1));
    foundTimes = 1;

    for k=1:1:length(resultAll) % search other datasets for abbreviation
        data = resultAll{k}; 
        for s=2:1:height(data)
            if string(data(s,1)) == reactionAbbr
               foundTimes = foundTimes + 1; 
            end
        end
    end

    if foundTimes == repeatTimes % if found in each dataset copy to commonZeroReactions
        commonBottleneckReactions(counter,:) = result1(n,:);
        counter = counter + 1;
    end
end

excelFileName = strcat('..\Results post-optimization\Rate limitting reactions\','rate_limitting_reactions_', dataSet, '.xls');
for n=1:1:length(resultAll)
    sheet1Name = strrep(S(n).name,'.xls','');
    xlswrite(excelFileName, resultAll{n}, sheet1Name, 'A1');
end

sheetName = strcat('Common_', dataSet);
xlswrite(excelFileName, commonBottleneckReactions, sheetName, 'A1');