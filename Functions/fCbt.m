% Combat weight ratio
%{
TW: Thrust to weight
LD: Lift to drag
V: velocity knots
x: # full turns
C: specific fuel consumption
%}
function w2w1 = fCbt(TW,LD,V,x,C)
    g = 68680.75; % Grav accel knot/hr
    n = (TW*LD);
    d = (2*pi*V*x)/(g*sqrt((n^2)-1));
    w2w1 = 1 - C * (TW) * d; return;
end