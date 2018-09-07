function [Income] = AdjustedIncomeFloorCeiling (IncomeAmount,Year,AdjustedInflation,AdvisoryFee,Withdrawl,BeginingBalance,Floor,Ceiling)

if BeginingBalance == 0
    Income = 0;
else

        if IncomeAmount*(1+AdjustedInflation) < Withdrawl*(1+Floor) && (mod(Year-1,12) == 0)
            Income = min(Withdrawl*(1+Floor)*(1+AdjustedInflation), BeginingBalance - AdvisoryFee);
        elseif IncomeAmount*(1+AdjustedInflation) > Withdrawl*(1+Ceiling) && (mod(Year-1,12) == 0)
            Income = min(Withdrawl*(1+Ceiling)*(1+AdjustedInflation), BeginingBalance - AdvisoryFee);
        else
            Income = min(IncomeAmount*(1+AdjustedInflation), BeginingBalance - AdvisoryFee);
        end
    
end

end

    

    
