source = 'SRR8994357_WT';
target = 'SRR8994378_S47D';
trDataPath = 'Data/TranscriptomicsData.xlsx';
try
    findUpDownRegulatedGenes(source, target, trDataPath);
    disp('findUpDownRegulatedGenes.m... OK');
catch e
    disp('findUpDownRegulatedGenes.m... NOK');
    disp(e);
end