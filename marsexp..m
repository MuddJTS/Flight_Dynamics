% booster specs

burntime = 2;
D = 0.2; % in meters
Ap = pi*D^2/4; % m^2
CD = .7;
m_initial = 34; % total mass in kg of entire system 
Alt = 1401; % altitude MSL of spaceport America
trange = [0 burntime];
xv0 = [m_initial; 0; Alt]; % Initial mass (kilograms), velocity, and altitude (meters).
% Altitude must be MSL, not AGL (alt is at spaceport america)

[t1, xv1] = ode45(@rockeqn_var, trange ,xv0); % Integrate the rocket equation

% Dart Specs
m_dart = 14; %kg
CD = .6;
Ap = pi*.086^2/4;


trangecoast = [burntime 100]; % The starting and ending times
xv_initialcoast = [m_dart, xv1(2), xv1(3)]; % Initial mass (kilograms), velocity, and altitude (meters).
% Altitude must be MSL, not AGL (alt is at spaceport america
[t2, xv2] = ode45(@rockeqn_var, trangecoast, xv_initialcoast); % Integrate the rocket equation

t = [t1,t2]
xv = [xv1,xv2]
% using ode45
a = afunc(t, xv); % Calculate the acceleration vector
yyaxis right
plot(t,a,'b--',t,xv(:,2),'r',t,xv(:,1),'m') % Plot v, x, mass vs t
yyaxis left
plot(t,xv(:,3),'g') % Plot a
legend('altitude','acceleration','velocity','mass')

function xvdot = rockeqn_var(t,xv)
% The rocket equation where T, P, rho, and g change with
% altitude. Theta is assumed constant.
mu = xv(1); %mass
u = xv(2);%velocity
x = xv(3);% altitude
ue = 259*9.8; % m/s Calculate as total impulse/propellant mass
D = 0.33; % in meters
Ap = pi*D^2/4; % m^2
CD = 0.5; % constant drag coefficient
rho = rho_atm(x); % kg/m^3
gloc = g_atm(x);% local gravitational acceleration
theta = 0; % angle of rocket
mudot = -ThrustCurveSH(t)/ue; %small change in mass due to ejected propellant
D = 0.5*CD*Ap*rho*u*abs(u); 
udot = -ue/mu*mudot - D/mu - gloc*cos(theta);
xdot = u;
xvdot = [mudot;udot;xdot];
end

function a = afunc(t, xv)
% Post calculate the acceleration vector
% This function must be vectorized, because we're using all of the values
% calculated by ode45. Note the 'transpose' and the  dot multiplies and
% divides, and the 'for' loop.
mu = xv(:,1);
u = xv(:,2);
x = xv(:,3);
ue = 1510.6; % m/s Calculate as total impulse/propellant mass
global Ap % m^2
global CD
rho = rho_atm(x); % kg/m^3
gloc = g_atm(x);
theta = 0;
for i = 1:length(t);
 mudot(i) = -ThrustCurveSH(t(i))/ue;
end
mudot = transpose(mudot);
D = 0.5*CD*Ap*rho.*u.*abs(u);
a = -ue*mudot./mu - D./mu - gloc*cos(theta);
end