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

        fprintf('The withdrawl for this month based on the Floor & Ceiling spending strategy is %d ',Income);
  
        UserDecision = input('Enter 1 to rspend this ammount fo money from the portfolio or choose 0 to select a different ammount: ');
  
        if  UserDecision == 0
            fprintf('The remaining balance in the account (after taxes) is %d pounds ',BeginingBalance - AdvisoryFee);
      
            DesiredIncome = input('Please specify the desired Income ammount: ');
      
            Income = min( DesiredIncome , BeginingBalance - AdvisoryFee);

        end

end

end

    

    
