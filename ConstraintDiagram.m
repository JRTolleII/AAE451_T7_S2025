%% AAE 451 GROUP 7 (HDI)

close all
clear
clc

%% Defining Input Parameters

g = 9.81; % gravity (m/s^2)
WL = linspace(1,1000,1000); % Wing Loading array

%% Takeoff curve

% Defining Takeoff Parameters
S_G = 2000*0.3048; % Takeoff ground run (m)
beta = 1; % Weight fraction (1 at takeoff)
% Velocity used below is V_LOT = 120 knots (F-15 V_LOT)
q = 0.5 * 1.225 * (61.73336/sqrt(2))^2; % Dynamic Pressure (N/m^2)
CL_max = 1.2; % Max CL during TO (common value for fighter jets)
CD_TO = 0.025; % Typical turboprop military trainer value
CL_TO = 0.7; % Typical turboprop military trainer value
mu = 0.04; %Ground friction constant (typical value is 0.04)

T_loading_TO = (1.21./(g.*q.*CL_max.*S_G)) .* (WL) + (0.605./CL_max) .* (CD_TO - mu*CL_TO) + mu;



%% Climb Curve

% Defining Climb Parameters
% 35,000 ft in a minute in less than 4.8 nautical miles
rateofclimb = (35000/1) * (0.3048) * (1/60);
V_x = (4.8/1) * (1852) * (1/60);
V_v = rateofclimb; % Vertical speed (m/s)
Vinf = sqrt((V_v^2) + (rateofclimb^2)); % Airspeed (m/s)
q = 0.5 * (1.225/3) * (Vinf)^2; % Redefine rho
CD_min = 0.022; % Minimum CD
k = 1 / (pi * 0.73 * 2.5); % assuming AR=2.5 & e=0.73 (Tradeoff study needed)

T_Loading_Climb = (V_v./Vinf) + (q./WL).*CD_min + (k./q) .* (WL);

%% +7/-3 g Turn Curve

n = sqrt(1 + (7)^2); % Load factor

T_Loading_Turn = q .* ((CD_min ./ WL) + k .* (n./q).^2 .* WL);

%% Constant Altitude/Speed Cruise (P_s = 0)

q = 0.5 * 0.3796 * (257.9421)^2; % Dynamic pressure (using F-16 cruise speed)
CD_min = 0.022; % Minimum CD

T_Loading_SL = (q .* CD_min .* (1./WL)) + (k .* (1./q) .* WL);

%% Landing Curve NOT DONE




%% Plotting

plot(WL,T_loading_TO,"--b");
hold on
plot(WL,T_Loading_Climb,"--r");
plot(WL,T_Loading_SL,"--g");
plot(WL,T_Loading_Turn,"--k");
legend("Takeoff","Climb","Cruise","Sustained Turn")
title('Constraint Diagram Iteration 1');
xlabel('Wing Loading');
ylabel('Thrust to Weight');

xlim([0 1000]);
ylim([0 10]);