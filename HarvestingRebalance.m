function [Rebalance, Amount] = HarvestingRebalance(InflationData,InitialAllocation,BuyClasses,StartValue,ClassID,SellClasses,IIDifference,Year, Id, ClassesNames)

SellingClasses = (ClassID == SellClasses(1)) | (ClassID == SellClasses(2));

BuyingClasses = (ClassID == BuyClasses);

RealStartValue = (StartValue .* SellingClasses) / InflationData(Year);
      
RealInitialValue = IIDifference* ((InitialAllocation .* SellingClasses) / InflationData(1));

if  sum(RealStartValue > RealInitialValue)>0
    
    SellAmount = zeros (1,size(InitialAllocation,2));
    BuyAmount = zeros (1,size(InitialAllocation,2));
    
    Rebalance = 1;
    
     for Class = SellClasses
      if Class~= 0
        if  (StartValue(Class)/ InflationData(Year)) > IIDifference * (InitialAllocation(Class) / InflationData(1))
            fprintf('It is time to rebalance your portfolio number %d. You need to replenish %s with %f pounds from %s. ', Id, ClassesNames{BuyClasses}, (StartValue(Class)/ InflationData(Year))-(IIDifference * (InitialAllocation(Class) / InflationData(1))), ClassesNames{Class});
            SellAmount(Class) = -InflationData(Year)*(IIDifference-1)*(StartValue(Class)) / InflationData(Year);         
        end
      end
     end
     
    BuyAmount(BuyClasses) = -sum(SellAmount);
     
    UserDecision = input('Enter 1 to replenish or 0 not to: ');
    
    if UserDecision == 1
        Rebalance = 1;
        Amount = SellAmount + BuyAmount;
        
    else
            Rebalance = 0;
            Amount = 0;
    end
         
else
    Rebalance = 0;
    Amount = 0;
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          


