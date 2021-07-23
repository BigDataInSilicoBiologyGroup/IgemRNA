function value = calculatePercentile(expressionValues, k)
    C = unique(expressionValues,'sorted');
    n = length(C); % try with original length as well
    Lp =  (n+1) * k; % Position Locator
    if round(Lp) == Lp
        value = C(Lp);
    else
        value = C(floor(Lp)) + (Lp-floor(Lp)) * (C(ceil(Lp))-C(floor(Lp)));
    end
end