%% Script to determine effect of charge size on apogee
charge_sizes = 0:10;
apogees = zeros(size(charge_sizes));
for i = 1:length(charge_sizes)
    separation_charge_mass = charge_sizes(i)
    MarsRocket % run sim
    apogees(i) = apogee_km;
end
figure;clf;
plot(charge_sizes, apogees, 'o-');
xlabel 'Mass of Black Powder Charge (g)'
ylabel 'Apogee (km)'