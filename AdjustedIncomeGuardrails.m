function [Income] = AdjustedIncomeGuardrails ( Year,WithdrawlRate, IncomeAmount, AdjustedInflation, BeginingBalance, AdvisoryFee , PRTrigger,PRSpendingChange,CPTrigger,CPSpendingChange,CPUse,PRUse)

            %Advanced Decision Rule - Guardrails
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
            end
                    
end
