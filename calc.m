function [TotalAccountFee,WOrder,ContributionToEveryClass,AnnualSimpleInflationIndex,AnnualAdjustedInflation,AnnualInflationData,Rebalancing, StartValue, CurrentAllocation, AdjustedInflation, InflationIndex, BeginingBalance, IncomeFromAccount, EndBalance, HarvestAmount, AdvisoryFee,WithdrawalFromEveryClass,SimpleInflationIndex, OldLevels,TotalBeginingBalance,TotalEndBalance,TotalIncome] = calc(AccountTaxPercentage, IncomeTaxPercentage,Contribution, ContributionStartAge, ContributionAmmount, ContributionAdjust,ChargeAdjust,Charge,ScaleInflation, ScaleWithdrawl, ScaleWithdrawlRule, ScaleInflationRule,CurrentAge,Scale,ScaleIncome, ScaleIncomeAge, ScaleIncomeAdjusted,ClassID,InitialInvestmentAcc,AccAllocation,WithdrawlAccountDrain,ClassesReturns,Withdrawl,WithdrawlOrder,DrainOrder,OngoingCharge,WithdrawlRule,Cap,PercentageAdjusted,Collar ,InflationRule,AllocationGP,ClassesPVBoundary,SellClasses,BuyClasses,IIDifference,InflationData,RebalancingRule,PerformanceRebalancing,InitialInvestment,Frequency,InitialAllocation,ClassesBoundaries, InitialPercentageAllocation, WithdrawlRate,PRTrigger,PRSpendingChange,PRUse,CPTrigger,CPSpendingChange,CPUse, WealthTreashold,RachetingSpendingChange,Floor,Ceiling,AccountId,YearsTarget, DrainOrderBuckets, DefaultClass, ClassesNames) 

%Returns and Rebalancing excel tab
Rebalancing = zeros(size(ClassesReturns,1),numel(AccountId));
AdjustedInflation = zeros(size(ClassesReturns,1),1);
AnnualAdjustedInflation = zeros(size(ClassesReturns,1),1);
AnnualInflationData = zeros(size(ClassesReturns,1),1);
BeginingBalance = zeros(size(ClassesReturns,1),numel(AccountId));
InflationIndex = zeros(size(ClassesReturns,1),1);
AdvisoryFee = zeros(size(ClassesReturns,1),numel(AccountId));
AccountTax = zeros(size(ClassesReturns,1),numel(AccountId));
IncomeTax = zeros(size(ClassesReturns,1),numel(AccountId));
TotalAccountFee = zeros(size(ClassesReturns,1),numel(AccountId));
EndBalance = zeros(size(ClassesReturns,1),numel(AccountId));
maxDiff = zeros(numel(AccountId),size(ClassesReturns,1));
SimpleInflationIndex = zeros(size(ClassesReturns,1),1);
AnnualSimpleInflationIndex = zeros(size(ClassesReturns,1),1);
TotalIncome = zeros(size(ClassesReturns,1),1);
CountSuccess = zeros(size(ClassesReturns,1),1);
RatchetingSuccess = zeros(size(ClassesReturns,1),1);
TotalBeginingBalance = zeros(size(ClassesReturns,1),1);
TotalEndBalance = zeros(size(ClassesReturns,1),1);
TotalAdvisoryFee = zeros(size(ClassesReturns,1),1);
TotalFee = zeros(size(ClassesReturns,1),1);
IncomeFromAccount = zeros(size(ClassesReturns,1),numel(AccountId));
InitialInvestmentAccount = zeros(size(ClassesReturns,1),numel(AccountId));
AccountAllocation = zeros(size(ClassesReturns,1),numel(AccountId));
AWOrder = zeros(size(ClassesReturns,1),numel(AccountId));

StartValue = cell(1,numel(AccountId));
NewAllocation = cell(1,numel(AccountId));
CurrentAllocation = cell(1,numel(AccountId));
WithdrawalFromEveryClass = cell(1,numel(AccountId));
HarvestAmount = cell(1,numel(AccountId));
OldLevels = cell(1,numel(AccountId));
ContributionToEveryClass = cell(1,numel(AccountId));

