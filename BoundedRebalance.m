function [Rebalance, maxDiff] = BoundedRebalance(AllocationGP, CurrentAllocation ,ClassesBoundaries, Id, ClassesNames)
%Rebalance check excel tab
Difference = abs(CurrentAllocation - AllocationGP)> ClassesBoundaries;
maxDiff = max(abs(CurrentAllocation - AllocationGP));

if sum(Difference)>0
    
    Rebalance = 1;
    
    for Class = 1 : size(CurrentAllocation,2)
        if abs(CurrentAllocation(Class) - AllocationGP(Class))> ClassesBoundaries(Class)
            fprintf('It is time to rebalance your portfolio number %d. %s is now %f of the portfolio value, while the upper boundary is %f and the lower boundary is %f. ', Id, ClassesNames{Class}, CurrentAllocation(Class), ClassesBoundaries(Class)+ AllocationGP(Class), -ClassesBoundaries(Class)+AllocationGP(Class));
            break
        end
    end
            
    UserDecision = input('Enter 1 to rebalance or 0 not to: ');
    
    if UserDecision == 1
        Rebalance = 1;
    else
        Rebalance = 0;
    end
    
else
    Rebalance=0;
end


end