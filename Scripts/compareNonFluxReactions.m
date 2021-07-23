threshold = 0;
% Non-flux reactions data
dest = '..\Results\Non-flux reactions\*S47D*.xls';
S = dir(dest);
count = length(S);

% Wild Type non-flux reactions data
destWT = '..\Results\Non-flux reactions\*WT*.xls';
WT = dir(destWT);

sheetName = 'Common_WT';
filename = strcat(WT.folder, '\', WT.name);
[numbers, text, dataWT] = xlsread(filename,sheetName);

resultAll = {};

for i=1:1:length(S)
    if ~contains(S(i).name,'WT')
        nameParts = split(S(i).name,"_");
        org = strrep(nameParts(2),'.xls','');
        
        sheetName = char(strcat('Common_', org(1,1)));
        filename = strcat(S(i).folder, '\', S(i).name);
        [numbers, text, data] = xlsread(filename,sheetName);
        
        result = {};
        result(1,:) = data(1,:); % copy headers
        counter = 2;
        
        for n=2:1:size(data,1)
            reaction = data(n,1);
            found = 0;
            for k=2:1:length(dataWT)
                if string(dataWT(k,1)) == string(reaction)
                    found = 1;
                end
            end
            
            if found == 0
                result(counter,:) = data(n,:);
                counter = counter + 1;
            end
        end
        
        resultAll{i} = result;
        xlswrite(filename, result, 'Common_Active_In_WT', 'A1');
    end
end
