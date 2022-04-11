% In the forder Flux Shifts there must be one WT file with the fluxes
% calculated with FVA
% And the mutant files that have FVA data

% Make sure that MinFlux is at comuln 14 and MaxFlux is at column 15 (sheet
% Reaction List)

threshold = 0; % (possible: 0-5)

% Find the files described in the comments above
dest = strcat('..\Results post-optimization\Context-specific models\*S47D*.xls');
S = dir(dest);
count = length(S);

% Find WT data file (is used to compare with mutants)
destWT = strcat('..\Results post-optimization\Context-specific models\SRR8994357_WT_GT1_0.xls');
WT = dir(destWT);
sheetName = 'Reaction List';
filename = strcat(WT.folder, '\', WT.name);
[numbers, text, dataWT] = xlsread(filename, sheetName); % Read WT data

% Get minFlux and MaxFlux from WT
datasetNameWT = strrep(WT.name,'.xls',''); % example: 'S5_WT'
minFluxWT = dataWT(:,14);
maxFluxWT = dataWT(:,15);
% Rename headers (to represent dataset name)
minFluxWT{1} = strcat('MinFlux',datasetNameWT);
maxFluxWT{1} = strcat('MaxFlux',datasetNameWT);

minFluxWT_r = cell(length(dataWT), 1);
maxFluxWT_r = cell(length(dataWT), 1);
minFluxWT_r{1} = minFluxWT{1};
maxFluxWT_r{1} = maxFluxWT{1};

for i=2:1:length(dataWT)
    minFluxWT_r{i} = round(str2double(minFluxWT{i}),6);
    maxFluxWT_r{i} = round(str2double(maxFluxWT{i}),6);
end


% Walk through all mutant data files
for i=1:1:length(S)
    if ~contains(S(i).name,'WT')
        % Read data from mutant file
        filename = strcat(S(i).folder, '\', S(i).name); % full path
        [numbers, text, data] = xlsread(filename, sheetName); 
        
        % Read mutant fluxes
        minFlux = data(:,14);
        maxFlux = data(:,15);
        
        minFlux_r = cell(length(minFlux),1);
        maxFlux_r = cell(length(maxFlux),1);
        minFlux_r{1} = minFlux{1};
        maxFlux_r{1} = maxFlux{1};
        
        for k=2:1:length(data)
            minFlux_r{k} = round(str2double(minFlux{k}),6);
            maxFlux_r{k} = round(str2double(maxFlux{k}),6);
        end
        
        % Calculate the ratio (mutantFlux: wtFlux) to get the flux shifts
        MinFluxRatio = cell(length(minFlux),1);
        MaxFluxRatio = cell(length(minFlux),1);
        % Headers for the new data columns
        MinFluxRatio{1} = 'MinFluxRatio (mutantFlux: wtFlux)';
        MaxFluxRatio{1} = 'MaxFluxRatio (mutantFlux: wtFlux)';
        
        % Calculate ratio for all reaction Fluxes (mutantFlux: wtFlux)
        for n=2:1:length(minFlux)
            minRatio = minFlux_r{n}/minFluxWT_r{n};
            maxRatio = maxFlux_r{n}/maxFluxWT_r{n};
            
            minRatio = round(minRatio,6);
            maxRatio = round(maxRatio,6);
                  
            % WT flux is 0
            if minFluxWT_r{n} == 0 && minFlux_r{n} ~= 0
                minRatio = 'up';
            end
            if maxFluxWT_r{n} == 0 && maxFlux_r{n} ~= 0
                maxRatio = 'up';
            end
            
            % Mutant flux is 0
            if minFlux_r{n} == 0 &&  minFluxWT_r{n} ~= 0
                minRatio = 'down';
            end
            if maxFlux_r{n} == 0 && maxFluxWT_r{n} ~= 0
                maxRatio = 'down';
            end
            
            % Both are 0
            if minFlux_r{n} == 0 &&  minFluxWT_r{n} == 0
                minRatio = 1;
            end
            if maxFlux_r{n} == 0 && maxFluxWT_r{n} == 0
                maxRatio = '1';
            end
            
            MinFluxRatio{n} = minRatio;
            MaxFluxRatio{n} = maxRatio;
        end
        
        newData = [data, minFluxWT_r, maxFluxWT_r, MinFluxRatio, MaxFluxRatio];
        temp = split(S(i).name,".");
        resultFileName = strcat(temp(1),'_flux_shifts.xls');
        fullResultFilePath = strcat('..\Results post-optimization\Flux-shifts\', resultFileName);
        writecell(newData, fullResultFilePath{1});
    end
end

