% The most basic demo of SPICE in Matlab
clc; clear all; close all;

addpath('base_unit');
addpath('functions/attitude');
addpath('spice/kernels');
addpath('spice/mice/src/mice');
addpath('spice/mice/src/cspice');
addpath('spice/mice/src/cspice');
addpath('spice/mice/lib');

% Load the necessary SPICE kernels
cspice_furnsh('spice/kernels/naif0012.tls')  % Load a leapseconds kernel
cspice_furnsh('spice/kernels/de440s.bsp')
cspice_furnsh('spice/kernels/pck00011.tpc')
cspice_furnsh('spice/kernels/gm_de440.tpc')
cspice_furnsh('spice/kernels/earth_200101_990827_predict.bpc')
cspice_furnsh('spice/kernels/earth_assoc_itrf93.tf')
cspice_furnsh('spice/kernels/moon_assoc_me.tf')
% cspice_furnsh('spice/kernels/moon_assoc_pa.tf') % only me or pa, not both
cspice_furnsh('spice/kernels/moon_de440_220930.tf')
cspice_furnsh('spice/kernels/moon_pa_de440_200625.bpc')

% Time Conversion
utc_time        = '2024-11-01T00:00:00';
et_time         = cspice_str2et(utc_time);

% Convert ephemeris time back to UTC string
utc_time        = cspice_et2utc(et_time, 'C', 4);

% Frames Transformation
position_j2000          = [10000 15000 8000]';
transformation_matrix   = cspice_pxform('J2000', 'ECLIPJ2000', et_time); % from, to, et
position_ecliptic       = transformation_matrix * position_j2000;

% Compute light time from Earth to Mars
et_earth            = cspice_str2et('2024-01-01T00:00:00');
et_mars             = et_earth + 3600;  % Assume one hour later
[state_earth, ~]    = cspice_spkpos('EARTH', et_earth, 'J2000', 'NONE', 'SOLAR_SYSTEM_BARYCENTER');
% [state_mars, ~]     = cspice_spkpos('MARS',  et_mars,  'J2000', 'NONE', 'SOLAR_SYSTEM_BARYCENTER'); % Need approproate kernels
% light_time          = cspice_reclat(state_mars - state_earth);

% Ephemeris
[state_vector]      = cspice_spkezr('MOON', et_time, 'J2000', 'NONE', 'EARTH');
position            = state_vector(1:3, 1);
velocity            = state_vector(4:6, 1);

% Clear Kernels
% cspice_kclear; % it's good idea to clear SPICE from the system