for i = 1: numel(AccountId)
    StartValue{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2)+1);
    CurrentAllocation{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
    NewAllocation{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
    WithdrawalFromEveryClass{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
    ContributionToEveryClass{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
    HarvestAmount{i} = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
    OldLevels{i} = zeros(size(ClassesReturns,1), size(ClassesReturns,2)+1);
end

WOrder = cell(1,numel(AccountId));
ContributionOrder = cell(1,numel(AccountId));
for i = 1: numel(AccountId)
    ContributionOrder{i} = ones(size(ClassesReturns,1),size(ClassesReturns,2)); 
    if WithdrawlOrder(i) == 3
        PreferenceDrain = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
        for j = 1:size(ClassesReturns,1)
            PreferenceDrain(j,:) = DrainOrder(i,:);
        end
        WOrder{i} = PreferenceDrain;
    else
        WOrder{i} = WithdrawlOptions(ClassesReturns, WithdrawlOrder(i), DrainOrderBuckets(i,:), DefaultClass(i));
    end
end

    function [NewAllocation,Rebalance , HarvestingAmmount , MaximumDifference] = RebalancingDetermination(RebalancingRule, AllocationGP, ClassesBoundaries, Frequency, ClassesReturns, PerformanceRebalancing, CurrentAllocation, ClassesPVBoundary, SimpleInflationIndex,InitialAllocation,BuyClasses,StartValue,ClassID,SellClasses,IIDifference,i,Id,ClassesNames)
        if RebalancingRule == 4
                [Rebalance,MaximumDifference,NewAllocation] = BoundedRebalance(AllocationGP, CurrentAllocation,ClassesBoundaries, Id, ClassesNames, ClassID);
                 HarvestingAmmount = 0;
        elseif RebalancingRule == 1
                [Rebalance,NewAllocation] = TimeRebalance(Frequency,i, Id, ClassID);
                 HarvestingAmmount = 0;
                 MaximumDifference = 0;
        elseif RebalancingRule == 0
                Rebalance = 0;
                HarvestingAmmount = 0;
                MaximumDifference = 0;
        elseif RebalancingRule == 2  
                [Rebalance,NewAllocation] = PerformanceRebalance(ClassesReturns,PerformanceRebalancing,Id, ClassID);
                HarvestingAmmount = 0;
                MaximumDifference = 0;
        elseif RebalancingRule == 5
                [Rebalance,NewAllocation] = PortfolioBoundedRebalance(CurrentAllocation, ClassesPVBoundary,Id, ClassesNames, ClassID);
                HarvestingAmmount = 0;
                MaximumDifference = 0;
        elseif RebalancingRule == 3 
                [Rebalance,HarvestingAmmount] = HarvestingRebalance(SimpleInflationIndex,InitialAllocation,BuyClasses,StartValue,ClassID,SellClasses,IIDifference,i,Id, ClassesNames);     
                MaximumDifference = 0;
                NewAllocation =0;
        end
    end

    function [AdjustedInflation, AnnualAdjustedInflation] = InflationDetermination(TotalBeginingBalance,TotalEndBalance,InflationRule, InflationData, AnnualInflationData, Cap, Collar, PercentageAdjusted, i)
        if InflationRule == 0
            AdjustedInflation = 0;
            AnnualAdjustedInflation = 0;
        elseif InflationRule == 1 
            AdjustedInflation = InflationData;
            if mod(i-1,12) == 0 && i ~= 1
                AnnualAdjustedInflation = AnnualInflationData(i-1)-1;
            else
                AnnualAdjustedInflation = 0;    
            end
        elseif  InflationRule == 2
            if i == 1
                AdjustedInflation = InflationData;
            else
                AdjustedInflation = GuytonAdjustedInflation(TotalBeginingBalance,TotalEndBalance(i-1),InflationData);
            end
                if mod(i-1,12) == 0 && i ~= 1
                    AnnualAdjustedInflation = GuytonAdjustedInflation(TotalBeginingBalance,TotalEndBalance(i-1),AnnualInflationData(i-1)-1);
                else
                    AnnualAdjustedInflation = 0; 
                end
        elseif InflationRule == 3 
            AdjustedInflation  = CapAndCollarAdjustment(InflationData,Cap,Collar);
            if mod(i-1,12) == 0 && i ~= 1
                AnnualAdjustedInflation = CapAndCollarAdjustment(AnnualInflationData(i-1)-1,Cap,Collar);
            else
                AnnualAdjustedInflation = 0; 
            end
        elseif InflationRule == 4
            AdjustedInflation = PercentageAdjustment(InflationData,PercentageAdjusted);
            if mod(i-1,12) == 0 && i ~= 1
                AnnualAdjustedInflation = PercentageAdjustment(AnnualInflationData(i-1)-1,PercentageAdjusted);
            else
                AnnualAdjustedInflation = 0; 
            end
        end
    end

    function [AccountTax, IncomeTax, AdvisoryFee,TotalAccountFee] = ChargesDetermination(BeginingBalance,AccountTaxPercentage,EndBalance, IncomeTaxPercentage, IncomeFromAccount, OngoingCharge, Charge, ChargeAdjust, AnnualInflationData, AdvisoryFeeOld,i)
       if i==1
            AccountTax = 0;
            IncomeTax = 0;
       else
            if BeginingBalance <= 0
                AccountTax = 0;
                IncomeTax = 0; 
            else
                AccountTax = AccountTaxPercentage*((BeginingBalance-EndBalance(i-1))/EndBalance(i-1))*EndBalance(i-1);
                IncomeTax = IncomeTaxPercentage*IncomeFromAccount(i-1);
            end
            if  AccountTax < 0
                AccountTax = 0;
            end
        end
        if Charge == 0
            AdvisoryFee = OngoingCharge*BeginingBalance;
        elseif Charge == 1
            if ChargeAdjust == 1
               if mod(i-1,12) == 0 && i ~= 1
                    if BeginingBalance <= 0
                            AdvisoryFee = 0;
                    else
                            AdvisoryFee = OngoingCharge*(1 + AnnualInflationData(i-1)-1);
                    end
               elseif mod(i-1,12) == 0 && i == 1
                    if BeginingBalance <= 0
                            AdvisoryFee = 0;
                    else
                            AdvisoryFee = OngoingCharge;
                    end
               else
                    if BeginingBalance <= 0
                            AdvisoryFee = 0;
                    else
                            AdvisoryFee = AdvisoryFeeOld(i-1);
                    end
               end
            else
                if BeginingBalance <= 0
                    AdvisoryFee = 0;
                else
                    AdvisoryFee = OngoingCharge;
                end
            end
        end
           TotalAccountFee = AccountTax + IncomeTax + AdvisoryFee;
        if TotalAccountFee > BeginingBalance
           TotalAccountFee = BeginingBalance;
        end 
    end
        
    function [WithdrawalFromEveryClass, OldLevels, ContributionToEveryClass, EndBalance] = WithdrawalContributionEndBalance(StartValue,CurrentAllocation,IncomeFromAccount,TotalAccountFee,ClassID, WOrder, Contribution, CurrentAge, i, ContributionAdjust, ContributionAmmount, ContributionStartAge, ContributionOrder, AnnualSimpleInflationIndex, BeginingBalance)
         [WithdrawalFromEveryClass, OldLevels] = ClassWithdrawl(StartValue,CurrentAllocation,IncomeFromAccount,TotalAccountFee,ClassID, WOrder);
         if Contribution == 1
            if  sum(((ContributionStartAge - CurrentAge)*12)== i-1 ) == 1
                      if  ContributionAdjust == 0
                            [ContributionToEveryClass,~] = ClassContribute(WithdrawalFromEveryClass,sum(ContributionAmmount.*(((ContributionStartAge - CurrentAge)*12)==i-1)),StartValue,ClassID, ContributionOrder);
                      elseif ContributionAdjust == 1
                            [ContributionToEveryClass,~] = ClassContribute(WithdrawalFromEveryClass,AnnualSimpleInflationIndex*sum(ContributionAmmount.*(((ContributionStartAge - CurrentAge)*12)==i-1)),StartValue,ClassID, ContributionOrder);
                      end
            else
                      ContributionToEveryClass = 0;
            end
         else
                      ContributionToEveryClass = 0;
         end
         EndBalance = BeginingBalance - sum(WithdrawalFromEveryClass) + sum(ContributionToEveryClass);
         if isnan(EndBalance)==1
            EndBalance=0;
         end
         if EndBalance < 0.00000001
            EndBalance = 0;
         end
    end

    function [AnnualInflationData, InflationIndex, SimpleInflationIndex,  AnnualSimpleInflationIndex] = InflationIndices(i,InflationData,AnnualInflationData, InflationIndex, AdjustedInflation, SimpleInflationIndex, AnnualSimpleInflationIndex)
        if i == 1 
            InflationIndex = 1;
            SimpleInflationIndex = 1;
            AnnualSimpleInflationIndex = 1;
            AnnualInflationData = ( 1 + InflationData(i));
        else
            InflationIndex = InflationIndex(i-1) * (1 + AdjustedInflation(i-1)) ;
            SimpleInflationIndex = SimpleInflationIndex(i-1)* (1 + InflationData(i-1));
            if mod(i-1,12) == 0
                AnnualSimpleInflationIndex = AnnualSimpleInflationIndex(i-12)* (1 + AnnualInflationData(i-1)-1);  
            else
                AnnualSimpleInflationIndex = AnnualSimpleInflationIndex(i-1) ;
            end
            if mod(i-1,12) == 0
                AnnualInflationData = (1+InflationData(i));
            else
                AnnualInflationData = AnnualInflationData(i-1) * ( 1 + InflationData(i));
            end
        end
    end

%Value of the classes at the start of the year
for i=1:size(ClassesReturns,1)
    if i==1  
        %Returns and Rebalancing excel tab
        for Id = 1: numel(AccountId)
            StartValue{Id}(i, 1: end -1) = InitialAllocation(Id ,:); 
            StartValue{Id}(i, end) = InitialInvestmentAcc(Id);
            CurrentAllocation{Id}(i,:) = InitialPercentageAllocation(Id ,:);
        end
        
        [AnnualInflationData(i), InflationIndex(i), SimpleInflationIndex(i), AnnualSimpleInflationIndex(i)] = InflationIndices(i,InflationData,AnnualInflationData, InflationIndex, AdjustedInflation, SimpleInflationIndex, AnnualSimpleInflationIndex);
     
        for Id = 1: numel(AccountId)
            [NewAllocation{Id}(i,:),Rebalancing(i,Id) , HarvestAmount{Id}(i,:) , maxDiff(Id,i)] = RebalancingDetermination(RebalancingRule(Id), AllocationGP{Id}(i,:), ClassesBoundaries(Id,:), Frequency(Id), ClassesReturns(i,:), PerformanceRebalancing(Id,:), CurrentAllocation{Id}(i,:), ClassesPVBoundary(Id,:), SimpleInflationIndex,InitialAllocation(Id,:),BuyClasses(Id),StartValue{Id}(i,1:end-1),ClassID,SellClasses(Id,:),IIDifference(Id),i,Id,ClassesNames) ;
        end
 
        [AdjustedInflation(i), AnnualAdjustedInflation(i)] = InflationDetermination(TotalBeginingBalance(i),TotalEndBalance,InflationRule, InflationData(i), AnnualInflationData, Cap, Collar, PercentageAdjusted, i);

        InitialInvestmentAccount(i,:) = InitialInvestmentAcc;
        AccountAllocation(i,:) = AccAllocation;
        
        TotalIncome(i) = Withdrawl;
        
        CountSuccess(i)= 0; %For Ratcheting rule
        RatchetingSuccess(i) = 0; %For Ratcheting rule  

        for Id = 1: numel(AccountId)
            if sum(StartValue{Id}(i, :)) < 0.00000001
                StartValue{Id}(i, :) = 0;
                StartValue{Id}(i, end) = 0;
            end
            BeginingBalance(i,Id) =  StartValue{Id}(i, end);
            [AccountTax(i,Id), IncomeTax(i,Id), AdvisoryFee(i,Id), TotalAccountFee(i,Id)] = ChargesDetermination(BeginingBalance(i,Id),AccountTaxPercentage(Id),EndBalance(:,Id), IncomeTaxPercentage(Id), IncomeFromAccount(:,Id), OngoingCharge(Id), Charge, ChargeAdjust, AnnualInflationData, AdvisoryFee,i);
        end
        
        AWOrder(i,:) = WithdrawlAccountDrain;
        [IncomeFromAccount(i,:)] = AccWithdrawl(TotalAccountFee(i,:),AccountId,InitialInvestmentAccount(i,:),TotalIncome(i),AWOrder(i,:));
            
        for Id = 1: numel(AccountId)
            [WithdrawalFromEveryClass{Id}(i,:), OldLevels{Id}(i,:), ContributionToEveryClass{Id}(i,:), EndBalance(i,Id)] = WithdrawalContributionEndBalance(StartValue{Id}(i,:),CurrentAllocation{Id}(i,:),IncomeFromAccount(i,Id),TotalAccountFee(i,Id),ClassID, WOrder{Id}(i,:), Contribution(Id), CurrentAge, i, ContributionAdjust(Id), ContributionAmmount{Id}(:), ContributionStartAge{Id}(:), ContributionOrder{Id}(i,:), AnnualSimpleInflationIndex(i), BeginingBalance(i,Id));
        end
        
        TotalAdvisoryFee(i) = sum(AdvisoryFee(i,:));
        TotalBeginingBalance(i) = sum(BeginingBalance(i,:));
        TotalFee(i) = sum(TotalAccountFee(i,:));
        TotalEndBalance(i) = sum(EndBalance(i,:));
        
    else
        
        %Returns and Rebalancing excel tab
        for Id = 1: numel(AccountId)
            if Rebalancing(i-1,Id) == 1
                if RebalancingRule(Id) == 3
                    StartValue{Id}(i, 1: end -1) = ((StartValue{Id}(i-1, 1: end -1) - WithdrawalFromEveryClass{Id}(i-1,:) + HarvestAmount{Id}(i-1,:) + ContributionToEveryClass{Id}(i-1,:)).*ClassesReturns(i-1,:)) + (StartValue{Id}(i-1, 1: end -1) - WithdrawalFromEveryClass{Id}(i-1,:)+ HarvestAmount{Id}(i-1,:) + ContributionToEveryClass{Id}(i-1,:)); 
                else
                    if sum(NewAllocation{Id}(i,:)) ~= 0
                        StartValue{Id}(i, 1: end -1) = EndBalance(i-1,Id)* NewAllocation{Id}(i,:) .* ClassesReturns(i-1,:) + EndBalance(i-1,Id)* NewAllocation{Id}(i,:);
                    else
                        StartValue{Id}(i, 1: end -1) = EndBalance(i-1,Id)* AllocationGP{Id}(i-1,:) .* ClassesReturns(i-1,:) + EndBalance(i-1,Id)* AllocationGP{Id}(i-1,:);
                    end
                end
            elseif Rebalancing(i-1,Id) == 0
                StartValue{Id}(i, 1: end -1) = ((StartValue{Id}(i-1, 1: end -1) - WithdrawalFromEveryClass{Id}(i-1,:) + ContributionToEveryClass{Id}(i-1,:)).*ClassesReturns(i-1,:)) + (StartValue{Id}(i-1, 1: end -1) - WithdrawalFromEveryClass{Id}(i-1,:)+ ContributionToEveryClass{Id}(i-1,:));
            end
        for j = 1 : size(ClassesReturns,2)
            StartValue{Id}(i, j) = max(0,StartValue{Id}(i, j));
        end
        StartValue{Id}(i, end) = sum(StartValue{Id}(i, 1: end -1));
        CurrentAllocation{Id}(i,:) = StartValue{Id}(i, 1:end-1) / StartValue{Id}(i, end);   
        end
        
        [AnnualInflationData(i), InflationIndex(i), SimpleInflationIndex(i), AnnualSimpleInflationIndex(i)] = InflationIndices(i,InflationData,AnnualInflationData, InflationIndex, AdjustedInflation, SimpleInflationIndex, AnnualSimpleInflationIndex);
        
        for Id = 1: numel(AccountId) 
            if sum(StartValue{Id}(i, :)) < 0.00000001
                StartValue{Id}(i, :) = 0;
                StartValue{Id}(i, end) = 0;
            end
            BeginingBalance(i,Id) =  StartValue{Id}(i, end);
            [AccountTax(i,Id), IncomeTax(i,Id), AdvisoryFee(i,Id), TotalAccountFee(i,Id)] = ChargesDetermination(BeginingBalance(i,Id),AccountTaxPercentage(Id),EndBalance(:,Id), IncomeTaxPercentage(Id), IncomeFromAccount(:,Id), OngoingCharge(Id), Charge, ChargeAdjust, AnnualInflationData, AdvisoryFee,i);
        end
   
        TotalAdvisoryFee(i) = sum(AdvisoryFee(i,:));
        TotalFee(i) = sum(TotalAccountFee(i,:));
        TotalBeginingBalance(i) = sum(BeginingBalance(i,:));
        AccountAllocation(i,:) = BeginingBalance(i,:) ./ TotalBeginingBalance(i);
        InitialInvestmentAccount(i,:) = BeginingBalance(i,:);
        
        [AdjustedInflation(i), AnnualAdjustedInflation(i)] = InflationDetermination(TotalBeginingBalance(i),TotalEndBalance,InflationRule, InflationData(i), AnnualInflationData, Cap, Collar, PercentageAdjusted, i);
        
        if Scale == 1  
            if  sum(((ScaleIncomeAge - CurrentAge)*12) == i-1)==1 
                WithdrawlRate = sum(ScaleIncome.*(((ScaleIncomeAge - CurrentAge)*12) == i-1))/TotalBeginingBalance(i);
                Withdrawl = sum(ScaleIncome.*(((ScaleIncomeAge - CurrentAge)*12) == i-1));
                if ScaleWithdrawl == 1
                    WithdrawlRule = sum(ScaleWithdrawlRule.*(((ScaleIncomeAge - CurrentAge)*12) == i-1));
                end
                if ScaleInflation == 1
                    InflationRule = sum(ScaleInflationRule.*(((ScaleIncomeAge - CurrentAge)*12) == i-1));
                end
                if ScaleIncomeAdjusted == 1 
                    TotalIncome(i)=  min( sum(ScaleIncome.*(((ScaleIncomeAge - CurrentAge)*12) == i-1))*AnnualSimpleInflationIndex(i), TotalBeginingBalance(i) - TotalFee(i));
                else
                    TotalIncome(i) = min( sum(ScaleIncome.*(((ScaleIncomeAge - CurrentAge)*12) == i-1)), TotalBeginingBalance(i) - TotalFee(i));
                end
            else
                if WithdrawlRule == 0
                    %Income Withdrawal with Inflation Rule
                    TotalIncome(i) = AdjustedIncomeInflation ( TotalIncome(i-1), AnnualAdjustedInflation(i), TotalBeginingBalance(i), TotalFee(i),i);
                elseif WithdrawlRule == 1
                    TotalIncome(i) = AdjustedIncomeGuardrails ( i, WithdrawlRate, TotalIncome(i-1), AnnualAdjustedInflation(i), TotalBeginingBalance(i), TotalFee(i) , PRTrigger,PRSpendingChange,CPTrigger,CPSpendingChange,CPUse,PRUse);
                elseif WithdrawlRule == 2
                    [CountSuccess(i),RatchetingSuccess(i)] = AdjustedIncomeRatchetingYearsCounter (i,TotalBeginingBalance(i), WealthTreashold, InitialInvestment, YearsTarget, CountSuccess(i-1));
                    TotalIncome(i) = AdjustedIncomeRatcheting (i,TotalFee(i),TotalBeginingBalance(i),RachetingSpendingChange,TotalIncome(i-1),AnnualAdjustedInflation(i),RatchetingSuccess(i));
                elseif WithdrawlRule == 3  
                    TotalIncome(i) = AdjustedIncomeFloorCeiling (TotalIncome(i-1),i,AnnualAdjustedInflation(i),TotalFee(i),Withdrawl,TotalBeginingBalance(i),Floor,Ceiling);
                end
            end
        else
            if WithdrawlRule == 0
                %Income Withdrawal with Inflation Rule
                TotalIncome(i) = AdjustedIncomeInflation ( TotalIncome(i-1), AnnualAdjustedInflation(i), TotalBeginingBalance(i), TotalFee(i),i);
            elseif WithdrawlRule == 1
                TotalIncome(i) = AdjustedIncomeGuardrails ( i, WithdrawlRate, TotalIncome(i-1), AnnualAdjustedInflation(i), TotalBeginingBalance(i), TotalFee(i) , PRTrigger,PRSpendingChange,CPTrigger,CPSpendingChange,CPUse,PRUse);
            elseif WithdrawlRule == 2
                [CountSuccess(i),RatchetingSuccess(i)] = AdjustedIncomeRatchetingYearsCounter (i,TotalBeginingBalance(i), WealthTreashold, InitialInvestment, YearsTarget, CountSuccess(i-1));
                TotalIncome(i) = AdjustedIncomeRatcheting (i,TotalFee(i),TotalBeginingBalance(i),RachetingSpendingChange,TotalIncome(i-1),AnnualAdjustedInflation(i),RatchetingSuccess(i));
            elseif WithdrawlRule == 3  
                TotalIncome(i) = AdjustedIncomeFloorCeiling (TotalIncome(i-1),i,AnnualAdjustedInflation(i),TotalFee(i),Withdrawl,TotalBeginingBalance(i),Floor,Ceiling);
            end
        end
   
        AWOrder(i,:) = WithdrawlAccountDrain;
       [IncomeFromAccount(i,:)] = AccWithdrawl(TotalAccountFee(i,:),AccountId,InitialInvestmentAccount(i,:),TotalIncome(i),AWOrder(i,:));
        
        for Id = 1: numel(AccountId)
            [WithdrawalFromEveryClass{Id}(i,:), OldLevels{Id}(i,:), ContributionToEveryClass{Id}(i,:), EndBalance(i,Id)] = WithdrawalContributionEndBalance(StartValue{Id}(i,:),CurrentAllocation{Id}(i,:),IncomeFromAccount(i,Id),TotalAccountFee(i,Id),ClassID, WOrder{Id}(i,:), Contribution(Id), CurrentAge, i, ContributionAdjust(Id), ContributionAmmount{Id}(:), ContributionStartAge{Id}(:), ContributionOrder{Id}(i,:), AnnualSimpleInflationIndex(i), BeginingBalance(i,Id));
        end
        
        TotalEndBalance(i) = sum(EndBalance(i,:));
        
        for Id = 1: numel(AccountId)
            [NewAllocation{Id}(i,:), Rebalancing(i,Id) , HarvestAmount{Id}(i,:) , maxDiff(Id,i)] = RebalancingDetermination(RebalancingRule(Id), AllocationGP{Id}(i,:), ClassesBoundaries(Id,:), Frequency(Id), ClassesReturns(i,:), PerformanceRebalancing(Id,:), CurrentAllocation{Id}(i,:), ClassesPVBoundary(Id,:), SimpleInflationIndex,InitialAllocation(Id,:),BuyClasses(Id),StartValue{Id}(i,1:end-1),ClassID,SellClasses(Id,:),IIDifference(Id),i,Id,ClassesNames) ;
        end
    end
    
    comet(TotalEndBalance(1:i));
    
end

end




