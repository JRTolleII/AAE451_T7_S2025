% Dynamic Pressure
%{
rho: Density (slug/ft^3)
V: Velocity (kts)
%}
function q = fq(rho,V)
    q = 0.5 * rho * (V * 1.688)^2; return;
end