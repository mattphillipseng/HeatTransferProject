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

%% Thermal Properties


%% Internal Flow Parameters and Constants
m_dot_per_hr = 6000; % [Kg/h]
m_dot = m_dot_per_hr * 60; % [Kg/s]

T_steam = 324.6675 + 273.15; % [K] interpolated from thermo tables at 12MPa=1200KPa

%% External Flow Parameters and Constants
wind_highest = 25; % Highest wind speed [m/s]
T_coldest = -30 + 273.15; % Coldest outside temp [K]

%% Calculations