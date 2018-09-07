function [Rebalance,ResetAssetAllocation] = TimeRebalance(Frequency,Year,Id)

if mod(Year,Frequency)==0
    Rebalance = 1;
    fprintf('%d months have passed, it is time to rebalance your portfolio number %d. ', Frequency ,Id);
    UserDecision = input('Enter 1 to rebalance or 0 not to: ');
    
    if UserDecision == 1
        AllocationReset = input('Enter 1 if you want to reset your portfolio allocation or 0 not to: ');
        if AllocationReset == 1
            ResetAssetAllocation = input('Type the new portfolio asset allocation in the form of a mattrix: ');
        else
            ResetAssetAllocation = 0;
        end
        Rebalance = 1;
    else
        Rebalance = 0;
        ResetAssetAllocation = 0;
    end
    
else
    Rebalance = 0;
    ResetAssetAllocation = 0;
end

end