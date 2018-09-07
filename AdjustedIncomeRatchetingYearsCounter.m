function [CountSuccess,RatchetingSuccess] = AdjustedIncomeRatchetingYearsCounter (Year,BeginingBalance, WealthTreashold, InitialInvestment, YearsTarget, CSR)

        if  (mod(Year-1,12) == 0)
            
           if BeginingBalance >= WealthTreashold*InitialInvestment 
               
                CountSuccess = CSR + 1;    
           else 
                CountSuccess = 0;
           end
           
        else
            
            CountSuccess = CSR;
        end
        
        if CountSuccess == YearsTarget
            RatchetingSuccess = 1;
            CountSuccess = 0;
        else
            RatchetingSuccess = 0;           
        end


end
