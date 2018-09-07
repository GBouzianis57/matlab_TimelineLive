function [Income] = AdjustedIncomeRatcheting (AdvisoryFee,BeginingBalance,RachetingSpendingChange,IncomeAmount,AdjustedInflation, RatchetingSuccess)

if BeginingBalance == 0
    Income = 0;
else
    if RatchetingSuccess == 1
        Income = min(IncomeAmount*(1+AdjustedInflation)*(1+RachetingSpendingChange),BeginingBalance-AdvisoryFee);
    else
        Income = min(IncomeAmount*(1+AdjustedInflation), BeginingBalance-AdvisoryFee);
    end
end

end
