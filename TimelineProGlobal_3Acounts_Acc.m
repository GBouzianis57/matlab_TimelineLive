
%% Data Series %%

%OPEN THE EXCEL AssetClassesReturnsMonthly while reading the Data Series
%Section


%ClassesReturns contains the returns of the asset classes
%ClassesNames contains the names of the asset classes
[ClassesReturns, ClassesNames] = xlsread('AssetClassesReturnsMonthly','Returns3','D3:K1107'); 



%Year
Year = xlsread('AssetClassesReturnsMonthly','Returns3','C4:C1107'); %Year
%Data for the Inflation
InflationData = xlsread('AssetClassesReturnsMonthly','Returns3','N4:N1107'); 


%InflationData = ((InflationData == 0)*0.000001) + InflationData;


MonthNumero = xlsread('AssetClassesReturnsMonthly','Returns3','B4:B1107'); 
YearNumero = xlsread('AssetClassesReturnsMonthly','Returns3','A4:A1107');

%Number of Classes that we are using
NumClasses = size( ClassesReturns, 2);
%Give an ID to every class
ClassID = [1 2 3 4 5 6 7 8];
%Months of Data that we are using
YearsOfData = size( ClassesReturns, 1);

%% Initial Data - Inputs %%

AccountId = 1:3; % Number of different accounts, User decides - IN
AccountAllocation = [0.4 0.3 0.3]; % Allocate the initial capital to the accounts - IN

%Years of Withdrawl - IN
DefaultAge = 65;
CurrentAge = 35;
YearsOfWithdrawl = DefaultAge - CurrentAge; 
 

%Initial Investent in total - IN
InitialInvestment = 1000;
%Initial Investent to every account
InitialInvestmentAccount = InitialInvestment * AccountAllocation;
%Withdrawl amount in total - IN
TotalWithdrawl = 0/12; % WITHDRAWAL 0 FOR THE ACCUMULATION VERSION


%Scaled Income for different retirement phases
Scale = 0;
ScaleIncome = [0/12 0/12];
ScaleIncomeAge = [75 85];
ScaleIncomeAdjusted = 1; % 1 or 0 to adjust scale income for inflation or not

ScaleInflation = 0; % 1 or to 0 to change the inflation rule for the different income scale
ScaleWithdrawl = 0;% 1 to change change the withdrawl rule for the different income scale
ScaleWithdrawlRule = [0 0];
ScaleInflationRule = [1 1];

%NOTE THAT THE CONTRIBUTIONS ARE ADDED ONCE IN THE BEGGINING OF THE YEAR
%AND NOT MONTHLY!!!!!
ContributionAccount = [1 1 1]; % 0 OR 1.
ContributionStartAge{1} = [37 50 56];
ContributionStartAge{2} = [50 52 60];
ContributionStartAge{3} = [57 62];
ContributionAmmount{1} = [10000 9000 3000];
ContributionAmmount{2} = [10000 15000 13000];
ContributionAmmount{3} = [14000 12000];
ContributionAdjust = [1 1 1];


%WithdrawlAccountDrain - IN. Determine the order of the accounts that the 
%income will be taken. If the user choose
%to invest in two accounts then obviously the variable will be
%WithdrawlAccountDrain = [x y]. If the user choose 1 and 1 then the income
%is evenly taken according to the account allocation. If the user choose 1
%and 2, then the income will be taken from the first account untill it runs
%out of money and then it will be taken from the second account
WithdrawlAccountDrain = [1 1 1]; % -IN
%WithdrawlRate
WithdrawlRate = (TotalWithdrawl / InitialInvestment);


%Ongoing Charge for every account - IN. Again if the user choose to invest in 
%two accounts and not in three then this variable should be OngoingCharge = [x y]  
Charge = 1; %0 for percentage 1 for ammount
ChargeAdjust = 1; %1 to adjust tax with inflation, 0 for not
OngoingChargePercentage = [0/12 0/12 0/12];
OngoingChargeAmmount = [50/12 50/12 50/12];

AccountTaxPercentage = [0.1/12 0.1/12 0.1/12];
IncomeTaxPercentage = [0/12 0/12 0/12]; %ALWAYS 0 FOR ACCUMULATION

if Charge == 0
    OngoingCharge = OngoingChargePercentage;
else
    OngoingCharge = OngoingChargeAmmount;
