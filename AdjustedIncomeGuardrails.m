function [Income] = AdjustedIncomeGuardrails ( Year,WithdrawlRate, IncomeAmount, AdjustedInflation, BeginingBalance, AdvisoryFee , PRTrigger,PRSpendingChange,CPTrigger,CPSpendingChange,CPUse,PRUse)

if BeginingBalance == 0
    Income = 0;
else
    if IncomeAmount*(1+AdjustedInflation)/ BeginingBalance < WithdrawlRate*(1+ PRTrigger) && (mod(Year-1,12) == 0)
        Income =  min((1+ PRSpendingChange)*IncomeAmount*(1+AdjustedInflation),BeginingBalance - AdvisoryFee );
    elseif (IncomeAmount*(1+AdjustedInflation)/ BeginingBalance > WithdrawlRate*(1+CPTrigger)) && (Year <= CPUse*12) && (mod(Year-1,12) == 0)
        Income = min( (1 + CPSpendingChange)*IncomeAmount*(1 + AdjustedInflation), BeginingBalance - AdvisoryFee );
    else
        Income = min(IncomeAmount*(1+AdjustedInflation),BeginingBalance - AdvisoryFee );
    end

    fprintf('The withdrawl for this month based on the Guardrails spending strategy is %d ',Income);
  
    UserDecision = input('Enter 1 to spend this ammount of money from the portfolio or choose 0 to select a different ammount: ');
  
    if  UserDecision == 0
      fprintf('The remaining balance in the account (after taxes) is %d pounds ',BeginingBalance - AdvisoryFee);
      
      DesiredIncome = input('Please specify the desired Income ammount: ');
      
      Income = min( DesiredIncome , BeginingBalance - AdvisoryFee);
      
    end
                 
end                 
end
