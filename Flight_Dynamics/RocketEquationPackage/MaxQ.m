function [ MaxQ ] = MaxQ(t,u,x)
%This function calculates the dynamic pressure over the flight.  The
%maximum of this function is the max Q.  dynamic pressure is given by Q =
%.5*rho*v^2
rho = rho_atm(x)
Q = .5.*rho.*u.^2

MaxQ = max(Q)

figure (3)
plot(t,Q);
xlabel('time (s)')
ylabel('Q (N)')
title(' Aerodynamic Pressure vs. time')

end

