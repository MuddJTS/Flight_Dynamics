
% Integration of the rocket equation where T, P, rho, and g change with
% altitude. Theta is still assumed constant
% The current values are for the Mars-1 (any missing values taken from s.
% Loki)
trange = [0 100]; % The starting and ending times
xv0 = [34; 0; 1401]; % Initial mass (kilograms), velocity, and altitude (meters).
% Altitude must be MSL, not AGL (alt is at spaceport america
[t, xv] = ode45(@rockeqn_var, trange, xv0); % Integrate the rocket equation
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
D = 0.33; % m
Ap = pi*D^2/4; % m^2
CD = 0.7; % Drag Coefficient
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
