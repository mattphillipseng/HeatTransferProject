%% MECH 346 Thermal Design Problem

% Modified by Matthew Phillips

close all
clear all
clc

% Format of output
    format short
    %format long

%% Geometric Parameters and Constants
pipe_id_inch = 4.81;
pipe_od_inch = 5.56; 
pipe_id = pipe_id_inch * 0.0254; %inner diam in [m]
pipe_od = pipe_id_inch * 0.0254; % outer diam in [m]

length = 80; % length of pipe [m]

%% Material/Fluid Properties
k_ss = 19; % [W/m*K] Thermal conductivity: 304 stainless steel (18% Cr, 8% Ni) at 300 deg C

%% Internal Flow Parameters and Constants
m_dot_per_hr = 6000; % [Kg/h]
m_dot = m_dot_per_hr * 60; % [Kg/s]

T_steam = 324.6675 + 273.15; % [K] interpolated from thermo tables at 12MPa=1200KPa

%% External Flow Parameters and Constants
wind = 25; % Highest wind speed [m/s]
T_out = -30 + 273.15; % Coldest outside temp [K]

%% Thermal Circuit of Un-Insulated Pipe
% T_b = Bulk temperature T_steam everywhere
% T_wi = T wall inner = T_steam everywhere b/c h inside is large &
% phase change
% T_wo = T wall outer
% T_inf = T of cold wind = T_coldest
% T_surr = T of surroundings = T_coldest

T_inf = T_out;
T_surr = T_out;

%% Calculations
% R_thermal through pipe wall
R_cond = log(pipe_od/pipe_id) / (2*pi*length*k_ss);

% Heat transfer coefficient from radiation on the outside of the bare pipe
h_rad = 0;

% Heat transfer coefficient from convection on the outside of the bare pipe
h_conv = 0;


