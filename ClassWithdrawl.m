function [AmountFromClass, OldLevels] = ClassWithdrawl(StartValue,CurrentAllocation,Income,AdvisoryFee,ClassID, WOrder)

AmountFromClass = zeros(1,size(CurrentAllocation,2));
Class = zeros (size(CurrentAllocation,2),size(CurrentAllocation,2));
PClass = zeros (size(CurrentAllocation,2),size(CurrentAllocation,2));
OldLevels = zeros(1, size(CurrentAllocation,2)+1);
TotalClassIDAmount = zeros(1, size(CurrentAllocation,2));
TotalClassIDPercentage = zeros(1, size(CurrentAllocation,2));
OldLevels(1) = -(Income+AdvisoryFee); 


With = zeros(1, size(CurrentAllocation,2));
PercentageOfOption = zeros(1, size(CurrentAllocation,2));

for i = 1: numel(ClassID)
    Class(i,:) = (WOrder == i) .* StartValue(1:end-1);
    PClass(i,:) = (WOrder == i) .* CurrentAllocation;
    TotalClassIDAmount(i) = sum(Class(i,:)); %Withdrawal options new levels excel tab
    TotalClassIDPercentage(i) = sum(PClass(i,:)); %Withdrawal options percentage excel tab
    
    
    %Withdrawal options old levels excel tab
    if TotalClassIDAmount(i)  < 0
        OldLevels(i+1) = OldLevels(i);
    else
        if OldLevels(i) < 0
            OldLevels(i+1) = OldLevels(i) + TotalClassIDAmount(i);
        else
            OldLevels(i+1) = TotalClassIDAmount(i); 
        end
    end
    
    %Withdrawal options withdrawl excel tab
    if OldLevels(i+1) > 0
        With(i) = TotalClassIDAmount(i) - OldLevels(i+1);
    else
        With(i) = TotalClassIDAmount(i);
    end
        
end

%Percentage of option excel tab
for i = 1 : size(ClassID,2)
    if TotalClassIDPercentage(WOrder(i)) == 0 
       PercentageOfOption(i) = 0;  
    else
       PercentageOfOption(i) = CurrentAllocation(i) / TotalClassIDPercentage(WOrder(i));
    end
    AmountFromClass(i) = PercentageOfOption(i)*With(WOrder(i));
end



end