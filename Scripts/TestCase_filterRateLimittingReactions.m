phenotype = 'WT';
try
    filterRateLimittingReactions(phenotype);
    disp('filterRateLimittingReactions.m... OK');
catch e
    disp('filterRateLimittingReactions.m... NOK');
    disp(e);
end