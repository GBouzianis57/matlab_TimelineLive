function [Rebalance,ResetAssetAllocation] = PerformanceRebalance(ClassesReturns,PerformanceRebalancing, Id, ClassID)

    ResetAssetAllocation = zeros(1,numel(ClassID));
    if min(ClassesReturns .* PerformanceRebalancing) < 0
         Rebalance=0;
         ResetAssetAllocation(:) = 0;
    else
         Rebalance=1;

         fprintf('It is time to rebalance your portfolio number %d. All the Asset Classes have the desired performance. ', Id);       
         UserDecision = input('Enter 1 to rebalance or 0 not to: ');
         
         if UserDecision == 1
            AllocationReset = input('Enter 1 if you want to reset your portfolio allocation or 0 not to: ');
            if AllocationReset == 1
                ResetAssetAllocation = input('Type the new portfolio asset allocation in the form of a mattrix: ');
            else
                ResetAssetAllocation(:) = 0;
            end
            Rebalance = 1;
         else
            Rebalance = 0;
            ResetAssetAllocation(:) = 0;
         end
     
   end
   
end
       