end

%Legacy Target of the portfolio - IN
LegacyAdjust = 0; %0 not to adjust legacy with inflation, 1 to adjust legacy with inflation
LegacyTarget = 10000; 

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
InflationRule = 1; % -IN

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

WithdrawlOrder = [0 0 0]; % -IN

%Setting the preferences for the withdrawl order for every account

%if WithdrawlOrder == 3
    %If the user choose the given order draining option then he must define
    %the order for every account. If the user chooses to invest in two
    %accounts instead of three then the variable will be 
    %DrainOrder = [a1 b1 c1 d1 e1 ; a2 b2 c2 d2 e2 ]. 
    DrainOrder = [4 1 5 5 2 3 5 5;4 1 5 5 2 3 5 5;4 1 5 5 2 3 5 5]; % -IN
    
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
RebalancingRule = [1 1 1];  % - IN 

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
    PerformanceRebalancing = [1 0 0 0 0 0 0 0;0 -1 -1 0 -1 -1 0 0;1 0 0 0 0 0 0 0]; % -IN

%elseif RebalancingRule == 3

    %If the user decides to "rebalance" based on the harvesting rule then
    %the user must define the following:
    
    %Set from which classes to sell
    % The user can choose up to two classes from which to sell. If he
    % chooses 0 for one of those the he will sell only from one class. In
    % that case. Again if the user invests in two accounts then the variable would 
    %be SellClasses = [x y; z k];
    SellClasses = [1 0;1 0;1 6]; % -IN
    
    %Then the user must choose from which class to buy. If the user selects
    %this rule he must definately choose a class to buy. 0 is not permitted
    %as a value
    BuyClasses = [2 2 2]; % -IN
    
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
    ClassesBoundaries = [0.3 1 1 1 1 1 1 1;0.3 1 1 1 1 1 1 1;0.3 1 1 1 1 1 1 1;]; % -IN
    
    

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
[WOrder,AllocationGP,CurrentAllocation,ContributionToEveryClass,AdvisoryFee,AnnualSimpleInflationIndex,AnnualAdjustedInflation,CummulativeInflationIndex,HarvestAmmount,WithdrawalFromEveryClass,StartValue,Rebalancing, AdjustedInflation, InflationIndex, SimpleInflationIndex, BeginingBalance, EndBalance, Income, TotalBeginingBalance, TotalEndBalance, TotalIncome,RealEndBalance, RealIncome, PortfolioPercentageReturns,PortfolioRealPercentageReturns] = Calculations (AccountTaxPercentage, IncomeTaxPercentage,ContributionAccount, ContributionStartAge, ContributionAmmount, ContributionAdjust,ChargeAdjust,Charge,ScaleInflation, ScaleWithdrawl, ScaleWithdrawlRule, ScaleInflationRule,CurrentAge,Scale,ScaleIncome, ScaleIncomeAge, ScaleIncomeAdjusted,ClassID,GlidingAdjustment,GlidingEnd,InitialInvestmentAccount,AccountAllocation,WithdrawlAccountDrain,YearsOfData,ClassesReturns,TotalWithdrawl,WithdrawlOrder,DrainOrder,OngoingCharge,WithdrawlRule,Cap,PercentageAdjusted,Collar ,InflationRule,ClassesPVBoundary,SellClasses,BuyClasses,IIDifference,InflationData,RebalancingRule,PerformanceRebalancing,InitialInvestment,Frequency,InitialAccountAllocation,ClassesBoundaries, InitialPercentageAllocation, WithdrawlRate,PRTrigger,PRSpendingChange,PRUse,CPTrigger,CPSpendingChange,CPUse, WealthTreashold,RachetingSpendingChange,Floor,Ceiling,AccountId,YearsTarget, DrainOrderBuckets, DefaultClass);
%The following function calculated the probability of success
[NominalSR] = SuccessRate(YearsOfWithdrawl,SimpleInflationIndex,LegacyAdjust,LegacyTarget,TotalEndBalance);
%The following function plots the Real and Nominal Balance / Income

