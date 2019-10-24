function thrust = ThrustCurve(time)
%THRUST Generates the thrust curve of a motor.
%   The 't' array is the list of time values.
%   The 'T' array is the list of thrust values.
%   The function linearly interpolates within the values but returns a
%   value of 0 outside the specified time range.
%   The current table is my best guess for a Sandhawk motor.
T_loki = [0, 2000, 2950, 3100, 3150, 3225, 3300, 3350, 3400, 3550, 3700, 3845, 3990, 4095, 4200, 4400, 4600, 4750, 4900, 4975, 5050, 5100, 5150, 5225, 5300, 5375, 5450, 5475, 5500, 5500, 5500, 5500, 5500, 5510, 5520, 5520, 5520, 5060, 4600, 3050, 1500,  800,  100].*4.44822; %N
    
t_loki = [0.00, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1.00, 1.05, 1.10, 1.15, 1.20, 1.25, 1.30, 1.35, 1.40, 1.45, 1.50, 1.55, 1.60, 1.65, 1.70, 1.75, 1.80, 1.85, 1.90, 1.95, 2.00, 2.05, 2.10]; %s

% Fuel Team thrust curve
T_fc = [6.8:.1:11.8]*10^3;
t_fc = [0:4/(length(T_fc)-1):4];

% Structures team thrust curve
T_sa = [repelem(38000/2, 10) zeros(1, 10)];
t_sa = [0:4/(length(T_sa) - 1):4];


% set T and t to the desired thrust curve to be used in model
T = T_sa;
t = t_sa;
thrust = interp1(t, T, time, 'linear', 0);



end