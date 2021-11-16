function value = calculatePercentile(expressionValues, k)
    if ~isempty(k)
        C = unique(expressionValues,'sorted');
        n = length(C); % try with original length as well
        Lp =  (n+1) * (str2double(k)/100); % Position Locator
        if round(Lp) == Lp
            value = C(Lp);
        else
            value = round(C(floor(Lp)) + (Lp-floor(Lp)) * (C(ceil(Lp))-C(floor(Lp))));
        end
    else 
        value = k; % empty
    end
end