m_dart = 25.65*.4536; %kg, 0.453592 kg per lbs
m_booster = 34.8*.4536; %kg without propellant loaded

Cd_drogue = 0.7; % Drag coefficient. I believe this is typical if you are reffering to the completely open projected area
Cd_Main = 0.7; 
Cd_booster_chute = 0.7;

A_drogue = 5; %Projected area of open parachute (in m^2)
A_main = 10; 
A_booster_chute = 10;

t0 = 0; %time that simulation begins
tf = 400; %time that simulation ends
dt = .01; %time step for simulation
time = [t0:dt:tf];

x0_dart = 100*10^3; %initial height (m) of dart when drogue pops out
x0_main = 1*10^3; %initial height (km) when main pops out
x0_booster = 20*10^3; %initial height (km) when booster parachute pops out

v0_dart = 0; %initial velocity (m/s) of dart when drogue pops out
v0_main = 0; %initial height (m/s) when main pops out
v0_booster = 0; %initial height (m/s) when booster parachute pops out

% set up vectors to track parameters
position = [];
velocity = [];
acceleration = [];

% set initial conditions for loop
x = x0_dart;
v = v0_dart;
A = A_drogue;
Cd = Cd_drogue;
m = m_dart;

  for i = time
    rho_atm(x); % finds rho for a given altatude
    gloc = 9.8;%g_atm(x)% local gravitational acceleration
    
    D = 0.5.*Cd.*A.*rho.*v.*abs(v); %drag force
    a = -gloc - D/m; %acceleration from newtons second law (F = ma)
    v = v + a*dt; %calculates new velocity
    x = x + v*dt + .5*a*dt^2; %calculates new position
    
    % concatinate new step onto tracking vectors
    position = [position, x];
    velocity = [velocity, v];
    acceleration = [acceleration, a];
  
  end

    plot(time,position)



