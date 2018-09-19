function [Rebalance, Amount] = HarvestingRebalance(InitialAllocation,BuyClasses,StartValue,ClassID,SellClasses,IIDifference, Id, ClassesNames)

SellingClasses = (ClassID == SellClasses(1)) | (ClassID == SellClasses(2));

RealStartValue = (StartValue .* SellingClasses);
      
RealInitialValue = ((InitialAllocation .* SellingClasses));
  
SellAmount = zeros (1,size(InitialAllocation,2));
BuyAmount = zeros (1,size(InitialAllocation,2));
 
if  sum(RealStartValue > IIDifference* RealInitialValue)>0
    Rebalance = 1;
    
     for Class = SellClasses
      if Class~= 0
        if  RealStartValue(Class) > IIDifference * RealInitialValue(Class)
            SellAmount(Class) = -(IIDifference-1)*RealInitialValue(Class);
            fprintf('It is time to rebalance your portfolio number %d. You need to replenish %s with %f pounds from %s. ', Id, ClassesNames{BuyClasses},SellAmount(Class), ClassesNames{Class});
        end
      end
     end
    UserDecision = input('Enter 1 to replenish or 0 not to: ');
    
    BuyAmount(BuyClasses) = -sum(SellAmount);
    
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          


