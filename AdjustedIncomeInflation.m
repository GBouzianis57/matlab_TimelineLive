function [Income] = AdjustedIncomeInflation ( IncomeAmount, AdjustedInflation, BeginingBalance, AdvisoryFee,Year)
  
  if BeginingBalance == 0
    Income = 0;
  else
  %Income Withdrawal with Inflation Rule
    Income = min( IncomeAmount * (1 + AdjustedInflation), BeginingBalance - AdvisoryFee);
    
    if mod(Year-1,12) == 0
        fprintf('The adjusted inflation withdrawl for this month is %d ',Income);
        UserDecision = input('Enter 1 to spend this ammount of money from the portfolio or choose 0 to select a different ammount: ');
        if  UserDecision == 0
            fprintf('The remaining balance in the account (after taxes) is %d pounds ',BeginingBalance - AdvisoryFee);
            DesiredIncome = input('Please specify the desired Income ammount: ');
            Income = min( DesiredIncome , BeginingBalance - AdvisoryFee);
        end
    end
    
  end
  
end
