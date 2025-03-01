%% AAE451 Sizing Code Team 7
clc; clf; clear; close all; addpath('Functions');


%% Notes
%{
Following the diagram from the sizing lecture
Using sizing for our baseline aircraft following our mission.
%}
%% End Notes


%% Mission Conditions
% Optimal Conditions (50k ft as per baseline aircraft ceiling) https://www.af.mil/About-Us/Fact-Sheets/Display/Article/104505/f-16-fighting-falcon/
rho_opt = 0.000364; % density at 50k ft slug/ft^3 https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
a_opt = 573; % Sonic velocity knots https://www.military-airshows.co.uk/speedofsound.htm
% Sea Level Conditions
rho_sl = 0.002378; % sl/ft^3 https://www2.anac.gov.br/anacpedia/ing-por/tr1611.htm
a_sl = 661; % Sonic velocity knots https://www.military-airshows.co.uk/speedofsound.htm
% 35000 ft
rho_35k = 0.000738; % Density sl/ft^3 https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
a_35k = 576; % Sonic velocity knots https://www.military-airshows.co.uk/speedofsound.htm
%% End Mission Conditions


%% Design Specifications
Ma_max = 1.6; % Max mach #, set to requirement
W_0 = 48000; % Gross weight (lb), set as baseline aircraft to start
C_cr = 0.8; C_lt = 0.7; % SFC from raymer table 3.3 for low bypass turbofan
C_D0 = 0.015; % Zero lift drag coeff for jets in raymer 5.3.7
ec = 0.7; % Oswald efficiency for fighter raymer 5.3.7
M_cr = 0.9; % Cruise Mach # 
K_vs = 1; % K_vs = 1.04; % Variable sweep constant, remove first % if variable sweep == yes
AR = 4.11*Ma_max^-0.622; % Aspect Ratio from raymer 4.3.1 table 4.1 for jet fighter
TSLW0 = 0.514*Ma_max^0.141; % Thrust to weight ratio from raymer 5.2.4 thrust matching for jet fighter
W0S = 88.3; % Weight to area ratio (lb/ft^2), taken from baseline aircraft
%% End Design Specifications


%% Payload Weights
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
%}
wLed = [1 1 500 0 1 1 1 1 1 1 1 1 1 1];
% Use fWPay(wLed) to find payload weight using the ledger
W_missile = 327; % Missile Weight (lbm)
%W_pl = fWPay(wLed);
W_pl = W_missile;
%% End Payload Weights


