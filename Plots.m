function [BalanceAtDesiredYear, RealBalanceAtDesiredYear, IncomeAtDesiredYear, RealIncomeAtDesiredYear]= Plots(SimpleInflationIndex,TotalBeginingBalance,NominalSR,DefaultAge,SumIncomeAtYear,SumRealIncomeAtYear,RealBalance10thPerc,RealBalance50thPerc,RealBalance90thPerc,SumNominalIncome10thPerc,SumNominalIncome50thPerc,SumNominalIncome90thPerc,SumRealIncome10thPerc,SumRealIncome50thPerc,SumRealIncome90thPerc, CliffEdgeNominalIncome,ComfyNominalIncome,CloudNominalIncome,CliffEdgeRealIncome,ComfyRealIncome,CloudRealIncome,Balance10thPerc,Balance50thPerc,Balance90thPerc,YearsOfWithdrawl, RealEndBalance, EndBalance, Income, RealIncome, InitialInvestment)


%if YearsOfWithdrawl == 1
    %Time = MonthsOfWithdrawl;
%else
    Time =  (YearsOfWithdrawl)*12;
%end

for Year = 1: Time + 1
     for SIndex = 1 : (size(EndBalance,2)+1) - Year

            BalanceAtDesiredYear(Year, SIndex) = TotalBeginingBalance{SIndex}(Year);
            RealBalanceAtDesiredYear(Year, SIndex) = BalanceAtDesiredYear(Year, SIndex) / SimpleInflationIndex{SIndex}(Year) ; 
     
            IncomeAtDesiredYear(Year, SIndex) = Income{SIndex}(Year);
            RealIncomeAtDesiredYear(Year, SIndex) = RealIncome{SIndex}(Year);
            
     
     end

end

times = (DefaultAge - Time/12):(1/12): DefaultAge;

figure()
plot(times,BalanceAtDesiredYear(1:end,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,Balance10thPerc(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,Balance50thPerc(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,Balance90thPerc(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
legend('Nominal Balance Scenarios')
ylabel('Nominal Balance','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')


figure()
plot(times,NominalSR(1:length(times)),'-k*','LineWidth',1.6,'MarkerSize',1);
legend('SR')
ylabel('Success Rate','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')

figure()
plot(times,RealBalanceAtDesiredYear(:,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,RealBalance10thPerc(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,RealBalance50thPerc(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,RealBalance90thPerc(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
ylabel('Real Balance','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')
legend('Real Balance Scenarios')


figure()
plot(times,IncomeAtDesiredYear(:,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,CliffEdgeNominalIncome(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,ComfyNominalIncome(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,CloudNominalIncome(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
%ylim([0, max(1000));
ylabel('Nominal Income','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')
legend('Nominal Income Scenarios')

figure()
plot(times,RealIncomeAtDesiredYear(:,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,CliffEdgeRealIncome(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,ComfyRealIncome(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,CloudRealIncome(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
ylabel('Real Income','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')
legend('Real Income Scenarios')

figure()
plot(times,SumIncomeAtYear(1:(YearsOfWithdrawl)*12+1,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,SumNominalIncome10thPerc(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,SumNominalIncome50thPerc(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,SumNominalIncome90thPerc(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
ylabel('Cumulative Nominal Income','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')
legend('Cumulative Nominal Income Scenarios')

figure()
plot(times,SumRealIncomeAtYear(1:(YearsOfWithdrawl)*12+1,1:(size(EndBalance,2))-(YearsOfWithdrawl)*12),'-b')
hold on
plot(times,SumRealIncome10thPerc(1:YearsOfWithdrawl*12+1),'-k','LineWidth',1.2);
plot(times,SumRealIncome50thPerc(1:YearsOfWithdrawl*12+1),'-r','LineWidth',1.2);
plot(times,SumRealIncome90thPerc(1:YearsOfWithdrawl*12+1),'-g','LineWidth',1.2);
ylabel('Cumulative Real Income','fontsize',14,'interpreter','latex')
xlabel('Age','fontsize',14,'interpreter','latex')
legend('Cumulative Real Income Scenarios')




