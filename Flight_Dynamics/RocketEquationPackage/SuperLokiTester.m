% This is the main script for the MARS Rocket simulator. The functions in
% this file collect density, temperature, thrust curve, etc. from auxiliary
% files and functions. The functions in this file are in charge of
% calculating acceleration using the rocket force equation, and integrating
% to get velocity and position.



% % % % % % % % % % % % % % Values from loki for testing Apogee = 70713.6 Meters % % % % % % % % % % % % % % % % % % % % % % 
tf = 150; % end time for simulation
dt = .1;
Alt = 0;%1401; % altitude MSL of spaceport America
burntime = 2.1; %to change motor specs, open thrustcurvesh.m. This code assumes separation occurs imediately after burn time ends
specific_impulse = 228.7; % s Calculate as total impulse/propellant mass
exit_velocity = specific_impulse * 9.807;

CD1 = 1.3; % Drag coefficient booster and dart combined
CD2 = .09; % Drag Coefficient dart
Ap1 = pi*(4*.0254)^2/4;% projected area of booster and dart combo in meeters sq
Ap2 = pi*(1.625*.0254)^2/4; %projected area of dart

 
m_dart = 14*.4536; %kg 0.453592 kg per lbs
m_booster = 16*.4536; %kg without propellant loaded
m_propellant = 43*.4536; %kg of propellant




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% % Script Inputs
tf = 250;
dt = .1; %time step that the system will be solved at
% burntime = 2.1; %to change motor specs, open thrustcurvesh.m. This code assumes separation occurs imediately after burn time ends
trange = [0 : dt : burntime]; % time before separation
% Alt = 1401; % altitude MSL of spaceport America
% specific_impulse = 259; % s Calculate as total impulse/propellant mass
% exit_velocity = specific_impulse * 9.807;
% 
% CD1 = .6; % Drag coefficient booster and dart combined
% CD2 = .5; % Drag Coefficient dart
% Ap1 = pi*.2^2/4;% projected area of booster and dart combo in meeters sq
% Ap2 = pi*.086^2/4; %projected area of dart
% 
%  
% m_dart = 26.9*.4536; %kg 0.453592 kg per lbs
% m_booster = 23*.4536; %kg without propellant loaded
% m_propellant = 50*.4536; %kg of propellant

m_initial = m_dart + m_booster + m_propellant; % total mass in kg of entire system

% due to the layout of the initial program, additional inputs were hard to
% add to functions.  global variables were used so equations inside
% functions could refference variables and the variables could be changed
% for different stages in the flight
% global CD;
global Ap;
global ue; % exit velocity
global n % used for what stage rocket is on for drag coefficient calc
global u;
Ap = Ap1; % Initial variable setting
% CD = CD1; %drag coefficient of booster and dart combined
ue = exit_velocity;
n = 0;

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
trangecoast = [ja_burntime:dt:tf]; % The starting and ending times
xv_initialcoast = [m_dart, xv1(end,2), xv1(end,3)]; % Initial mass (kilograms), velocity, and altitude (meters).
% Altitude must be MSL, not AGL (alt is at spaceport america
[t2, xv2] = ode45(@rockeqn_var, trangecoast, xv_initialcoast); % Integrate the rocket equation
a2 = afunc(t2, xv2); % Calculate the acceleration vector
t = [t1',t2'];
xv = [xv1',xv2']';

a = [a1',a2'];
% using ode45

yyaxis right
plot(t,a','b--',t,xv(:,2),'r',t,xv(:,1),'m') % Plot v, x, mass vs t
yyaxis left
plot(t,xv(:,3),'g') % Plot a
legend('altitude','acceleration','velocity','mass')

% Plot of Mach number over travel
figure (2)
c = c_atm(xv(:,3));
plot(abs(xv(:,2))./c)
xlabel('time (s)')
ylabel('Mach number')
title('Mach number over flight path')

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