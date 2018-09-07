function [AdjInfl] = PercentageAdjustment(InflationData,PercentageAdjusted)

if InflationData > 0
    AdjInfl = InflationData + PercentageAdjusted;
else
    AdjInfl = InflationData;
end
end