[SumIncomeAtYear,SumRealIncomeAtYear,RealBalance10thPerc,RealBalance50thPerc,RealBalance90thPerc,SumNominalIncome10thPerc,SumNominalIncome50thPerc,SumNominalIncome90thPerc,SumRealIncome10thPerc,SumRealIncome50thPerc,SumRealIncome90thPerc, CliffEdgeNominalIncome,ComfyNominalIncome,CloudNominalIncome,CliffEdgeRealIncome,ComfyRealIncome,CloudRealIncome,Exhausted10thPerc,Exhausted50thPerc,Balance10thPerc,Balance50thPerc,Balance90thPerc,ExhaustedMin,MedianBalance,PortfolioNominalPosReturns,PortfolioRealPosReturns,PortfolioReturnNominalMean,PortfolioReturnRealMean,PortfolioReturnNominalMax,PortfolioReturnRealMax,PortfolioNominalNegReturns,PortfolioRealNegReturns,PortfolioReturnNominalMin,PortfolioReturnRealMin] = Statistics(SimpleInflationIndex,TotalEndBalance,PortfolioPercentageReturns,PortfolioRealPercentageReturns,TotalIncome,RealIncome, InitialInvestment);

[BalanceAtDesiredYear, RealBalanceAtDesiredYear, IncomeAtDesiredYear, RealIncomeAtDesiredYear]=Plots(SimpleInflationIndex,TotalBeginingBalance,NominalSR,DefaultAge,SumIncomeAtYear,SumRealIncomeAtYear,RealBalance10thPerc,RealBalance50thPerc,RealBalance90thPerc,SumNominalIncome10thPerc,SumNominalIncome50thPerc,SumNominalIncome90thPerc,SumRealIncome10thPerc,SumRealIncome50thPerc,SumRealIncome90thPerc, CliffEdgeNominalIncome,ComfyNominalIncome,CloudNominalIncome,CliffEdgeRealIncome,ComfyRealIncome,CloudRealIncome,Balance10thPerc,Balance50thPerc,Balance90thPerc,YearsOfWithdrawl, RealEndBalance, TotalEndBalance, TotalIncome, RealIncome, InitialInvestment);

ReusltsMatrix{1,1}='Year';
ReusltsMatrix{1,2}='SR';
ReusltsMatrix{1,3}='10th Percentile Balance';
ReusltsMatrix{1,4}='50th Percentile Balance';
ReusltsMatrix{1,5}='10th Percentile Real Balance';
ReusltsMatrix{1,6}='50th Percentile Real Balance';
ReusltsMatrix{1,7}='Exhausted 10th Percentile';
ReusltsMatrix{1,8}='Exhausted 50th Percentile';
ReusltsMatrix{1,9}='Exhausted Min';
ReusltsMatrix{1,10}='Nominal Min Portfolio Return';
ReusltsMatrix{1,11}='Real Min Portfolio Return';
ReusltsMatrix{1,12}='Nominal Max Portfolio Return';
ReusltsMatrix{1,13}='Real Max Portfolio Return';
ReusltsMatrix{1,14}='Nominal Mean Portfolio Return';
ReusltsMatrix{1,15}='Real Mean Portfolio Return';
ReusltsMatrix{1,16}='Nominal Portfolio Positive Returns Percentage ';
ReusltsMatrix{1,17}='Real Portfolio Positive Returns Percentage ';
ReusltsMatrix{1,18}='Nominal Portfolio Negative Returns Percentage ';
ReusltsMatrix{1,19}='Real Portfolio Negative Returns Percentage ';
ReusltsMatrix{1,20}='Nominal Income Cliff Edge Scenario';
ReusltsMatrix{1,21}='Nominal Income Comfy Scenario';
ReusltsMatrix{1,22}='Nominal Income Cloud 9 Scenario';
ReusltsMatrix{1,23}='Real Income Cliff Edge Scenario';
ReusltsMatrix{1,24}='Real Income Comfy Scenario';
ReusltsMatrix{1,25}='Real Income Cloud 9 Scenario';
ReusltsMatrix{1,26}='Total Nominal Income 10th Perc';
ReusltsMatrix{1,27}='Total Nominal Income 50th Perc';
ReusltsMatrix{1,28}='Total Nominal Income 90th Perc';
ReusltsMatrix{1,29}='Total Real Income 10th Perc';
ReusltsMatrix{1,30}='Total Real Income 50th Perc';
ReusltsMatrix{1,31}='Total Real Income 90th Perc';

