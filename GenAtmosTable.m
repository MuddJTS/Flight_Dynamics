% Generate US 1976 Standard Atmosphere Tables as matfiles
clear
[Z Z_L Z_U T P rho c g mu nu k n n_sum] = atmo(1000, .01);
save('AtmosTable'); % Add '-v7.3' flag if planning on using n