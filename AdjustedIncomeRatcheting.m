function [Income] = AdjustedIncomeRatcheting (Year,AdvisoryFee,BeginingBalance,RachetingSpendingChange,IncomeAmount,AdjustedInflation, RatchetingSuccess)

if BeginingBalance == 0
    Income = 0;
else
    if RatchetingSuccess == 1
        Income = min(IncomeAmount*(1+AdjustedInflation)*(1+RachetingSpendingChange),BeginingBalance-AdvisoryFee);
    else
        Income = min(IncomeAmount*(1+AdjustedInflation), BeginingBalance-AdvisoryFee);
    end
    
    if mod(Year-1,12) == 0
       fprintf('The withdrawl for this month based on the Ratcheting spending strategy is %d ',Income);
       UserDecision = input('Enter 1 to spend this ammount of money from the portfolio or choose 0 to select a different ammount: ');
       if  UserDecision == 0
           fprintf('The remaining balance in the portfolio (after taxes) is %d pounds ',BeginingBalance - AdvisoryFee);
           DesiredIncome = input('Please specify the desired Income ammount: ');
           Income = min( DesiredIncome , BeginingBalance - AdvisoryFee);
      end
    end
   
end 
end
      
      
    
    



