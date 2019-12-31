% This program is used to calculate the overall forces on the vehicle.
% 1. Parameters such as geometric dimensions of bodies, speeds, altitude,
% thrust are defined
% 2. Normal forces and force locations are determined
% 3. Drag forces are calculated.
%% Input variables
% initiate vectors for data collection in for loop
Cn = [];%normal coeffiient matrix
Fn =[];% normal force matrix
Xn = []; %center of pressure matrix
Cd = [];
Fd = [];
% specify the phase of flight

%0 = booster and dart are still coupled, powered flight
%1 = booster and dart are still coupled, coasting
%2 = separated, dart in coast phase

phase = 1; 
%% rocket geometry

%bodies
D_booster = 0.1905; %diameter of booster in meters
D_dart = 0.0889; %diameter of dart in meters
L_booster = 2.9718; %length of booster in meters
L_dart = 1.9298; %length of dart in meters
L_nose = .3048; %length of the nose cone
L_coupler = .3048; %Length of interstage coupler
L_cm = 3.6322 - L_dart;%distance to center of mass from top of booster stage
A_booster = D_booster^2*pi/4; %cross sectional area of booster in meters
A_dart = D_dart^2*pi/4;  %cross sectional area of dart in meters

%fin
b_boosterfin = 0.3556; %2* the span of the wing (m), (how far it projects out). 7 inches for initial rocksim stability
b_dartfin = 0.11176; % span of wing set for dart
S_surface_boosterfin = 0.06096762*2; %projected surface of booster fin (square meters)
S_surface_dartfin = 0.015116099; %projected surface of dart fin
aspectratio_booster = b_boosterfin^2/S_surface_boosterfin;
aspectratio_dart = b_dartfin^2/S_surface_dartfin;
w_boosterfin = 0.015; %still very up in the air (.5 inches for now?
w_dartfin = 0.01;
t_mac_boosterfin = w_boosterfin;%thickness of mean aerodynamic chord
t_mac_dartfin = w_dartfin;%thickness of mean aerodynamic chord
S_ref_boosterfin = b_boosterfin*w_boosterfin; % still very uncertain what the textbook uses for reference area. For now, using the projected area of fin at 0 AoA 
S_ref_dartfin = b_dartfin*w_dartfin;
location_boosterfin = L_dart + L_booster-0.6731;% location of start of fin from nose cone tip
location_dartfin = L_dart - .254;% location of start of fin from nose cone tip
meanRC_boosterfin = 0.3302; %mean root chord (meters)
meanRC_dartfin = 0.13081;%mean root chord (meters)
num_dartfin = 4; %number of dart fin
num_boosterfin = 4; %number of booster fin
lambda_boosterfin = 30*pi/180; %sweep angle angle of fin
lambda_dartfin = 30*pi/180;
delta_le_boosterfin = 10*pi/180; %fins front chamfer angle
delta_le_dartfin = 10*pi/180;



% dynamic parameters
V = [1:10:2000]; %velocity in m/s
F_thrust = 57 *10^3; %Thrust at max Q (max Thrust because progressive burn)
AoA = 2*pi/180;%angle of attack in radians (max for similar design at max Q is 2 degrees
AoA_local = AoA; % local angle of attack of fin, accounts for canted fin angle
z = 1; % altitude in meters ASL. constant for this model. This is used in Velocity --> Mach calculation
rho = rho_atm(z); %density of air at max Q (km/m^2), assuming sea level for now
c = c_atm(z); % speed of sound
gamma = 1.4; %specific heat ratio for air

for v = V  % collecting data for a variety of velocities

q =.5*rho*v^2; %aerodynamic pressure
mach = v/c; % Mach number

%% normal forces on bodies (including coupler and nose cone)

Cn_boosterbody = sin(2*AoA)*cos(2*AoA)+1.3*(L_booster/D_booster)*sin(AoA)^2;%the normal force coeficient (approx lift coefficient at small AoA)
Cn_dartbody = sin(2*AoA)*cos(2*AoA)+1.3*(L_dart/D_dart)*sin(AoA)^2;%the normal force coeficient (approx lift coefficient at small AoA)

x_aero_boosterbody = (0.63*(1-sin(AoA)^2)+0.5*(L_dart/L_coupler)*sin(AoA)^2)*L_coupler + L_dart;%center of pressure for booster body
x_aero_dartbody = (0.63*(1-sin(AoA)^2)+0.5*(L_dart/L_nose)*sin(AoA)^2)*L_nose;%center of pressure for dart body

Fn_boosterbody = Cn_boosterbody*q*A_booster; %Normal Force on Booster body
Fn_dartbody = Cn_dartbody*q*A_dart; %Normal force on Dart body

%% normal forces on fin (treating the pair of fin as one flat planform)
%note our wings are not canted so we can use AoA as the local angle of
%atack of the wings.  If the fin were canted, we would use AoA + cant
%angle

M_max_booster = sqrt(1+(8/(pi*aspectratio_booster))^2);% threshold that determines whether to use slender wing theory or linear wing theory
M_max_dart = sqrt(1+(8/(pi*aspectratio_dart))^2);% threshold for dart

% Normal Force coefficient (Cn) which is approximately equal to the lift at
% small angles of attack

if mach > M_max_booster %if the velocity of the vehicle is larger than the threshold,
    Cn_boosterfin = (4*sin(AoA)*cos(AoA)/sqrt(mach^2-1)+2*sin(AoA)^2)*(S_surface_boosterfin/S_ref_boosterfin); %linear wing theory plus newtonian theory
else 
    Cn_boosterfin = ( (pi*aspectratio_booster/2)*sin(AoA)*cos(AoA)+2*sin(AoA)^2)*(S_surface_boosterfin/S_ref_boosterfin); %slender wing theory
end


if mach > M_max_dart %if the velocity of the vehicle is larger than the threshold,
    Cn_dartfin = (4*sin(AoA)*cos(AoA)/sqrt(mach^2-1)+2*sin(AoA)^2)*(S_surface_dartfin/S_ref_dartfin);%linear wing theory plus newtonian theory
else
    Cn_dartfin = ( (pi*aspectratio_dart/2)*sin(AoA)*cos(AoA)+2*sin(AoA)^2)*(S_surface_dartfin/S_ref_dartfin);%slender wing theory
end

% calculating the center of pressure on the fin (measured from the tip of
% the nose cone. These thresholds are given from missile Design textbook

if mach < .7 % if velocity is below mach 7,
    x_aero_boosterfin = location_boosterfin + meanRC_boosterfin/4; % Normal force acts at 25% of mean root chord (m)
    x_aero_dartfin = location_dartfin + meanRC_dartfin/4;
elseif mach < 2
    x_aero_boosterfin = location_boosterfin + meanRC_boosterfin*(257907/959690 + sqrt(-13112145783 + 19193800000 *mach)/959690); %quadratic interpolation to try to match the Xn vs. Mach in textbook. The textbook does not give an equation for this speed regime  
    x_aero_dartfin = location_dartfin + meanRC_dartfin*(257907/959690 + sqrt(-13112145783 + 19193800000 *mach)/959690);
else
    x_aero_boosterfin = location_boosterfin + ( (aspectratio_booster*sqrt(mach^2-1)-.67)/(2*aspectratio_booster*sqrt(mach^2-1)-1))*meanRC_boosterfin; % normal force location when mach ~> 2
    x_aero_dartfin = location_dartfin + ( (aspectratio_dart*sqrt(mach^2-1)-.67)/(2*aspectratio_dart*sqrt(mach^2-1)-1))*meanRC_dartfin; % used same fit as booster because lazy and not that important. That is reason for discontinuity here
end

Fn_boosterfin = Cn_boosterfin*q*S_ref_boosterfin; %normal force on fin
Fn_dartfin = Cn_dartfin*q*S_ref_dartfin;

%% model vallidation for normal forces
% these forces are all on the same order of magnitude as falcon Launch VII
% source. However, the center of pressure of the vehicle does not match the
% center of pressure on rocksim. at low mach numbers, there is a
% discrepancy of 2.36 calipers between the rocksim model and the matlab
% model.

%% Drag force predictions
% For fin
M_le_boosterfin = mach*lambda_boosterfin;%local mach number of fin
M_le_dartfin = mach*lambda_dartfin;%local mach number of fin

Cd_skin_boosterfin = 2*(.0133*(mach/(q*0.06852*meanRC_boosterfin))^.2)*(2*S_surface_boosterfin/S_ref_boosterfin);% skin friction prediction
Cd_skin_dartfin = 2*(.0133*(mach/(q*0.06852176818*meanRC_dartfin))^.2)*(2*S_surface_dartfin/S_ref_dartfin);

if M_le_boosterfin<1 %if shock waves are not present
    Cd_wave_boosterfin = 0; %no wave drag
else
    Cd_wave_boosterfin = 2*(2/(gamma*M_le_boosterfin^2))*((((gamma + 1)*M_le_boosterfin^2)/2)^(gamma/(gamma-1)) * ((gamma + 1)/(2*gamma*M_le_boosterfin^2-(gamma-1)))^(1/(gamma-1))-1)*sin(delta_le_boosterfin)^2*cos(lambda_boosterfin*t_mac_boosterfin*b_boosterfin/S_ref_boosterfin);
end

if M_le_dartfin<1 %if shock waves are not present
    Cd_wave_dartfin = 0;
else
    Cd_wave_dartfin = 2*(2/(gamma*M_le_dartfin^2))*((((gamma + 1)*M_le_dartfin^2)/2)^(gamma/(gamma-1)) * ((gamma + 1)/(2*gamma*M_le_dartfin^2-(gamma-1)))^(1/(gamma-1))-1)*sin(delta_le_dartfin)^2*cos(lambda_dartfin*t_mac_dartfin*b_dartfin/S_ref_dartfin);
end

Cd_boosterfin = Cd_wave_boosterfin + Cd_skin_boosterfin;
Cd_dartfin = Cd_wave_dartfin + Cd_skin_dartfin;

Fd_boosterfin = Cd_boosterfin*S_ref_boosterfin*q;
Fd_dartfin = Cd_dartfin*S_ref_dartfin*q;
% drag on body

Cd_friction_boosterbody = 0.053*(L_booster/D_booster)*(mach/(0.06852*q*L_booster))^.2;
Cd_friction_dartbody = 0.053*(L_dart/D_dart)*(mach/(0.06852*q*L_dart))^.2;

if mach<1
    Cd_wave_boosterbody = 0;
    Cd_wave_dartbody = 0;
else
    Cd_wave_boosterbody = (1.586 + 1.834/mach^2)*(atan(0.5/(L_coupler/D_booster)))^1.69;
    Cd_wave_dartbody = (1.586 + 1.834/mach^2)*(atan(0.5/(L_nose/D_dart)))^1.69;
end

if phase == 0 %still coupled, in powered mode
        Cd_base_boosterbody = 0; %for coast. For powered flight, negligible
        Cd_base_dartbody = 0; %for coast. For powered flight, negligible
        
elseif phase == 1 %still coupled, motor just burnt out
    if mach>1
        Cd_base_boosterbody = 0.25/mach; %for coast. For powered flight, negligible
        Cd_base_dartbody = 0; %for coast. For powered flight, negligible
    else
        Cd_base_boosterbody = 0.12 + 0.13*mach^2; %for coast. For powered flight, negligible    
        Cd_base_dartbody = 0; %for coast. For powered flight, negligible    
    end

elseif phase == 2 %separated, only dart is coasting
    if mach>1
        Cd_base_boosterbody = 0.25/mach; %for coast. For powered flight, negligible
        Cd_base_dartbody = 0.25/mach; %for coast. For powered flight, negligible
    else
        Cd_base_boosterbody = 0.12 + 0.13*mach^2 %for coast. For powered flight, negligible    
        Cd_base_dartbody = 0.12 + 0.13*mach^2 %for coast. For powered flight, negligible    
    end
end
    
Cd_boosterbody = Cd_friction_boosterbody + Cd_base_boosterbody + Cd_wave_boosterbody;
Cd_dartbody = Cd_friction_dartbody + Cd_base_dartbody + Cd_wave_dartbody;

Fd_boosterbody = Cd_boosterbody*A_booster*q;
Fd_dartbody = Cd_dartbody*A_dart*q;

Fd_total = Fd_boosterbody+Fd_dartbody+Fd_boosterfin+Fd_dartfin;
Cd_total = Fd_total/q/A_booster;

%% Computing averages for total vehicle normal force and location
% sum(force x moment arm) / total force = center of pressure
Fn_total = (Fn_boosterfin+Fn_dartfin+Fn_boosterbody+Fn_dartbody);
Cp_total = (x_aero_boosterfin*Fn_boosterfin+x_aero_dartfin*Fn_dartfin+x_aero_boosterbody*Fn_boosterbody+x_aero_dartbody*Fn_dartbody)/(Fn_boosterfin+Fn_dartfin+Fn_boosterbody+Fn_dartbody);
Cn_total = (Cn_boosterfin+Cn_dartfin+Cn_boosterbody+Cn_dartbody);
x_aero_transition = L_dart+ L_coupler/3*(1 + (1-D_dart/D_booster)/(1-(D_dart/D_booster)^2));

Cn = [Cn,[Cn_total;Cn_dartbody;Cn_boosterbody;Cn_dartfin;Cn_boosterfin]];
Fn =[Fn,[Fn_total;Fn_dartbody;Fn_boosterbody;Fn_dartfin;Fn_boosterfin]];
Xn = [Xn,[Cp_total;x_aero_dartbody;x_aero_boosterbody;x_aero_dartfin;x_aero_boosterfin]];
Cd = [Cd, [Cd_total;Cd_skin_boosterfin;Cd_skin_dartfin;Cd_wave_boosterfin;Cd_wave_dartfin;Cd_boosterfin;Cd_dartfin;Cd_friction_boosterbody;Cd_friction_dartbody;Cd_wave_boosterbody;Cd_wave_dartbody;Cd_base_boosterbody;Cd_base_dartbody;Cd_boosterbody]];
Fd = [Fd,[Fd_total;Fd_boosterbody;Fd_dartbody;Fd_boosterfin;Fd_dartfin]];
end