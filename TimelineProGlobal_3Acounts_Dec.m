
%% Data Series %%

%OPEN THE EXCEL AssetClassesReturnsMonthly while reading the Data Series
%Section


%ClassesReturns contains the returns of the asset classes
%ClassesNames contains the names of the asset classes
[ClassesReturns, ClassesNames] = xlsread('AssetClassesReturnsMonthly','Returns3','D3:K100'); 



%Year
Year = xlsread('AssetClassesReturnsMonthly','Returns3','C4:C100'); %Year
%Data for the Inflation
InflationData = xlsread('AssetClassesReturnsMonthly','Returns3','N4:N100'); 


%InflationData = ((InflationData == 0)*0.000001) + InflationData;


MonthNumero = xlsread('AssetClassesReturnsMonthly','Returns3','B4:B100'); 
YearNumero = xlsread('AssetClassesReturnsMonthly','Returns3','A4:A100');

%Number of Classes that we are using
NumClasses = size( ClassesReturns, 2);
%Give an ID to every class
ClassID = [1 2 3 4 5 6 7 8];
%Months of Data that we are using
YearsOfData = size( ClassesReturns, 1);

%% Initial Data - Inputs %%

AccountId = 1:3; % Number of different accounts, User decides - IN
AccountAllocation = [0.6 0.3 0.1]; % Allocate the initial capital to the accounts - IN

%Years of Withdrawl - IN
DefaultAge = 95;
CurrentAge = 65;
YearsOfWithdrawl = DefaultAge - CurrentAge; 
 

%Initial Investent in total - IN
InitialInvestment = 100000;
%Initial Investent to every account
InitialInvestmentAccount = InitialInvestment * AccountAllocation;
%Withdrawl amount in total - IN
TotalWithdrawl = 8000/12;


%Scaled Income for different retirement phases
Scale = 1;
ScaleIncome = [4000/12 3000/12];
ScaleIncomeAge = [75 85];
ScaleIncomeAdjusted = 1; % 1 or 0 to adjust scale income for inflation or not

ScaleInflation = 1; % 1 or to 0 to change the inflation rule for the different income scale
ScaleWithdrawl = 1;% 1 to change change the withdrawl rule for the different income scale
ScaleWithdrawlRule = [1 2];
ScaleInflationRule = [4 2];

ContributionAccount = [1 0 1];
ContributionStartAge{1} = 75;
ContributionStartAge{2} = [80 82 84];
ContributionStartAge{3} = [76 85];
ContributionAmmount{1} = 2000;
ContributionAmmount{2} = [10000 15000 13000];
ContributionAmmount{3} = [14000 2000];
ContributionAdjust = [1 0 1];


%WithdrawlAccountDrain - IN. Determine the order of the accounts that the 
%income will be taken. If the user choose
%to invest in two accounts then obviously the variable will be
%WithdrawlAccountDrain = [x y]. If the user choose 1 and 1 then the income
%is evenly taken according to the account allocation. If the user choose 1
%and 2, then the income will be taken from the first account untill it runs
%out of money and then it will be taken from the second account
WithdrawlAccountDrain = [2 2 1]; % -IN
%WithdrawlRate
WithdrawlRate = (TotalWithdrawl / InitialInvestment);


%Ongoing Charge for every account - IN. Again if the user choose to invest in 
%two accounts and not in three then this variable should be OngoingCharge = [x y]  
Charge = 1; %0 for percentage 1 for ammount
ChargeAdjust = 1; %1 to adjust tax with inflation, 0 for not
OngoingChargePercentage = [0.01/12 0.01/12 0.01/12];
OngoingChargeAmmount = [500/12 500/12 500/12];

AccountTaxPercentage = [0.2/12 0.3/12 0.1/12];
IncomeTaxPercentage = [0.4/12 0.2/12 0.2/12];

if Charge == 0
    OngoingCharge = OngoingChargePercentage;
else
    OngoingCharge = OngoingChargeAmmount;
end

%Legacy Target of the portfolio - IN
LegacyAdjust = 1; %0 not to adjust legacy with inflation, 1 to adjust legacy with inflation
LegacyTarget = 1; 

