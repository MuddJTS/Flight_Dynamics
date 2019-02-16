function T = T_atm(z)
%T_atm Returns the absolute temperature in Kelvin at a given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the temperature at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 0 m to 1,000,000 m
%   Output
%   T -- The absolute temperature in K
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
T = interp1(m.Z, m.T, Z, 'pchip');
end

