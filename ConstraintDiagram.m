%% AAE 451 GROUP 7 (HDI)

close all
clear
clc

%% Defining Input Parameters

g = 9.81; % gravity (m/s^2)
WL = linspace(0,10000,10000); % Wing Loading array

% The following parameters are guesses, and will be refined through trade
% study and sizing.

AR = 4; % Aspect Ratio
e = 0.85; % Oswald efficiency Factor



%% Takeoff curve

% Defining Takeoff Parameters
S_G = 2000*0.3048; % Takeoff ground run (m)
% Velocity used below is V_LOT = 120 knots (F-15 V_LOT)
q = 0.5 * 1.225 * (61.73336/sqrt(2))^2; % Dynamic Pressure (N/m^2)
CL_max = 2.2; % Max CL during TO  (F-16 estimate)
CD_TO = 0.69; % F-16 value
CL_TO = 1.86; % F-16 value
mu = 0.04; %Ground friction constant (typical value is 0.04)
alpha = 0.68; %?

% Beta is ommitted because it equals 1 at takeoff
T_loading_TO = (1/alpha) .* ((1.21./(g.*q.*CL_max.*S_G)) .* (WL) + (0.605./CL_max) .* (CD_TO - mu*CL_TO) + mu);



%% Climb Curve

% Defining Climb Parameters
% 35,000 ft in a minute in 4.8 nautical miles (from RFP)
rateofclimb = (35000/1) * (1/3.281) * (1/60); % converted from ft/min to m/s
V_x = (4.8/1) * (1852) * (1/60); % Converted from nm/min to m/s
V_v = rateofclimb; % Vertical speed (m/s)
Vinf = sqrt((V_v^2) + (V_x^2)); % Airspeed (m/s)
q = 0.5 * (0.736) * (Vinf)^2; % Redefine rho
CD_min = 0.022; % Minimum CD
k = 1 / (pi * AR * e); % (Tradeoff study needed for AR and e)

% Normalizing to SL
beta = 0.97; % Guess based on F16 climb weight fraction 
alpha = 0.49; % Guess based on average altitude of 17500 ft (using Raymer fig 5.1)


T_Loading_Climb = (beta./alpha).*((V_v./Vinf) + (q./(WL.*beta)).*CD_min + (k./q) .* (WL.*beta));

%% +7 g Turn Curve
% At 35000 ft
n = sqrt(1 + (7)^2); % Load factor
Vinf = 7*g/(18 * 2*pi/360);
q = 0.5 * (0.379) * (Vinf)^2;

% Normalizing to SL
beta = 0.9; % Guess based on F16 cruise weight fraction 
alpha = 0.21; % Value for LBP turbofan @ 35000 ft


T_Loading_Turn = (beta./alpha) .* (q .* ((CD_min ./ (WL.*beta)) + k .* ((n./q).^2) .* (WL.*beta)));

%% -3 g Turn Curve

n = sqrt(1 + (3)^2); % Load factor
Vinf = 3*g/(18 * 2*pi/360);
q = 0.5 * (0.379) * (Vinf)^2;

% Normalizing to SL
beta = 0.9; % Guess based on F16 cruise weight fraction 
alpha = 0.21; % Value for LBP turbofan @ 35000 ft


T_Loading_Turn2 = (beta./alpha) .* (q .* ((CD_min ./ (WL.*beta)) + k .* ((n./q).^2) .* (WL.*beta)));


%% Constant Altitude/Speed Cruise (P_s = 0) 35000 ft
% Assuming 35000ft 
q = 0.5 * 0.379 * (259.2832)^2; % Dynamic pressure (using F-16 cruise speed)
CD_min = 0.022; % Minimum CD


% Normalizing to SL
beta = 0.9; % Guess based on F16 cruise weight fraction
% Could be up to the beta value for climb
alpha = 0.21; % Value for LBP turbofan @ 35000 ft


T_Loading_Cruise = (beta./alpha).*((q .* CD_min .* (1./(WL .* beta))) + (k .* (1./q) .* (WL.*beta)));

% %% Constant Altitude/Speed Cruise (P_s = 0) 25000 ft
% % Assuming 35000ft 
% q = 0.5 * 0.5669 * (259.2832)^2; % Dynamic pressure (using F-16 cruise speed)
% CD_min = 0.022; % Minimum CD
% 
% 
% % Normalizing to SL
% beta = 0.9; % Guess based on F16 cruise weight fraction
% % Could be up to the beta value for climb
% alpha = 0.21; % Value for LBP turbofan @ 35000 ft
% 
% 
% T_Loading_Cruise2 = (beta./alpha).*((q .* CD_min .* (1./(WL .* beta))) + (k .* (1./q) .* (WL.*beta)));
% 

%% Landing Curve NOT DONE




%% Plotting
WL_imperial = WL .*0.020885;
plot(WL_imperial,T_loading_TO,"-b");
hold on
plot(WL_imperial,T_Loading_Climb,"-r");
plot(WL_imperial,T_Loading_Cruise,"-g");
plot(WL_imperial,T_Loading_Turn,"-k");
plot(WL_imperial,T_Loading_Turn2,"-c")
legend("Takeoff","Climb","Cruise (35k ft)","Sustained Turn (+7g)","Sustained Turn (-3g)")
title('Constraint Diagram Iteration 1');
xlabel('Wing Loading (Lb_f/ft^2)');
ylabel('Thrust to Weight');
xlim([0 3000.*0.020885]);
ylim([0 8]);