%Initializing the matrices with the asset allocation -IN. Again if the user choose to invest in 
%two accounts and not in three then this variable should be
%InitialPercentageAllocation = [a1 b1 c1 d1 e1 ; a2 b2 c2 d2 e2].
InitialPercentageAllocation = [0.8 0.05 0 0 0.05 0.1 0 0;0 0.6 0.4 0 0 0 0 0;0.4 0.3 0 0 0.15 0.15 0 0]; 

%% Allocating the capital of every account to the classes %%

%Initializing the dimensions of the matrix that contains the amount of money
%invested in every class of every account
InitialAccountAllocation = zeros(size(AccountId,2),size(ClassesReturns,2));

for NumberOfAccount = 1:numel(AccountId)
   InitialAccountAllocation(NumberOfAccount,:) = InitialInvestmentAccount(NumberOfAccount)*InitialPercentageAllocation(NumberOfAccount,:);
end

%% Inflation Adjustment %%

%NOTE THAT THE INFLATION RULE IS THE SAME FOR ALL ACOUNTS


%Setting the Inflation Adjustment rule (Fixed - Inflation adjusted - Guyton - Cap and Collar - decrease X%
% 0 for no inflation, 1 for adjusted inflation, 2 for Guyton inflation adjustment, 3 for Cap and Collar and 4 for inflation -X%
InflationRule = 3; % -IN

%Setting the preferences for the inflation adjustment
%if InflationRule == 3
    %If the user chooses Cap and Collar inflation adjustment rule he must set the Cap and the Collar
    Cap = 0.05; % - IN
    Collar = 0;  % -IN 
%elseif InflationRule == 4
    %If the user chooses -X% inflation adjustment rule he must set the percentage
    PercentageAdjusted = -0.01; % -IN 
%end
 
%% Withdrawl Strategy %%

%NOTE THAT THE WITHDRAWAL STRATEGY IS THE SAME FOR ALL ACOUNTS AND IT IS
%APPLIED IN THE TOTAL INCOME AND NOT IN THE INCOME TAKEN FROM EVERY
%ACCOUNT.

%Setting the Withdrawl rule (Guardrails - Racheting - Floor & Ceiling)
% 0 for none, 1 for Guardrails, 2 for Racheting and 3 for Floor & Ceiling
WithdrawlRule = 0;  % -IN

%Setting the preferences for the withdrawl Strategy
%if WithdrawlRule == 1

    %If the user chooses guardrails withdrawl strategy, must set the following:
    
    %Prosperity Rule Trigger
    PRTrigger = -0.20; % -IN
    %Prosperity Rule Spending Change
    PRSpendingChange = 0.05; % -IN
    %Prosperity Rule Use
    PRUse = 12; % - IN
    
    %Capital Preservation Rule Trigger
    CPTrigger = 0.20; % -IN
    
    %Capital Preservation Rule Spending Change
    CPSpendingChange = -0.05; % -IN
    
    %Capital Preservation Rule Use
    CPUse = 12; % - IN
    
%elseif WithdrawlRule == 2

    %If the user chooses racheting withdrawl strategy, must set the following:
    
    %Wealth Treshold for the Ratcheting rule
    WealthTreashold = 1.5; % - IN
    
    %Spending change for the Ratcheting rule
    RachetingSpendingChange = 0.05; % - IN
    
    %Years of conservative successes so that Ratcheting rule will be applied
    YearsTarget = 3; % - IN
    
%elseif WithdrawlRule == 3

    %If the user chooses floor & ceiling withdrawl strategy, must set the following:
    
    %Floor 
    Floor = -0.2; % - IN
    
    %Ceiling
    Ceiling = 0.2; % - IN
%end
    
%% Withdrawl Options - Order %%

%Setting the Withdrawl order. The use must choose for every account,
%from which classes he will receive the income.
% 0 for even withdrawl, 1 for withdrawing only from the best performing asset,
% 2 for withdrawing only from the worst performing asset and 3 for draining
%in a given order. 4 for buckets. If the user choose to invest in two accounts instead of
%three then this variable will be WithdrawlOrder = [x y];

WithdrawlOrder = [1 2 3]; % -IN

%Setting the preferences for the withdrawl order for every account

%if WithdrawlOrder == 3
    %If the user choose the given order draining option then he must define
    %the order for every account. If the user chooses to invest in two
    %accounts instead of three then the variable will be 
    %DrainOrder = [a1 b1 c1 d1 e1 ; a2 b2 c2 d2 e2 ]. 
    DrainOrder = [4 1 5 5 2 3 5 5;3 2 4 4 1 1 4 4;4 1 5 5 2 3 5 5]; % -IN
    
 %if WithdrawlOrder == 4
    DrainOrderBuckets = [4 1 7 8 2 3 5 6;4 1 7 8 2 3 5 6;4 1 7 8 2 3 5 6];
    DefaultClass = [4 4 4]; 
%end

%% Rebalancing Rules %%

%Setting the type of portfolio rebalancing for every account.
%%
% 0 for no rebalancing, 1 for time, 2 for rebalancing based on class performance,
% 3 for Harvesting rule, 4 for class boundary rebalancing and 5 for portfolio percentage allocation
% Again if the user choose to invest in two accounts rather than in three
% then the variable will be RebalancingRule = [x y].
RebalancingRule = [2 3 4];  % - IN 

%Setting the rebalancing preferences


%if RebalancingRule == 1

    %If the user chooses to rebalance through time then he must defines the
    %frequency (months) at which we will rebalance
    % Again if the user choose to invest in two accounts then this variable
    % should be Frequency = [x y]
   Frequency = [12 12 12]; % - IN
    
%elseif RebalancingRule == 2

    %If the user chooses to rebalance based on class performance he must
    %choose the determinand classes and if he is going to rebalance on positive or
    %negatve periods
    % 0 for asset class not to be watched,  for rebalncing on years with positive returns and -1 for negative returns
    % Again if the user decides to invest in one account for example then
    % the variable will be PerformanceRebalancing = [a b c d e]; 
    PerformanceRebalancing = [-1 -1 0 0 0 0 0 0;0 0 0 0 0 0 0 0;1 0 0 0 0 0 0 0]; % -IN

%elseif RebalancingRule == 3

    %If the user decides to "rebalance" based on the harvesting rule then
    %the user must define the following:
    
    %Set from which classes to sell
    % The user can choose up to two classes from which to sell. If he
    % chooses 0 for one of those the he will sell only from one class. In
    % that case. Again if the user invests in two accounts then the variable would 
    %be SellClasses = [x y; z k];
    SellClasses = [1 0;2 0;1 6]; % -IN
    
    %Then the user must choose from which class to buy. If the user selects
    %this rule he must definately choose a class to buy. 0 is not permitted
    %as a value
    BuyClasses = [2 3 2]; % -IN
    
    %For the harvesting rule, the user must set for every class that he dicedes to sell
    %an upper limit in real terms. It must be always greater than 1 (100%)
    IIDifference = [1.05 1.05 1.10]; % -IN
    
 %elseif RebalancingRule == 4
    
    %If the user decide to rebalance based on a boundary for every class
    %then he must define the max value away from the initial value of the class.
    %The defaut value is 1 (100%). If the user wants to rebalance based on a boundary of the 
    %portfolio's value then he must set the same boundary for every class
    %that participates in his portfolio.
    %If the user invests in two portfolios and rather than three then the
    %variable should be: ClassesBoundaries = [a1 b1 c1 d1 e1;a2 b2 c2 d2
    %e2]. 
    ClassesBoundaries = [0.3 1 1 1 1 1 1 1;0.3 1 1 1 1 1 1 1;0.3 0.2 1 1 0.2 0.2 1 1;]; % -IN
    
    

 %elseif RebalancingRule == 5
   
    %If the user wants to rebalance based on a boundary of a class as
    % a percentage of portfolio's total value then he must define these
    % boundaries for every class that he invested in.
    
    ClassesPVBoundary = [1 0.5 1 1 1 1 1 1;0.7 1 1 1 1 0.3 1 1;0.7 1 1 1 1 0.3 1 1];  % -IN
           
%end

%% Adjusting the gliding path for every account %%

%Initializing the dimensions of the matrices for the for the gliding adjustment and gliding
%end goal for every class of every account

%Setting the Glidiing path rule - IN. Again if the user choose to invest in 
%two accounts and not in three then this variable should be GlidingRuleAccount = [x y]
GlidingRuleAccount = [1 0 0];


GlidingAdjustment = zeros(size(AccountId,2),size(ClassesReturns,2));
GlidingEnd = zeros(size(AccountId,2),size(ClassesReturns,2));
NOGlidingAdjustment = [0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0];
NOGlidingEnd = [0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0];
%If GlidingRuleAccount = 1 choose:
YesGlidingAdjustment = [-0.02/12 0 0 0 0 0.02/12 0 0;0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0];
YesGlidingEnd = [0.6 0.05 0 0 0.05 0.3 0 0;0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0];

for NumberOfAccount = 1:numel(AccountId)
   
    if  GlidingRuleAccount(NumberOfAccount) == 0 || ((GlidingRuleAccount(NumberOfAccount) == 1) && ( ((RebalancingRule(NumberOfAccount) == 0) || (RebalancingRule(NumberOfAccount) == 3)) || (sum(YesGlidingAdjustment(NumberOfAccount,:))~=0) || (sum(InitialPercentageAllocation(NumberOfAccount,:)~=0)==1) ))
        %If the user choose not to use gliding path then both the
        %adjustment and the end goal is set to zero for every class
        
        GlidingAdjustment(NumberOfAccount,:) = NOGlidingAdjustment(NumberOfAccount,:); %Gliding path adjustment
        GlidingEnd(NumberOfAccount,:) = NOGlidingEnd(NumberOfAccount,:);
    else
        %If the user chooses to adjust a gliding path in one of his account
        %or more than of his accounts then he as to decide the adjustment
        %and the end goal for every class of every account
       
        GlidingAdjustment(NumberOfAccount,:) = YesGlidingAdjustment(NumberOfAccount,:);
        GlidingEnd(NumberOfAccount,:) = YesGlidingEnd(NumberOfAccount,:);
    end
end

%% IMPLEMENTATION %%
%The following function does all the calculations
AllocationGP = cell(1,numel(AccountId));

for Account = AccountId
%We calculate the gliding path adjusted allocation of every class in every portfolio each month for every scenario.
%NOTE THAT FOR EVERY PORTFOLIO WE GIVE DIFFERENT INPUT VALUES.
AllocationGP{Account} = AdjustingGlidingPath(ClassesReturns(:,:),InitialPercentageAllocation(Account,:),GlidingAdjustment(Account,:),GlidingEnd(Account,:)); 
end

[WOrder,ContributionToEveryClass,AnnualSimpleInflationIndex,AnnualAdjustedInflation,AnnualInflationData,Rebalancing, StartValue, CurrentAllocation, AdjustedInflation, InflationIndex, BeginingBalance, IncomeFromAccount, EndBalance, HarvestAmount, AdvisoryFee,WithdrawalFromEveryClass,SimpleInflationIndex, OldLevels,TotalBeginingBalance,TotalEndBalance,TotalIncome] = calc(AccountTaxPercentage, IncomeTaxPercentage,ContributionAccount, ContributionStartAge, ContributionAmmount, ContributionAdjust,ChargeAdjust,Charge,ScaleInflation, ScaleWithdrawl, ScaleWithdrawlRule, ScaleInflationRule,CurrentAge,Scale,ScaleIncome, ScaleIncomeAge, ScaleIncomeAdjusted,ClassID,InitialInvestmentAccount,AccountAllocation,WithdrawlAccountDrain,ClassesReturns,TotalWithdrawl,WithdrawlOrder,DrainOrder,OngoingCharge,WithdrawlRule,Cap,PercentageAdjusted,Collar ,InflationRule,AllocationGP,ClassesPVBoundary,SellClasses,BuyClasses,IIDifference,InflationData,RebalancingRule,PerformanceRebalancing,InitialInvestment,Frequency,InitialAccountAllocation,ClassesBoundaries, InitialPercentageAllocation, WithdrawlRate,PRTrigger,PRSpendingChange,PRUse,CPTrigger,CPSpendingChange,CPUse, WealthTreashold,RachetingSpendingChange,Floor,Ceiling,AccountId,YearsTarget, DrainOrderBuckets, DefaultClass, ClassesNames) ;

