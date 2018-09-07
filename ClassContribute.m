function [AmountFromClass, OldLevels] = ClassContribute(WithdrawalFromEveryClass,Ammount,StartValue,ClassID, WOrder)

StartValue(1:end-1) = StartValue(1:end-1) - WithdrawalFromEveryClass;
if sum(StartValue(1:end-1))~= 0
    CurrentAllocation = StartValue(1:end-1) / sum(StartValue(1:end-1));
else
    CurrentAllocation = zeros(1,size(StartValue(1:end-1),2));
end
AmountFromClass = zeros(1,size(CurrentAllocation,2));
Class = zeros (size(CurrentAllocation,2),size(CurrentAllocation,2));
PClass = zeros (size(CurrentAllocation,2),size(CurrentAllocation,2));
OldLevels = zeros(1, size(CurrentAllocation,2)+1);
TotalClassIDAmount = zeros(1, size(CurrentAllocation,2));
TotalClassIDPercentage = zeros(1, size(CurrentAllocation,2));
OldLevels(1) = Ammount;
With = zeros(1, size(CurrentAllocation,2));
PercentageOfOption = zeros(1, size(CurrentAllocation,2));

for i = 1: numel(ClassID)
    Class(i,:) = (WOrder == i) .* StartValue(1:end-1);
    PClass(i,:) = (WOrder == i) .* CurrentAllocation;
    TotalClassIDAmount(i) = sum(Class(i,:)); %Withdrawal options new levels excel tab
    TotalClassIDPercentage(i) = sum(PClass(i,:)); %Withdrawal options percentage excel tab
    
    %Withdrawal options old levels excel tab
    OldLevels(i+1) = OldLevels(i) + TotalClassIDAmount(i);
    
    %Withdrawal options withdrawl excel tab
    if OldLevels(i+1) == OldLevels(i)
        With(i) = 0; 
    else        
        With(i) = -TotalClassIDAmount(i) + OldLevels(i+1);  
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