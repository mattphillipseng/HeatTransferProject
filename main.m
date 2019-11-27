%% MECH 346 Thermal Design Problem

% Modified by Matthew Phillips

close all
clear all
clc

% Format of output
    %format short
    format long
    
%% Physical Constants
S_B_const = 5.67*10^-8; %Stefan-Boltzmann constant

%% Geometric Parameters and Constants
pipe_id_inch = 4.81;
pipe_od_inch = 5.56; 
pipe_id = pipe_id_inch * 0.0254; %inner diam in [m]
pipe_od = pipe_od_inch * 0.0254; % outer diam in [m]

length = 80; % length of pipe [m]

%% Material/Fluid Properties
% Steel
k_ss = 19; % [W/m*K] Thermal conductivity: 304 stainless steel (18% Cr, 8% Ni) at 300 deg C %%%CHECK%%%
emissivity_ss = 0.15; % lightly oxidized, T~=400K

% Air
dyn_visc = 10.78*10^-6; % dynamic viscosity of air at -30 deg C %%%CHECK%%%
k_air = 22.02/1000; % thermal conductivity of air at -30 deg C %%%CHECK%%%
Pr_inf = 0.716; % Prandlt number of air at -30 deg C, interpolated %%%CHECK%%%
Pr_w = 0.7; % Prandlt number of air at ~100 deg C, this is a guess for wall temp %%%CHECK%%% CHANGE

% Steam - Enthalpy
h_fg = 1194.158*1000; % [J/kg]
h_f = 1491.312*1000; % [J/kg]
h_g = 2685.384*1000; % [J/kg]

%% Internal Flow Parameters and Constants
m_dot_per_hr = 6000; % [Kg/h]
m_dot = m_dot_per_hr * 60; % [Kg/s]

T_steam = 324.6675 + 273.15; % [K] interpolated from thermo tables at 12MPa=1200KPa

%% External Flow Parameters and Constants
wind = 25; % Highest wind speed [m/s]
T_outside = -30 + 273.15; % Coldest outside temp [K]

%% Thermal Circuit of Un-Insulated Pipe
% T_b = Bulk temperature T_steam everywhere
% T_wi = T wall inner = T_steam everywhere b/c h inside is large &
% phase change
% T_wo = T wall outer
% T_inf = T of cold wind = T_coldest
% T_surr = T of surroundings = T_coldest

T_inf = T_outside;
T_surr = T_outside;

%% Conduction through pipe wall
% R_thermal through pipe wall
R_cond = log(pipe_od/pipe_id)/(2*pi*length*k_ss);

%% Heat transfer coefficient from radiation on the outside of the bare pipe
T_w_g = 583.3; % educated GUESS, CONVERGES, [K]
h_rad = emissivity_ss*S_B_const*(T_w_g+T_surr)*(T_w_g^2+T_surr^2);
R_rad = 1/(h_rad*pi*pipe_od*length);

%% Heat transfer coefficient from convection on the outside of the bare pipe
Re = (wind*pipe_od)/dyn_visc; %Reynolds number

% Zhukaukas Correlation
[c,m] = get_c_m(Re);
n = get_n(Pr_inf);

Nu = c*(Re^m)*(Pr_inf^n)*(Pr_inf/Pr_w)^0.25;

h_conv = (Nu*k_air)/(pipe_od); % Heat transfer coefficient for outside convection

R_conv = 1/(h_conv*pi*pipe_od*length);

% Thermal Circuit analogy
%R_total = R_cond + R_conv; % neglecting radiation
R_total = R_cond + 1/((1/R_conv)+(1/R_rad)); % with radiation

q_out = (T_steam-T_inf)/(R_total); % Watts (aka J/s)
T_wall = T_steam - (q_out*R_cond);
T_wall_celsius = T_wall - 273.15;

%% Condensation Rate for bare pipe
condens_rate_bare = q_out/h_fg; % [kg/s]

