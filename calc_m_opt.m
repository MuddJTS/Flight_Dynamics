function [opt_mass, mass, alt] = calc_m_opt(min_m, max_m, init_data)
tf = init_data(1);
dt = init_data(2);
burntime = init_data(3);
Alt = init_data(4);
m_booster = init_data(5); % with fuel
trange = 0:dt:burntime;

PRECISION = 0.1; % kilograms
NUM_DIVISIONS = 4; % number of points checked each loop

max_alt = 0;
mass_vec = [];
alt_vec = [];

step = max_m - min_m;

while (step > PRECISION)
    step = step / NUM_DIVISIONS

    for i = min_m:step:max_m
        i
        m_initial = i + m_booster
        xv0 = [m_initial; 0; Alt] % Initial mass (kilograms), velocity, and altitude (meters).
        % Altitude must be MSL, not AGL (alt is at spaceport america)

        [~, xv1] = ode45(@rockeqn_var, trange ,xv0) % Integrate the rocket equation

        ja_burntime = burntime %"just after burntime" this avoids this step getting any thrust
        trangecoast = ja_burntime:dt:tf % The starting and ending times
        xv_initialcoast = [i, xv1(end,2), xv1(end,3)] % Initial mass (kilograms), velocity, and altitude (meters).
        % Altitude must be MSL, not AGL (alt is at spaceport america
        [~, xv2] = ode45(@rockeqn_var, trangecoast, xv_initialcoast) % Integrate the rocket equation
        xv = [xv1',xv2']'
        curr_max_alt = max(xv(:,3))
        mass_vec = [mass_vec i]
        alt_vec = [alt_vec curr_max_alt]

        if curr_max_alt > max_alt
            max_alt = curr_max_alt;
            opt_m = i;
        end
    end

    if opt_m - step > min_m
        min_m = opt_m - step;
    end
    if opt_m + step < max_m
        max_m = opt_m + step;
    end
    step = (max_m - min_m) / NUM_DIVISIONS;
        
end

opt_mass = opt_m;
mass = mass_vec;
alt = alt_vec;

end

function [xvdot, CD] = rockeqn_var(t,xv)
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