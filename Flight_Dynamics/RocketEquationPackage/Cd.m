function [ CD ] = Cd( n, z, u);
%Mach is the velocity of sound divided by the velocity of the rocket.  The
% This function uses inputs n, what stage the rocket is in, x, altitude,
% and u, velocity.  It uses altitude and looks up speed of sound for given
% altitude.

% constants for speed of sound
c = c_atm(z); %mach number for given altitude

Machvector = [0:.25:7];
% Reference area of data is .0083 m^2
CD_full = [.34 .35 .36 .4 .5 .65 1.7 1.6 1.3 1.1 .95 .85 .8 .78 .71 .67 .65 .62 .61 .58 .56 .57 .55 .54 .54 .53 .52 .52 .52];
 
% Vector holding coefficient of drag vs Mach number data for Super Loki
% dart alone as [M; CD]

% Reference area of data is .0083 m^2
% CD_dart = 
CD_dart = [.42 .45 .46 .49 .58 1.0 1.12 .9 .54 .48 .44 .42 .4 .38 .38 .37 .37 .36 .36 .35 .35 .35 .34 .32 .32 .31 .3 .3 .3]*.1*.00811/.001338;

CDVector = [CD_full; CD_dart];

CD = interp1(Machvector,CDVector(n+1,:), u./c, 'pchip');

% Used to plot drag coefficients
CD_dart_plot = interp1(Machvector, CD_dart, 0:.1:7,'linear');
CD_full_plot = interp1(Machvector, CD_full, 0:.1:7,'linear');
plot(Machvector,CD_dart/(.1*.00811/.001338),Machvector,CD_full);
xlabel('Mach Number')
ylabel('Cd')
title(' Drag Coefficient vs. Mach Number')
legend('Dart','Full Rocket')

end
