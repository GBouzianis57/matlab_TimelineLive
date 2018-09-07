function [AmountFromAccount] = AccWithdrawl(AdvisoryFee,AccountId,InitialInvestmentAccount,TotalIncome,AWOrder)

AmountFromAccount = zeros(1 ,size(AccountId,2));
%AAcc stands for Amount from Accounts. 
AAcc = zeros (size(AccountId,2),size(AccountId,2));
%PAcc stands for Percentage from Accounts.
PAcc = zeros (size(AccountId,2),size(AccountId,2));
AccOldLevels = zeros(1, size(AccountId,2)+1);
TotalAccIDAmount = zeros(1, size(AccountId,2));
TotalAccIDPercentage = zeros(1, size(AccountId,2));
AccOldLevels(1) = -(TotalIncome);
%AccWith stands for Accounts Withdrawal
AccWith = zeros(1, size(AccountId,2));
AccPercentageOfOption = zeros(1, size(AccountId,2));
InitialInvestmentAccount = InitialInvestmentAccount - AdvisoryFee;
if sum(InitialInvestmentAccount)~= 0    
    AccountAllocation = InitialInvestmentAccount / (sum(InitialInvestmentAccount));
else
    AccountAllocation = zeros(1 ,size(AccountId,2));
end

%AWorder stands for Account withdrawal order and it's the order with wich the money is taken from the accounts.
%It is an array with 1 row and columns as many as the number of the accounts that the user chose.
%Assume that the user invests in three accounts and he wants to take the Income evenly. Then AWorder = [1 1 1]
%Assume that the user invests in three accounts and he wants to take the income from the first account untill it runs out
%of money and then take it evenly from the other two accounts. Then AWorder = [1 2 2]

%InitialInvestmentAccount is the variable that corresponds to the money that each account has when this function is called 
%For example [80000 12000 8000]. 
%AccountAllocation corresponds to the money of each account as a percentage of the total wealth. Then following the previous example 
%that will be [0.8 0.12 0.08].
%Obviously these two variables change value each month!

for i = 1: numel(AccountId)

%PLEASE NOT THAT HERE i DOES NOT IMPLY THE ACCOUNT IT SELF, IT REPRESENTS THE ORDER AT WHICH THE ACCOUNT WILL BE SELECTED TO TAKE INCOME FROM.
    AAcc(i,:) = (AWOrder == i) .* InitialInvestmentAccount;
    PAcc(i,:) = (AWOrder == i) .* AccountAllocation;
    
    TotalAccIDAmount(i) = sum(AAcc(i,:)); %Withdrawal options new levels excel tab
    TotalAccIDPercentage(i) = sum(PAcc(i,:)); %Withdrawal options percentage excel tab
    
    %Assume that AWorder = [1 1 1] and InitialInvestmentAccount = [ 80000 12000 8000].
    %Then when the for loop is completed AAcc will be [80000 12000 8000 ; 0 0 0 ; 0 0 0]
    %PAcc will be [0.8 0.12 0.08; 0 0 0 ; 0 0 0] and TotalAccIDAmount will be [100000 0 0] and TotalAccIDPercentage = [1 0 0]
    %That means that the Income is taken evenly from the whole capital (100k).
    
    %Assume that AWorder = [1 2 2] and InitialInvestmentAccount = [ 80000 12000 8000].
    %Then when the for loop is completed AAcc will be [80000 0 0 ; 0 12000 8000 ; 0 0 0]
    %PAcc will be [0.8 0 0; 0 0.12 0.08 ; 0 0 0] and TotalAccIDAmount will be [80000 20000 0] and TotalAccIDPercentage = [0.8 0.2 0]
    %That means that the Income will be taken from the 80k (which is the the value of the first account),
    %and if that runs out of money then the income will be taken from the 20k (which is the total value of the 
    %second and the third account).
    
    %Assume that AWorder = [1 2 3] and InitialInvestmentAccount = [ 80000 12000 8000].
    %Then when the for loop is completed AAcc will be [80000 0 0 ; 0 12000 0 ; 0 0 8000]
    %PAcc will be [0.8 0 0; 0 0.12 0 ; 0 0 0.08] and TotalAccIDPercentage = [0.8 0.12 0.08]
    %That means that the Income will be taken from the 80k (which is the the value of the first account),
    %and if that runs out of money then the income will be taken from the 12k (which is the total value of the 
    %second account) and if that runs out of money then it will be taken from the 8k (which is the value of the third account)
    
    %The variable AccOldLevels carries the Income that needs to be distributed to the accounts. The initial value of this variable
    %is the total income that must be taken and it's negative.
    
    %Withdrawal options old levels excel tab
    if TotalAccIDAmount(i)  < 0
    %If the desired accounts that the income will be taken from, have no money in, then the income will be taken from the next prefered account.
    %In that case the variable AccOldLevels(i+1) will be the same with AccOldLevels(i).
        AccOldLevels(i+1) = AccOldLevels(i);
    else
    %If TotalAccIdAmmount(i) is not negative, then that means that there are still money in the i-th accounts. However, we dont know 
    %if the money is enough for the whole Income to be taken, and we need to add a further condition.
        if AccOldLevels(i) < 0
        %If AccOldelevels(i) is negative that means that not all the Income has been distributed to the accounts. In that case the ammount 
        %of money that will be taken from the next desired accounts is equal to AccOldLevels(i)+TotalAccIDAmount(i). This is because the maximum 
        %amount of money that can be taken from the i-th accounts it's their total value, which is TotalAccIDAmount(i). Then the difference between 
        %AccOldLevels ( which is negative) and TotalAccIDAmount will be taken from the next desired account. However if TotalAccIDAmount(i) has enough 
        %money for the whole income to be taken, then AccOldLevels(i+1) will become positive, and in that case no income will be taken from the next desired accounts.
 
            AccOldLevels(i+1) = AccOldLevels(i) + TotalAccIDAmount(i);
        else
        %If AccOldLevels(i) has a positive value that means that the whole income has been taken. Then we set AccOldLevels(i+1) equal to the total value of the accounts. 
        %Then using this command AccWith(i) = TotalAccIDAmount(i) - AccOldLevels(i+1); we ensure that no income will be taken from the next accounts.
            AccOldLevels(i+1) = TotalAccIDAmount(i); 
        end
    end
    
    %Withdrawal options withdrawl excel tab
    if AccOldLevels(i+1) > 0
    % If AccOldLevels(i) is positive, that means that the i-th accounts have enough money in, for the income to be taken.
        AccWith(i) = TotalAccIDAmount(i) - AccOldLevels(i+1);
    else
    %Else, if AccOldLevels(i+1) is still negative that means that the total value of the i-th accounts  is less or equal than 
    %the desired income. In that case the maximum that can be taken from these accounts, it's their total value, which is TotalAccIDAmmount(i).
        AccWith(i) = TotalAccIDAmount(i);
    end
        
end

%Percentage of option excel tab
%This is the way that then the income is distributed to EACH account.
for i = 1 : size(AccountId,2)
    if TotalAccIDPercentage(AWOrder(i)) == 0 
       AccPercentageOfOption(i) = 0;  
    else
       AccPercentageOfOption(i) = AccountAllocation(i) / TotalAccIDPercentage(AWOrder(i));
    end
    AmountFromAccount(i) = AccPercentageOfOption(i)*AccWith(AWOrder(i));
end

end
