% Breguet Loiter
%{
E: Endurance
C: Thrust Specific Fuel Consumption
LD: L/D Ratio
%}
function w2w1 = fBrLo(E,C,LD)
    w2w1 = exp((-E*C)/LD); return;
end