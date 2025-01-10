clear all; close all; clc;

% Load the necessary SPICE kernels
spice_furnsh('./kernels/naif0012.tls')  % Load a leapseconds kernel
spice_furnsh('./kernels/de440s.bsp')
spice_furnsh('./kernels/pck00011.tpc')
spice_furnsh('./kernels/gm_de440.tpc')
spice_furnsh('./kernels/earth_200101_990827_predict.bpc')
spice_furnsh('./kernels/earth_assoc_itrf93.tf')
spice_furnsh('./kernels/moon_assoc_me.tf')
% spice_furnsh('./kernels/moon_assoc_pa.tf') % only me or pa, not both
spice_furnsh('./kernels/moon_de440_220930.tf')
spice_furnsh('./kernels/moon_pa_de440_200625.bpc')

% Time Conversion
utc_time        = '2024-11-01T00:00:00';
et_time         = utc2et(utc_time); % or et = cspice_str2et('2024-01-01T00:00:00');  % Convert time to ephemeris time
utc_converted   = [date, et_time];

% Convert ephemeris time back to UTC string
et              = cspice_str2et('2024-01-01T00:00:00');
utc_time        = cspice_et2str(et);

% Frames Transformation
transformation_matrix   = spice.pxform('J2000', 'ECLIPJ2000', et);
position_ecliptic       = mxv(transformation_matrix, position_j2000);

% Compute light time from Earth to Mars
et_earth            = cspice_str2et('2024-01-01T00:00:00');
et_mars             = et_earth + 3600;  % Assume one hour later
[state_earth, ~]    = cspice_spkpos('EARTH', et_earth, 'J2000', 'NONE', 'SOLAR_SYSTEM_BARYCENTER');
[state_mars, ~]     = cspice_spkpos('MARS', et_mars, 'J2000', 'NONE', 'SOLAR_SYSTEM_BARYCENTER');
light_time          = cspice_reclat(state_mars - state_earth);

% Ephemeris
[state_vector]      = spice_spkezr('MOON', et, 'J2000', 'NONE', 'EARTH');
position            = state_vector(1:3, 1);
velocity            = state_vector(4:6, 1);

% Clear Kernels
spice_kclear;
