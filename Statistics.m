function [SumIncomeAtYear,SumRealIncomeAtYear,RealBalance10thPerc,RealBalance50thPerc,RealBalance90thPerc,SumNominalIncome10thPerc,SumNominalIncome50thPerc,SumNominalIncome90thPerc,SumRealIncome10thPerc,SumRealIncome50thPerc,SumRealIncome90thPerc, CliffEdgeNominalIncome,ComfyNominalIncome,CloudNominalIncome,CliffEdgeRealIncome,ComfyRealIncome,CloudRealIncome,Exhausted10thPerc,Exhausted50thPerc,Balance10thPerc,Balance50thPerc,Balance90thPerc,ExhaustedMin,MedianBalance,PortfolioNominalPosReturns,PortfolioRealPosReturns,PortfolioReturnNominalMean,PortfolioReturnRealMean,PortfolioReturnNominalMax,PortfolioReturnRealMax,PortfolioNominalNegReturns,PortfolioRealNegReturns,PortfolioReturnNominalMin,PortfolioReturnRealMin] = Statistics(SimpleInflationIndex,TotalEndBalance,PortfolioPercentageReturns,PortfolioRealPercentageReturns,TotalIncome,RealIncome, InitialInvestment)


ScenarioExhausted = zeros(1,size(TotalEndBalance,2));
Exhausted10thPerc = zeros(1,size(TotalEndBalance{1},1));
Exhausted50thPerc = zeros(1,size(TotalEndBalance{1},1));
ExhaustedMin = zeros(1,size(TotalEndBalance{1},1)); 
Balance10thPerc = zeros(1,size(TotalEndBalance{1},1)); 
Balance50thPerc = zeros(1,size(TotalEndBalance{1},1)); 
Balance90thPerc = zeros(1,size(TotalEndBalance{1},1));
RealBalance10thPerc = zeros(1,size(TotalEndBalance{1},1)); 
RealBalance50thPerc = zeros(1,size(TotalEndBalance{1},1)); 
RealBalance90thPerc = zeros(1,size(TotalEndBalance{1},1));
CliffEdgeNominalIncome = zeros(1,size(TotalEndBalance{1},1)); 
ComfyNominalIncome = zeros(1,size(TotalEndBalance{1},1)); 
CloudNominalIncome = zeros(1,size(TotalEndBalance{1},1)); 
CliffEdgeRealIncome = zeros(1,size(TotalEndBalance{1},1)); 
ComfyRealIncome = zeros(1,size(TotalEndBalance{1},1)); 
CloudRealIncome = zeros(1,size(TotalEndBalance{1},1)); 
SumNominalIncome10thPerc= zeros(1,size(TotalEndBalance{1},1));
SumNominalIncome50thPerc= zeros(1,size(TotalEndBalance{1},1));
SumNominalIncome90thPerc= zeros(1,size(TotalEndBalance{1},1));
SumRealIncome10thPerc= zeros(1,size(TotalEndBalance{1},1));
SumRealIncome50thPerc= zeros(1,size(TotalEndBalance{1},1));
SumRealIncome90thPerc= zeros(1,size(TotalEndBalance{1},1));



PortfolioReturnNominalMin =zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioReturnRealMin=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioReturnNominalMean=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioReturnRealMean=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioReturnNominalMax=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioReturnRealMax=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioNominalPosReturns=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioRealPosReturns=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioNominalNegReturns=zeros(1,size(TotalEndBalance{1},1)-1);
PortfolioRealNegReturns=zeros(1,size(TotalEndBalance{1},1)-1);

for Scenario = 1:size(TotalEndBalance,2)
    for Year = 1:size(TotalEndBalance{Scenario},1)
        if Year==size(TotalEndBalance{Scenario},1) && ScenarioExhausted(Scenario)==0 && TotalEndBalance{Scenario}(Year)~=0
            ScenarioExhausted(Scenario) = Year/12;
        else
            if TotalEndBalance{Scenario}(Year) == 0
                ScenarioExhausted(Scenario) = Year/12;       
            end
        end
    end
    %PortfolioPercentageReturns{Scenario}(:) = PortfolioPercentageReturns{Scenario}(:) + (PortfolioPercentageReturns{Scenario}(:) ==-1 );
end


for Year = 1:size(TotalEndBalance{1},1)
    for Scenario = 1:size(TotalEndBalance,2)+1-Year     
            
             
        if Year == 1
            BalanceAtYear(Year, Scenario) = TotalEndBalance{Scenario}(Year);
            RealBalanceAtYear(Year, Scenario) = BalanceAtYear(Year, Scenario)/SimpleInflationIndex{Scenario}(Year);
            
            TotalIncomeAtYear(Year, Scenario) = TotalIncome{Scenario}(Year);
            RealIncomeAtYear(Year, Scenario) = RealIncome{Scenario}(Year);
            
            SumIncomeAtYear(Year,Scenario) = TotalIncomeAtYear(Year, Scenario);
            SumRealIncomeAtYear(Year,Scenario) = RealIncomeAtYear(Year, Scenario);  
            
        else
            BalanceAtYear(Year, Scenario) = TotalEndBalance{Scenario}(Year);
            RealBalanceAtYear(Year, Scenario) = BalanceAtYear(Year, Scenario)/SimpleInflationIndex{Scenario}(Year);
            
            TotalIncomeAtYear(Year, Scenario) = TotalIncome{Scenario}(Year);
            RealIncomeAtYear(Year, Scenario) = RealIncome{Scenario}(Year);
            
            SumIncomeAtYear(Year,Scenario) = SumIncomeAtYear(Year-1,Scenario)+TotalIncomeAtYear(Year, Scenario);
            SumRealIncomeAtYear(Year,Scenario) = SumRealIncomeAtYear(Year-1,Scenario)+RealIncomeAtYear(Year, Scenario);
         
        end 
    end