%% Calculation
W_0t = W_0 * 1.5; % Temp W_0 Value (lbm) 
% Looping to get the weights set
count = 0; % # Iterations
while ((W_0 > 1.005*W_0t)||(W_0 < 0.995*W_0t)) % While not converging within +- 0.5%
    count = count + 1;
    W_0t = W_0; % Holding old W_0
    T = TSLW0 * W_0;
    A = W_0 / W0S; % Wing area ft^2
    W_e = W_0t * fwew0(W_0t,AR,TSLW0,W0S,Ma_max,K_vs); % Finding empty weight
    % Mission for fuel
    W_fc = zeros(1,12); % Consumed Fuel
    w1w2 = zeros(1,12); % Weight ratio
    % Takeoff x
    w1w2(1) = 0.97; % Textbook value (Low end to account for warmup?)
    W_fc(1) = ffc(W_0,w1w2(1));
    W_0 = W_0 - W_fc(1);
    % Climb to opt altitude x
    v_cr = fvo(W_0,rho_opt,A,C_D0,AR,ec);
    M_cr = v_cr / a_opt;
    w1w2(2) = 1.0065 - 0.0325 * M_cr; % Raymer 6.3.6
    W_fc(2) = ffc(W_0,w1w2(2));
    W_0 = W_0 - W_fc(2);
    % Cruise 300 nm @ opt alt & vel x
    v_cr = fvo(W_0,rho_opt,A,C_D0,AR,ec);
    M_cr = v_cr / a_opt;
    q_opt = fq(rho_opt,v_cr);
    LD_opt = fLD(q_opt,C_D0,W_0,A,AR,ec);
    w1w2(3) = fBrCr(300,C_cr,v_cr,LD_opt);
    W_fc(3) = ffc(W_0,w1w2(3));
    W_0 = W_0 - W_fc(3);
    % Patrol for 4 hr loiter 35k feet x
    v_lt = 0.76 * fvo(W_0,rho_35k,A,C_D0,AR,ec); % 0.76 taken from excel example for loiter speed
    q_lt = fq(rho_35k,v_lt);
    LD_35k = fLD(q_lt,C_D0,W_0,A,AR,ec);
    w1w2(4) = fBrLo(4,C_lt,LD_35k);
    W_fc(4) = ffc(W_0,w1w2(4));
    W_0 = W_0 - W_fc(4);
    % 100 nm dash x
    v_cr = a_35k * Ma_max;
    q_cr = fq(rho_35k,v_cr);
    LD_35k = fLD(q_cr,C_D0,W_0,A,AR,ec);
    w1w2(5) = fBrCr(100,C_cr,v_cr,LD_35k);
    W_fc(5) = ffc(W_0,w1w2(5));
    W_0 = W_0 - W_fc(5);
    % One sustained 360o turn (Ps = 0) at Mach = 1.2 x
    v_cr = a_35k * 1.2;
    q_cr = fq(rho_35k,v_cr);
    LD_35k = fLD(q_cr,C_D0,W_0,A,AR,ec);
    TW = T / W_0;
    w1w2(6) = fCbt(TW,LD_35k,v_cr,1,C_cr);
    W_fc(6) = ffc(W_0,w1w2(6));
    W_0 = W_0 - W_fc(6);
    % One sustained 360o turn (Ps = 0) at Mach = 0.9 x
    v_cr = a_35k * 0.9;
    q_cr = fq(rho_35k,v_cr);
    LD_35k = fLD(q_cr,C_D0,W_0,A,AR,ec);
    TW = T / W_0;
    w1w2(7) = fCbt(TW,LD_35k,v_cr,1,C_cr);
    W_fc(7) = ffc(W_0,w1w2(7));
    W_0 = W_0 - W_fc(7);
    % Fire Missiles x
    W_0 = W_0 - W_missile;
    % Climb to opt alt x
    w1w2(8) = 0.99; % Value from example for climbing while already at speed
    W_fc(8) = ffc(W_0,w1w2(8));
    W_0 = W_0 - W_fc(8);
    % 400 nm cruise at opt x
    v_cr = fvo(W_0,rho_opt,A,C_D0,AR,ec);
    M_cr = v_cr / a_opt;
    q_opt = fq(rho_opt,v_cr);
    LD_opt = fLD(q_opt,C_D0,W_0,A,AR,ec);
    w1w2(9) = fBrCr(400,C_cr,v_cr,LD_opt);
    W_fc(9) = ffc(W_0,w1w2(9));
    W_0 = W_0 - W_fc(9);
    % Descent to Sea Level x
    w1w2(10) = 0.992; % From textbook
    W_fc(10) = ffc(W_0,w1w2(10));
    W_0 = W_0 - W_fc(10);
    % Loiter Sea Level 0.5 hr x
    v_lt = 0.76 * fvo(W_0,rho_sl,A,C_D0,AR,ec); % 0.76 taken from excel example for loiter speed
    q_lt = fq(rho_sl,v_lt);
    LD_sl = fLD(q_lt,C_D0,W_0,A,AR,ec);
    w1w2(11) = fBrLo(0.5,C_lt,LD_sl);
    W_fc(11) = ffc(W_0,w1w2(11));
    W_0 = W_0 - W_fc(11);
    % Land x
    w1w2(12) = 0.994; % From Textbook
    W_fc(12) = ffc(W_0,w1w2(12));
    % Gross
    W_f = sum(W_fc); % Fuel Weight (lbm)
    W_0 = W_e + W_f + W_pl; % New gross weight
    fprintf('It: %f\n',count);
    fprintf('W_0: %f\n',W_0);
    fprintf('W_e: %f\n',W_e);
    fprintf('W_f: %f\n',W_f);
    fprintf('\n');
end
%% End Calculation