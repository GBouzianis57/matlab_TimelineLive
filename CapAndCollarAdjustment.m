function [AdjInfl] = CapAndCollarAdjustment(InflationData,Cap,Collar)

if InflationData > Cap
    AdjInfl = Cap;
elseif InflationData < Collar
    AdjInfl = Collar;
else
    AdjInfl = InflationData;
end

end