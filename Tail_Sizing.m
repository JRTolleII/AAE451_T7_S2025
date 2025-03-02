%% Tail Wing sizing 
%Things to solve for
SHT %Horizontal tail surface area
SVT %Vertical tail surface area
bHT %Horizontal tail span
bVT %Vertical tail span
cHT %Horizontal tail average chord
cVT %Vertical tail average chord
lT %Required horizontal tail arm

%Things needed from the aircraft wing & fuselage design

SREF = 1; %wing area
cREF = 1; % wing chord
bREF = 1; %wingspan
R1 = 1; % Fuselage radius at wing quarter chord line
R2 = 1; %Fuselage radius at tail quarter chord line

% Things referenced from F-16V

VHT = .5; %Desired horizontal tail volume
VVT = .06; %Desired vertical tail volume
ARHT = 2; %Horizontal tail aspect ratio
ARVT = 1.5; %Vertical tail aspect ratio

%calculations
lT = sqrt(2 * SREF * (VHT * cREF + VVT * bREF)) / (pi * (R1 + R2));
SHT = VHT * SREF * cREF / lT;
SVT = VVT * SREF * bREF / lT;
bHT = sqrt(ARHT * SHT);
bVT = sqrt(ARVT * SVT);
cHT = bHT / ARHT;
cVT = bVT / ARVT;

%Conversion to Vtail
Gamma = arctain(sqrt(SVT / SHT)); % V tail Dihedral angle
S_VTail = SVT + SHT;
b_Vtail = bVT * 1.1;
c_VTail = S_VTail / b_VTail;