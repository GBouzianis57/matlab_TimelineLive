function [Rebalance,AllocationReset] = PortfolioBoundedRebalance(CurrentAllocation, ClassesPVBoundary, Id, ClassesNames)


if sum(CurrentAllocation > ClassesPVBoundary) > 0
    Rebalance = 1;
    
    for Class = 1 : size(CurrentAllocation,2)
        if CurrentAllocation(Class) > ClassesPVBoundary(Class)
            fprintf('It is time to rebalance your portfolio number %d. %s is now %f of the portfolio value and the boundary is %f. ', Id, ClassesNames{Class}, CurrentAllocation(Class), ClassesPVBoundary(Class));
            break;
        end
    end
            
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