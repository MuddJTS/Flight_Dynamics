function c = c_atm(z)
%T_atm Returns the local speed of sound in m/s at the given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the speed of sound at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 0 m to 86,000 m. Altitudes outside
%   this range will return an error.
%   Output
%   c -- The speed of sound in air in m/s
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
c = interp1(m.Z_L, m.c, Z, 'pchip');
end

