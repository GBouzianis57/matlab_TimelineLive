function [Rebalance] = PerformanceRebalance(ClassesReturns,PerformanceRebalancing, Id)

    if min(ClassesReturns .* PerformanceRebalancing) < 0
         Rebalance=0;
    else
         Rebalance=1;

         fprintf('It is time to rebalance your portfolio number %d. All the Asset Classes have the desired performance. ', Id);       
         UserDecision = input('Enter 1 to rebalance or 0 not to: ');
         
         if UserDecision == 1
            Rebalance = 1;
         else
            Rebalance = 0;
         end
     
   end
   
end
       