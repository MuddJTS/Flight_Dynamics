% This is the main script for the MARS Rocket simulator. The functions in
% this file collect density, temperature, thrust curve, etc. from auxiliary
% files and functions. The functions in this file are in charge of
% calculating acceleration using the rocket force equation, and integrating
% to get velocity and position.



% % % % % % % % % % % % % % Values from loki for testing Apogee = 70713.6 Meters % % % % % % % % % % % % % % % % % % % % % % 
tf = 120; % end time for simulation
dt = .1;
Alt = 0;%1401; % altitude MSL of spaceport America
burntime = 2.1; %to change motor specs, open thrustcurvesh.m. This code assumes separation occurs imediately after burn time ends
trange = [0, burntime]; % time before separation
specific_impulse = 228.7; % s Calculate as total impulse/propellant mass
exit_velocity = specific_impulse * 9.807;

Ap1 = pi*(4*.0254)^2/4;% projected area of booster and dart combo in meeters sq
Ap2 = pi*(1.625*.0254)^2/4; %projected area of dart

 
m_dart = 14*.4536; %kg 0.453592 kg per lbs
m_booster = 16*.4536; %kg without propellant loaded
m_propellant = 43*.4536; %kg of propellant

m_initial = m_dart + m_booster + m_propellant; % total mass in kg of entire system


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% % Script Inputs
% tf = 250;
% dt = .1; %time step that the system will be solved at
% burntime = 2.1; %to change motor specs, open thrustcurvesh.m. This code assumes separation occurs imediately after burn time ends
% trange = [0 : dt : burntime]; % time before separation
% Alt = 1401; % altitude MSL of spaceport America
% specific_impulse = 259; % s Calculate as total impulse/propellant mass
% exit_velocity = specific_impulse * 9.807;
% 
% Ap1 = pi*.2^2/4;% projected area of booster and dart combo in meeters sq
% Ap2 = pi*.086^2/4; %projected area of dart
% 
%  
% m_dart = 26.9*.4536; %kg 0.453592 kg per lbs
% m_booster = 23*.4536; %kg without propellant loaded
% m_propellant = 50*.4536; %kg of propellant
% 
% m_initial = m_dart + m_booster + m_propellant; % total mass in kg of entire system

% due to the layout of the initial program, additional inputs were hard to
% add to functions.  global variables were used so equations inside
% functions could refference variables and the variables could be changed
% for different stages in the flight
% global CD;
global Ap;
global ue; % exit velocity
global n; % used for what stage rocket is on for drag coefficient calc
global u;
global initial_piston_d
Ap = Ap1; % Initial variable setting
% CD = CD1; %drag coefficient of booster and dart combined
ue = exit_velocity;
n = 0;
initial_piston_d = 0.02; % m (2cm)

xv0 = [m_initial; 0; Alt]; % Initial mass (kilograms), velocity, and altitude (meters).
% Altitude must be MSL, not AGL (alt is at spaceport america)

[t1, xv1] = ode45(@rockeqn_var, trange ,xv0); % Integrate the rocket equation
a1 = afunc(t1, xv1); % Calculate the acceleration vector
% Dart Specs

% set the variables to new coefficients of the dart
% CD = CD2;
Ap = Ap2;
n = 1;

ja_burntime = burntime +.001; %"just after burntime" this avoids this step getting any thrust
trangecoast = [ja_burntime, tf]; % The starting and ending times
% xv_initialcoast = [m_dart, xv1(end,2), xv1(end,3)]; % Initial mass (kilograms), velocity, and altitude (meters).
xv_initialcoast = [xv1(end, 2), xv1(end, 3) + initial_piston_d, xv1(end, 2), xv1(end, 3)]; % initial_piston_d separation, same velocity
% Altitude must be MSL, not AGL (alt is at spaceport america)
% wrapper func
sim_func = @(t, xv)  separation_event(t, xv, m_dart, m_booster, Ap1, Ap2);
[t2, xv2] = ode45(sim_func, trangecoast, xv_initialcoast); % Integrate the rocket equation
m_vec = m_dart + zeros(size(xv2, 1), 1); % need to get vector back into the form we want
xv2_dart = [m_vec, xv2(:, 1:2)];
% a2 = afunc(t2, xv2_dart); % Calculate the acceleration vector
a2 = diff(xv2_dart(:, 2)) ./ diff(t2);
t = [t1',t2'];
xv = [xv1',xv2_dart']';

a = [a1',a2'];
% using ode45

