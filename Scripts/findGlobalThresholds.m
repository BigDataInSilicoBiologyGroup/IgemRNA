
function [globalThresholds, genesToDelete] = findGlobalThresholds(data, thresholdingApproach, glower, gupper)
    
    globalThresholds = cell(2,length(data));
    genesToDelete = cell(1,length(data));

    switch thresholdingApproach
        % One global threshold per dataset
        case {1, 2}
            for i=1:1:length(data)
                t = calculatePercentile(cell2mat(data{i}(:,2)),glower);
                globalThresholds{1,i} = t;
                genesToDelete{i} = findGenesBelowThreshold(t, data{i}(:,1), data{i}(:,2));
            end
        % Two global thresholds per dataset
        case 3
            for i=1:1:length(data)
                t1 = calculatePercentile(cell2mat(data{i}(:,2)),glower);
                t2 = calculatePercentile(cell2mat(data{i}(:,2)),gupper);
                globalThresholds{1, i} = t1;
                globalThresholds{2, i} = t2;
                genesToDelete{i} = findGenesBelowThreshold(t1, data{i}(:,1), data{i}(:,2));
            end
        otherwise
            disp('No such option')
    end
end