function n_sum = n_sum_atm(z)
%T_atm Returns the total number density in m^-3 at the given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the number density at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 86,000 m to 1,000,000 m. Altitudes
%   outside this range will return an error.
%   Output
%   n_sum -- The number density of all species in m^-3
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
n_sum = interp1(m.Z_U, m.n_sum, Z, 'pchip');
end

