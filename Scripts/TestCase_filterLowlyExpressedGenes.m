% GET TRANSCRIPTOMICS DATA
% SRR8994357_WT, SRR8994358_WT, SRR8994359_WT (wild type no stress)
% SRR8994378_S47D, SRR8994379_S47D, SRR8994380_S47D (S47D no stress)a
sheetName = 'SRR8994357_WT';
filename = '..\Data\TranscriptomicsData.xlsx';
gt1 = 30; % Global T1 threshold used for this testcase

% Read transcriptomics data
transcriptomicsData=readtable(filename,'Sheet',sheetName);
geneIds = transcriptomicsData.Geneid;
expressionValues = transcriptomicsData.Data;

% Get a list of lowly expressed genes
lowlyExpressedGenes = findGenesBelowThreshold(gt1, geneIds, expressionValues);

% Save results
excelFileName = convertStringsToChars(strcat('../Results non-optimization/Lowly expressed genes/', sheetName, '_GT1_', string(gt1), '.xls'));
writecell(lowlyExpressedGenes,excelFileName);
