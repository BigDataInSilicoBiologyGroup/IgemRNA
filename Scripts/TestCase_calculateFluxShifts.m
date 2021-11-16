source = cell(1,1);
target = cell(1,1);
source{1} = 'SRR8994357_WT';
target{1} = 'SRR8994378_S47D';
try
    calculateFluxShifts(source, target);
    disp('calculateFluxShifts.m... OK');
catch e 
    disp('calculateFluxShifts.m... NOK');
    disp(e);
end