function n = n_atm(z, species)
%T_atm Returns the number density of a species in m^-3 at the given altitude
%   This function interpolates in a table of the 1976 US Standard
%   Atmosphere to give the number density at a given altitude. Make sure the
%   AtmosTable.mat is in your path.
%   Input
%   z -- The MSL altitude in meters from 86,000 m to 1,000,000 m. Altitudes
%   outside this range will return an error.
%   species -- The species 'N2', 'O', 'O2', 'Ar', 'He', or 'H' desired
%   Output
%   n_sum -- The number density of all species in m^-3
switch species
    case 'N2'
        index = 1;
    case 'O'
        index = 2;
    case 'O2'
        index = 3;
    case 'Ar'
        index = 4;
    case 'He'
        index = 5;
    case 'H'
        index = 6; % There are reports of erros in the calculation of H
    otherwise
        error('Did not choose one of N2, O, O2, Ar, He, or H.')
        return
end
Z = 0.001*z; % The table is in km, but the function in m.
m = matfile('AtmosTable.mat'); % The table with the atmospheric values
n = interp1(m.Z_U, m.n(:,index), Z, 'pchip');
end

