function k = k_atm(z)
%T_atm Returns the thermal conductivity in W/m?K at the given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the conductivity at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 0 m to 86,000 m. Altitudes outside
%   this range will return an error.
%   Output
%   mu -- The thermal conductivity of air in W/m?K
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
k = interp1(m.Z_L, m.k, Z, 'pchip');
end

