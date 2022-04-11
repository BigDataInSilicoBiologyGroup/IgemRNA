function saveResultTable(folderName, fileName, data, headers)
    
    if ~exist(folderName, 'dir')
           mkdir(folderName)
    end

    dataWithHeaders = [headers; data];
    T = table(dataWithHeaders);
    writetable(T, string(strcat(folderName,fileName)),'WriteVariableNames',false);
end