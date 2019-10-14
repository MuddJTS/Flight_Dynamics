tf = 150;% final time for simulation
dt = .1; %time step that the system will be solved at
burntime = 2.1; %to change motor specs, open thrustcurvesh.m. This code assumes separation occurs imediately after burn time ends
Alt = 1401;
m_booster = 34.8*.4536; %kg without propellant loaded
m_propellant = 43*.4536; %kg of propellant

global ue;
global Ap;
global n;

Ap1 = pi*(7.5*.0254)^2/4; % projected area of booster and dart combo in meeters sq
specific_impulse = 259; % s Calculate as total impulse/propellant mass
exit_velocity = specific_impulse * 9.807;
Ap = Ap1; % Initial variable setting
ue = exit_velocity;
n = 0;


init_data = [tf, dt, burntime, Alt, m_booster + m_propellant];
[opt_mass, mass, alt] = calc_m_opt(20*.4536, 30*.4536, init_data)