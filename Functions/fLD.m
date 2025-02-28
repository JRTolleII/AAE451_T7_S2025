% L/D
%{
q: Dynamic pressure
CD_0: Skin drag
W: Weight
S: Surface area
AR: Aspect Ratio
ec: efficiency
%}
function LD = fLD(q,CD_0,W,S,AR,ec)
    LD = 1/(((q*CD_0)/(W/S))+((W/S)*(1/(q*pi*AR*ec)))); return;
end
