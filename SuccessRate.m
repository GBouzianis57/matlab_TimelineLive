function [NominalSR] = SuccessRate(YearsOfWithdrawl,SimpleInflationIndex,LegacyAdjust,Legacy,EndBalance)

NominalSuccessfullScenarios = zeros(size(EndBalance{1},1),1);
NominalSR = zeros(size(EndBalance{1},1),1);

DesiredYears = (YearsOfWithdrawl+1)*12;%;1 : size(EndBalance{1},1);


Year = DesiredYears;
    
     for SIndex = 1 :(size(EndBalance,2)+1) - Year      
 
     BalanceAtDesiredYear(1:size(EndBalance{SIndex}(:),1),SIndex) = EndBalance{SIndex}(1:end);
     SimpleInflationIndexAtYear(1:size(SimpleInflationIndex{SIndex}(:),1),SIndex) = SimpleInflationIndex{SIndex}(1:end);
     end
     
     for SIndex = 1: (size(EndBalance,2)+1) - Year
         
     if LegacyAdjust == 0
         
         
            NominalSuccessfullScenarios(SIndex)= sum(BalanceAtDesiredYear(SIndex,1:end+1-SIndex) >= Legacy);
     
     else
         
         
        NominalSuccessfullScenarios(SIndex) = sum(( BalanceAtDesiredYear(SIndex,1:end+1-SIndex) >= (Legacy*SimpleInflationIndexAtYear(SIndex,1:end+1-SIndex))));
         
     end

     
        NominalSR(SIndex) = NominalSuccessfullScenarios(SIndex) / size(BalanceAtDesiredYear(:,1:end+1-SIndex),2);
 
     end
     
     
end

     
 




       




       
