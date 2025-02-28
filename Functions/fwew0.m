% Empty To Gross Weight Ratio
%{
W_0: Gross Weight (lb)
AR: Aspect Ratio
TSLW0: T_SL/W0 Ratio (imperial)
W0S: W_0/S (lb/ft^2)
Ma_max: Max Mach #
K_vs: Variable Sweep Constant
%}
function wew0 = fwew0(W_0,AR,TSLW0,W0S,Ma_max,K_vs)
    a = -0.02; b = 2.16; c1 = -0.1; c2 = 0.2; c3 = 0.04; c4 = -0.1; c5 = 0.08; % For jet fighter
    wew0 = (a+b*(W_0^c1)*(AR^c2)*(TSLW0^c3)*(W0S^c4)*(Ma_max^c5))*K_vs;
    return;
end