figure(1);
yyaxis right
plot(t(2:end),a','b--',t,xv(:,2),'r',t,xv(:,1),'m') % Plot v, x, mass vs t
yyaxis left
plot(t,xv(:,3),'g') % Plot a
legend('altitude','acceleration','velocity','mass')

% Max Q calculation and plot
MaxQ(t,xv(:,2),xv(:,3));

% Plot of Mach number over travel
figure (2)
c = c_atm(xv(:,3));
plot(t, abs(xv(:,2))./c)
xlabel('time (s)')
ylabel('Mach number')
title('Mach number over flight path')

max_speed_mach = max(abs(xv(:,2))./c)
apogee_km = max(xv(:, 3))/1000

function [xvdot, CD] = rockeqn_var(t,xv);
% The rocket equation where T, P, rho, and g change with
% altitude. Theta is assumed constant.
mu = xv(1); %mass
u = xv(2);%velocity
x = xv(3);% altitude
global ue;
global Ap;
global n;
CD = Cd(n,u,x);
rho = rho_atm(x); % kg/m^3
gloc = g_atm(x);% local gravitational acceleration
theta = 0; % angle of rocket
mudot = -ThrustCurveSH(t)/ue; %small change in mass due to ejected propellant
D = 0.5.*CD.*Ap.*rho.*u.*abs(u); 
udot = -ue/mu*mudot - D/mu - gloc*cos(theta);
xdot = u;
xvdot = [mudot;udot;xdot];
end

function a = afunc(t, xv);
% Post calculate the acceleration vector
% This function must be vectorized, because we're using all of the values
% calculated by ode45. Note the 'transpose' and the  dot multiplies and
% divides, and the 'for' loop.
mu = xv(:,1);
u = xv(:,2);
x = xv(:,3);
global ue;
global Ap;
global n;
CD = Cd(n,u,x);
rho = rho_atm(x); % kg/m^3
gloc = g_atm(x);
theta = 0;
for i = 1:length(t);
 mudot(i) = -ThrustCurveSH(t(i))/ue;
end
mudot = transpose(mudot);
D = 0.5.*CD.*Ap.*rho.*u.*abs(u);
a = -ue*mudot./mu - D./mu - gloc*cos(theta);
end

function [xvdot, CD] = separation_event(t,xv, m_dart, m_booster, Ap_assy, Ap_dart);
% Models the explosive separation event between dart and booster.
t
u_dart = xv(1); %velocity of dart
x_dart = xv(2); % altitude of dart
u_booster = xv(3); %velocity of booster
x_booster = xv(4); % altitude of booster
CD_assy = Cd(0,u_booster,x_booster);
CD_dart = Cd(0,u_dart,x_dart);
rho_dart = rho_atm(x_dart); % kg/m^3
rho_boost = rho_atm(x_booster); % kg/m^3
gloc_dart = g_atm(x_dart);% local gravitational acceleration
gloc_boost = g_atm(x_booster);% local gravitational acceleration
theta = 0; % angle of rocket

% Gas-phase combustion products for black powder are:
%   CO2, CO, N2
% All of these are colinear molecules (CO2) or diatomic (CO, N2),
% so gamma = Cp/Cv = 7/5 is an OK approximation
gamma = 7/5;

% Calculate initial pressure
global initial_piston_d
piston_area = Ap_dart; % assume piston area is same as dart cross-section
initialT = 773.15; % K; based on estimate of 500 C burn temp.
initialV = initial_piston_d * piston_area;
charge_mass = 10; % g; 0.015 mol of gaseous products per gram charge
initialP = (charge_mass*0.015 * 8.314 * initialT) / initialV;% N/m^2; nRT / V; R = 8.314 J/(K-mol)

% adiabatic expansion: P*V^gamma = constant
adiabatic_const = initialP * initialV^gamma;

% Calculate instantaneous pressure
deltaX = x_dart - x_booster; % piston distance
pistonV = deltaX * piston_area; % instantaneous piston volume
P = adiabatic_const / pistonV^gamma;

% Make sure we are still inside the piston
piston_length = 0.15; % m; 15 cm
if 1 || deltaX > piston_length || (u_dart < 0 || u_booster < 0)
    P = 0
end

D_assy = 0.5.*CD_assy.*Ap_assy.*rho_boost.*u_booster.*abs(u_booster); 
D_dart = 0.5.*CD_dart.*Ap_dart.*rho_dart.*u_dart.*abs(u_dart); 
D_booster = D_assy - D_dart; % assumption! CD for booster after separation isn't super relavent due to tumbling, so don't expect accuracy here
u_dart_dot = - D_dart/m_dart - gloc_dart*cos(theta) + P*Ap_dart / m_dart;
u_booster_dot = - D_booster/m_booster - gloc_boost*cos(theta) - P*Ap_dart / m_booster;

x_dart_dot = u_dart;
x_booster_dot = u_booster;
xvdot = [u_dart_dot;x_dart_dot; u_booster_dot; x_booster_dot];
end