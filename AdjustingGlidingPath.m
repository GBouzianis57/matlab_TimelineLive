function [AllocationGP] = AdjustingGlidingPath(ClassesReturns,InitialPercentageAllocation,GlidingAdjustment,GlidingEnd)
AllocationGP = zeros(size(ClassesReturns,1),size(ClassesReturns,2));
AllocationGP(1,:) = InitialPercentageAllocation;

%MAIN IDEA
%The idea of the gliding path is to enable the user to change the
%allocation of his portfolio at the moments he rebalances his portfolio.
%Rather than rebalancing the portfolio back to the original allocation the
%user change the allocation for each class

%If the user choose not to use gliding path then both the Glidingadjustment
%and the GlidingEnd variables are set to zero for every class of the
%portfolio

%If the user choose to use gliding path tn one of his account
%or more than one of his accounts then he has to decide the Glidingadjustment
%and the GlidingEnd variables for every class of the
%portfolio


%EXAMPLE
%Assume that the client invests in a single account 50/50 Equity/Bond Portfolio and chooses to use
%gliding path. Assume that he sets Glidingadjustment = [0.01 -0.02] and
%GlidingEnd = [0.6 0.3]. Then each month that the portfolio is rebalanced
%(based on the rebalancing rule he chose) the equity allocation will
%increase by 1% if the current equity allocation + the change is smaller than the
%END allocation which is 60%. So for the first time that he rebalances: 50% +1% is smaller that 60% 
%and thus the Equity allocation will become 51%. Similar for the bond
%allocation, it will be decreased untill it reaches30%.
%When the boundaries are reached (60% and 30%) then the portfolio is rebalanced based on those. 


for i=2:size(ClassesReturns,1) %FOR EACH MONTH
    for j=1:size(ClassesReturns,2) %FOR EACH CLASS OF THE PORTFOLIO
        if GlidingAdjustment(j)<0
            if (AllocationGP(i-1,j)+GlidingAdjustment(j)) > GlidingEnd(j)
                AllocationGP(i,j) = AllocationGP(i-1,j) + GlidingAdjustment(j);
            else
                AllocationGP(i,j) = GlidingEnd(j);
            end
        elseif GlidingAdjustment(j)>0
             if (AllocationGP(i-1,j)+GlidingAdjustment(j)) < GlidingEnd(j)
                AllocationGP(i,j) = AllocationGP(i-1,j) + GlidingAdjustment(j);
            else
                AllocationGP(i,j) = GlidingEnd(j);
            end
        else
                AllocationGP(i,j) = InitialPercentageAllocation(j);
        end
    end
end
                
                
            

