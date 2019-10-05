%%%%%%%%%%%%%%%%% Model Description %%%%%%%%%%%%%%%%%%%%%% 
% This code is used to determiner the trajectory of the rocket. The model
% is a one dimensional model.  It takes the Motor thrust curve as input and
% outputs the displacement, velocity, and position of the rocket for the
% entire flight. This model may be used to determine apogee, optimize mass,
% find max velocity, determine the velocity off the launch stand, give
% max loads, mach numbers, optimize the thrust curve, and much more.

%%%%%%%%%%%%% Main Scripts %%%%%%%%%%%%%%%%%%%%%%

% MarsRocket.m : this is the main file of the model.  All of the other
% files are called from this one.
% this file steps through time and updates the mass, position, velocity, and acceleration of the rocket.  
% It refferences the thrust curve and the drag coefficient curve of the
% rocket to calculate the forces.  The drag on the rocket also depends on
% the mach number (which is a function of pressure, density, temperature)
% so much of the calculations are simply calculating the speed of sound in
% air for a given altitude.

% SuperLokiTester.m: this is a replica of the MarsRocket model, but
% contains the size and weight of the Super loki rocket

%%%%%%%%%%%%% Important Auxiliary functions %%%%%%%%%%%%%%%%%

% rockeq_var: this is where the equations are actually solved 

%%%%%%%%%%%%% Aerodynamics Functions %%%%%%%%%%%%%%%%

% Cd.m: This function outputs the drag coefficient for a given velocity, flight stage, and altitude. 
% This function holds vectors of all of the drag coefficient
% information we have on the rocket. this is where you would update the
% drag coefficient vs mach number information.

% NoseConeDrag.m: loads and plots information from dozens of CSV files
% ocntaining data from the nosecone simulations in Rasaero

% c_atm: returns the speed of sound for a given altitude

% MaxQ.m plots aerodynamic pressure over time and outputs the maxQ pressure

% mu_atm.m: returns viscocity of air at a given altitude
%nu_atm.m: returns kinematic viscocity


%%%%%%%%%%%%% Atmosphere calculations (not really important to understand) %%%%%%%%%%%%%%%%

% atmo.m: USes all of the atmosphere things below and outputs all
% atmosphere information for a given composition

% atmo_p.m: returns partial pressures at a given alt and temp

% atmo_temp.m: outputs the temperature [K] at a given altitude

% atmo_compo.m:  returns atmosphere composition at a given altitude.
% Currently not used in this sim

% GenAtmosTable.m: uses all the atmosphere functions to generate an
% atmosphere table.

% AtmosTable.mat: this table contains a lookup table for all atmosphere
% specs for a given altitude

% k_atm.m outputs the thermal conductivity of air at a given altitude

% P_atm.m: returns the pressure for a given altitude

% rho_atm: returns the density for a given altitude

% T_atm.m returns the temperature for a given altitude
