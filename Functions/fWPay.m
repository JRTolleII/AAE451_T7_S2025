% Find Current Payload
%{
We will use a ledger to keep track of any additional aircraft weight.
wLed = []
A = # Missiles
B = # Cannons
C = # Unspent Cartridges (C + D = 500)
D = # Spent Cartridges (C + D = 500)
E = # Ammunition Feed Systems
F = # ICNIA
G = # Data Busses
H = # INEWS
I = # Vehicle Management Systems
J = # IRSTS
K = # Active Array Radars
L = # Electrical Systems
M = # Engines
N = # APUs
wLed = [A B C D E F G H I J K L M N]
wPl = Current Payload Weight (lbm)
%}
function wPl = fWPay(wLed)
    wPl = wLed(1) * 327;
    wPl = wPl + wLed(2) * 275;
    wPl = wPl + wLed(3) * 0.58;
    wPl = wPl + wLed(4) * 0.26;
    wPl = wPl + wLed(5) * 300;
    wPl = wPl + wLed(6) * 100;
    wPl = wPl + wLed(7) * 10;
    wPl = wPl + wLed(8) * 100;
    wPl = wPl + wLed(9) * 50;
    wPl = wPl + wLed(10) * 50;
    wPl = wPl + wLed(11) * 450;
    wPl = wPl + floor(wLed(13)/2)*300 + mod(wLed(13),2)*220;
    wPl = wPl + wLed(14) * 100;
    return;
end