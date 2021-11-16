function saveResults(folderName, fileName, data)
    
    if ~exist(folderName, 'dir')
           mkdir(folderName)
    end
    
    T = table(data);
    % TODO: Format headers
    writetable(T, string(strcat(folderName,fileName)));

%     writecell(data,strcat(folderName,fileName));
end