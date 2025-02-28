% Breguet Cruise
%{
R: Range (Nmi)
C: Thrust Specific Fuel Consumption
V: Velocity
LD: L/D Ratio
%}
function w2w1 = fBrCr(R,C,V,LD)
    w2w1 = exp((-R*C)/(V*LD)); return;
end