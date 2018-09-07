function [Inflation] = GuytonAdjustedInflation(StartValue,EndBalance,InflationData)

if StartValue > EndBalance
    Inflation = InflationData;
else
    Inflation =0;
end

end