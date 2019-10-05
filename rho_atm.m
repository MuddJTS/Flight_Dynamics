function rho = rho_atm(z)
%T_atm Returns the density of air in kg/m^3 at a given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the density at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 0 m to 1,000,000 m
%   Output
%   rho -- The density of air in kg/m^3
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
rho = interp1(m.Z, m.rho, Z, 'pchip');
end

