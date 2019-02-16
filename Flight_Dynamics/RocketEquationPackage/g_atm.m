function g = g_atm(z)
%T_atm Returns the local gravitational acceleration in m/s^2 at z
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give g at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 0 m to 1,000,000 m
%   Output
%   g -- The local gravitational acceleration in m/s^2
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
g = interp1(m.Z, m.g, Z, 'pchip');
end