end

for Year = 1:size(TotalEndBalance{1},1)-1
    for Scenario = 1:size(TotalEndBalance,2)-Year
        PortfolioNomReturns(Year, Scenario) = PortfolioPercentageReturns{Scenario}(Year);
        PortfolioRealReturns(Year, Scenario) = PortfolioRealPercentageReturns{Scenario}(Year);
    end
end

for Year = 1:size(TotalEndBalance{1},1)
    for Scenario = 1:size(TotalEndBalance,2)+1-Year
        if isnan(BalanceAtYear(Year, Scenario))==1
            BalanceAtYear(Year, Scenario)=0;
            RealBalanceAtYear(Year, Scenario)=0;
        end
    end
end

for Year = 1:size(TotalEndBalance{1},1)-1
    for Scenario = 1:size(TotalEndBalance,2)-Year
        if isnan(PortfolioNomReturns(Year, Scenario))==1
            PortfolioNomReturns(Year, Scenario)=0;
        end
    end
end

for Year = 1:size(TotalEndBalance{1},1)-1
    for Scenario = 1:size(TotalEndBalance,2)-Year
         if isnan(PortfolioRealReturns(Year, Scenario))==1
            PortfolioRealReturns(Year, Scenario)=0;
         end
    end
end
    
for Year = 1:size(TotalEndBalance{1},1)
    Balance10thPerc(Year) = prctile(BalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    Balance50thPerc(Year) = prctile(BalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    Balance90thPerc(Year) = prctile(BalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    RealBalance10thPerc(Year) = prctile(RealBalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    RealBalance50thPerc(Year) = prctile(RealBalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    RealBalance90thPerc(Year) = prctile(RealBalanceAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    CliffEdgeNominalIncome(Year) = prctile(TotalIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    ComfyNominalIncome(Year) = prctile(TotalIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    CloudNominalIncome(Year) = prctile(TotalIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    CliffEdgeRealIncome(Year) = prctile(RealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    ComfyRealIncome(Year) = prctile(RealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    CloudRealIncome(Year) = prctile(RealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    SumNominalIncome10thPerc(Year) = prctile(SumIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    SumNominalIncome50thPerc(Year) = prctile(SumIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    SumNominalIncome90thPerc(Year) = prctile(SumIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    SumRealIncome10thPerc(Year) = prctile(SumRealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),10);
    SumRealIncome50thPerc(Year) = prctile(SumRealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),50);
    SumRealIncome90thPerc(Year) = prctile(SumRealIncomeAtYear(Year,1:size(TotalEndBalance,2)+1-(Year)),90);
    Exhausted10thPerc(Year) = prctile(ScenarioExhausted(1:size(TotalEndBalance,2)+1-(Year)),10);
    Exhausted50thPerc(Year) = prctile(ScenarioExhausted(1:size(TotalEndBalance,2)+1-(Year)),50);
    ExhaustedMin(Year) = min(ScenarioExhausted(1:size(TotalEndBalance,2)+1-Year));
     
end

for Year = 1:size(TotalEndBalance{1},1)-1
    PortfolioReturnNominalMin(Year) = min(PortfolioNomReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioReturnRealMin(Year)= min(PortfolioRealReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioReturnNominalMean(Year)= mean(PortfolioNomReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioReturnRealMean(Year)= mean(PortfolioRealReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioReturnNominalMax(Year)= max(PortfolioNomReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioReturnRealMax(Year)= max(PortfolioRealReturns(Year,1:size(TotalEndBalance,2)-Year));
    PortfolioNominalPosReturns(Year)= sum(PortfolioNomReturns(Year,1:size(TotalEndBalance,2)-Year)>0)/size(PortfolioNomReturns(Year,1:size(TotalEndBalance,2)-Year),2);
    PortfolioRealPosReturns(Year)= sum(PortfolioRealReturns(Year,1:size(TotalEndBalance,2)-Year)>0)/size(PortfolioRealReturns(Year,1:size(TotalEndBalance,2)-Year),2);
    PortfolioNominalNegReturns(Year)= 1 - PortfolioNominalPosReturns(Year);
    PortfolioRealNegReturns(Year)= 1 - PortfolioRealPosReturns(Year);
end

    MedianBalance = Balance50thPerc(30*12);
  
    
    
    
    
    
    
    
end
