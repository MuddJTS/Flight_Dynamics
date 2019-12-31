m_dart = 25.65*.4536; %kg, 0.453592 kg per lbs
m_booster = 70*.4536; %kg without propellant loaded

Cd_drogue = 0.97; % Drag coefficient. I believe this is typical if you are reffering to the completely open projected area
Cd_Main = 0.97; 
Cd_booster_chute = 0.7;

A_drogue = 5; %Projected area of open parachute (in m^2)
A_main = 10; 
A_booster_chute = 10;

t0 = 0; %time that simulation begins
tf = 40; %time that simulation ends
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
    rho = rho_atm(x); % finds rho for a given altatude
    gloc = g_atm(x);% local gravitational acceleration
    
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

%% This section calculates the required size of a parachute for a desired descent velocity

g = 9.81; %m/s^2
rho = 1.225; %kg/m^3
m = 60*.46; %mass of dart in kg 25
Cd = .97; %common drag coefficient of parachute
v = 5.18; %50 feet per second for drogue chute, 15 meters per second

S = 2*g*m/(rho*Cd*v^2) % S is surface area in meters

D = sqrt(S/pi)*2 %diameter of circular parachute
D_feet = D*3.28 %diameter in feet

%% Calculation for Dart main chute size

g = 9.81; %m/s^2
rho = 1.225; %kg/m^3
m = 25*.46; %mass of dart in kg
Cd = .97; %common drag coefficient of parachute
v = 5.18; %50 feet per second for drogue chute, 15 meters per second

S = 2*g*m/(rho*Cd*v^2) % S is surface area in meters

D = sqrt(S/pi)*2 %diameter of circular parachute
D_feet = D*3.28 %diameter in feet

%% This section Calculates the length of the dart required for a given parachute packing dimension

vol = 107; %inches cubed
d = 3.1; %inner diameter of dart
A = pi*d^2/4; %cross sectional area of dart in inches

length = vol/A; %length of section required to pack the parachute.  Add some wiggle room to this

length_safe = length*1.3 %safer length to make sure things fit, arbitrary 30 percent added

%% Force on shock chords

