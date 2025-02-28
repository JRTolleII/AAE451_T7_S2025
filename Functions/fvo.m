% Optimal Velocity from example
%{
W: Weight lb
rho: density slug/ft^3
A: Wing area ft^2
C_D0: zl drag ratio
AR: aspect ratio
e: oswald efficiency
vopt: optimal velocity Knots
%}
function vopt = fvo(W,rho,A,C_D0,AR,e)
    vopt = sqrt((2*W/(rho*A))*sqrt(1/(pi*AR*e*C_D0))) / 1.688; return;
end