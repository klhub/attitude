clear all; close all; clc;

addpath('base_unit');
addpath('functions');
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