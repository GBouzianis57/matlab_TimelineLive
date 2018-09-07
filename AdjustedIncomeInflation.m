function [Income] = AdjustedIncomeInflation ( IncomeAmount, AdjustedInflation, BeginingBalance, AdvisoryFee)
  
  %Income Withdrawal with Inflation Rule
  Income = min( IncomeAmount * (1 + AdjustedInflation), BeginingBalance - AdvisoryFee);
   
end