ReusltsMatrix{2,1} = 20;
ReusltsMatrix{3,1} = 25;
ReusltsMatrix{4,1} = 30;
ReusltsMatrix{5,1} = 35;
ReusltsMatrix{6,1} = 40;
%ReusltsMatrix{7,1} = YearsOfWithdrawl;

for i = 2:31
    for j = 2:6
        if i==2
            ReusltsMatrix{j,i} = NominalSR(ReusltsMatrix{j,1}*12);
        elseif i==3
            ReusltsMatrix{j,i} = Balance10thPerc(ReusltsMatrix{j,1}*12);
        elseif i==4
            ReusltsMatrix{j,i} = Balance50thPerc(ReusltsMatrix{j,1}*12);
        elseif i==5
            ReusltsMatrix{j,i} = RealBalance10thPerc(ReusltsMatrix{j,1}*12);
        elseif i==6
            ReusltsMatrix{j,i} = RealBalance50thPerc(ReusltsMatrix{j,1}*12);   
        elseif i==7
            ReusltsMatrix{j,i} = Exhausted10thPerc(ReusltsMatrix{j,1}*12);
        elseif i==8
            ReusltsMatrix{j,i} = Exhausted50thPerc(ReusltsMatrix{j,1}*12);
        elseif i==9
            ReusltsMatrix{j,i} = ExhaustedMin(ReusltsMatrix{j,1}*12);
        elseif i==10
            ReusltsMatrix{j,i} = PortfolioReturnNominalMin(ReusltsMatrix{j,1}*12);
        elseif i==11
            ReusltsMatrix{j,i} = PortfolioReturnRealMin(ReusltsMatrix{j,1}*12);
        elseif i==12
            ReusltsMatrix{j,i} = PortfolioReturnNominalMax(ReusltsMatrix{j,1}*12);
        elseif i==13
            ReusltsMatrix{j,i} = PortfolioReturnRealMax(ReusltsMatrix{j,1}*12);
        elseif i==14
            ReusltsMatrix{j,i} = PortfolioReturnNominalMean(ReusltsMatrix{j,1}*12);
        elseif i==15
            ReusltsMatrix{j,i} = PortfolioReturnRealMean(ReusltsMatrix{j,1}*12);
        elseif i==16
            ReusltsMatrix{j,i} = PortfolioNominalPosReturns(ReusltsMatrix{j,1}*12);
        elseif i==17
            ReusltsMatrix{j,i} = PortfolioRealPosReturns(ReusltsMatrix{j,1}*12);
        elseif i==18
            ReusltsMatrix{j,i} = PortfolioNominalNegReturns(ReusltsMatrix{j,1}*12);
        elseif i==19
            ReusltsMatrix{j,i} = PortfolioRealNegReturns(ReusltsMatrix{j,1}*12);
        elseif i==20
            ReusltsMatrix{j,i} = CliffEdgeNominalIncome(ReusltsMatrix{j,1}*12);
        elseif i==21
            ReusltsMatrix{j,i} = ComfyNominalIncome(ReusltsMatrix{j,1}*12);
        elseif i==22
            ReusltsMatrix{j,i} = CloudNominalIncome(ReusltsMatrix{j,1}*12);
        elseif i==23
            ReusltsMatrix{j,i} = CliffEdgeRealIncome(ReusltsMatrix{j,1}*12);
        elseif i==24
            ReusltsMatrix{j,i} = ComfyRealIncome(ReusltsMatrix{j,1}*12);
        elseif i==25    
            ReusltsMatrix{j,i} = CloudRealIncome(ReusltsMatrix{j,1}*12);
        elseif i==26    
            ReusltsMatrix{j,i} = SumNominalIncome10thPerc(ReusltsMatrix{j,1}*12);
        elseif i==27    
            ReusltsMatrix{j,i} = SumNominalIncome50thPerc(ReusltsMatrix{j,1}*12);
        elseif i==28    
            ReusltsMatrix{j,i} = SumNominalIncome90thPerc(ReusltsMatrix{j,1}*12);
        elseif i==29    
            ReusltsMatrix{j,i} = SumRealIncome10thPerc(ReusltsMatrix{j,1}*12);
        elseif i==30    
            ReusltsMatrix{j,i} = SumRealIncome50thPerc(ReusltsMatrix{j,1}*12);
        elseif i==31    
            ReusltsMatrix{j,i} = SumRealIncome90thPerc(ReusltsMatrix{j,1}*12);
        end
        
    end
end

