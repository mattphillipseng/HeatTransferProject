%% MECH 346 Thermal Design Problem
% by Matthew Phillips

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
k_ss = 19; % [W/m*K] Thermal conductivity: 304 stainless steel (18% Cr, 8% Ni) at 300 deg C
emissivity_ss = 0.15; % lightly oxidized, T~=400K

% Air
dyn_visc = 10.78*10^-6; % dynamic viscosity of air at -30 deg C
k_air = 21.697/1000; % thermal conductivity of air at -30 deg C
Pr_inf = 0.7243; % Prandlt number of air at -30 deg C, interpolated
Pr_w = 0.68; % Prandlt number of air at ~310 deg C, this is a guess for wall temp

% Steam - Enthalpy
h_fg = 1194.158*1000; % [J/kg]
h_f = 1491.312*1000; % [J/kg]
h_g = 2685.384*1000; % [J/kg]

%% Internal Flow Parameters and Constants
m_dot_per_hr = 6000; % [Kg/h]
m_dot = m_dot_per_hr / (60*60); % [Kg/s]

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
R_cond_pipe = log(pipe_od/pipe_id)/(2*pi*length*k_ss);

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

%% Heat Transfer Calculation
R_conv = 1/(h_conv*pi*pipe_od*length);

% Thermal Circuit analogy
%R_total = R_cond_pipe + R_conv; % neglecting radiation
R_total = R_cond_pipe + 1/((1/R_conv)+(1/R_rad)); % with radiation

q_removed = (T_steam-T_inf)/(R_total); % Watts (aka J/s)
T_wall = T_steam - (q_removed*R_cond_pipe);
T_wall_celsius = T_wall - 273.15;

%% Condensation Rate for bare pipe
condens_rate_bare = q_removed/h_fg; % [kg/s]
condens_rate_req = condens_rate_bare*(1/100); % [kg/s] design requirement 1%

%% Steam Quality at exit of bare pipe
m_dot_steam_out = m_dot - condens_rate_bare;
quality_bare = m_dot_steam_out/m_dot; %mdot steam/mdot total


%% Insulation Properties
k_ins = 0.048; %[W/m*K] ***VARIABLE***

%% Insulation Calculations
% R_cond pipe known from before, doesn't change
%th=0; %insulation thickness
ins_id = pipe_od;
results=[];
Pr_w_ins = 0.72; % with insulation, exterior wall of insulation isn't as hot
%for k_ins = 0.01:0.005:0.04
    for th = 0.25:0.125:5.5 %iter over thickness of 1/4" to 5", 1/8" increment
        ins_od = ins_id + 2*th*0.0254; % [m], converted inch to m for calculations

        % Conduction Resistance
        R_cond_ins = log(ins_od/ins_id)/(2*pi*length*k_ins);

        % Convection Resistance
        Re_ins = (wind*ins_od)/dyn_visc;
        [c_ins,m_ins] = get_c_m(Re_ins);
        n_ins = get_n(Pr_inf);
        Nu_ins = c*(Re_ins^m_ins)*(Pr_inf^n_ins)*(Pr_inf/Pr_w_ins)^0.25;
        h_conv_ins = (Nu_ins*k_air)/(ins_od);
        R_conv_ins = 1/(h_conv_ins*pi*ins_od*length);

        % Heat Transfer
        R_tot_ins = R_cond_pipe + R_cond_ins + R_conv_ins;
        q_rem_ins = (T_steam-T_inf)/(R_tot_ins); % Watts (aka J/s), removed Q

        % Condensation rate. REQUIREMENT!
        condens_rate_ins = q_rem_ins/h_fg; % [kg/s]

        % Steam quality. REQUIREMENT!
        m_dot_steam_out_ins = m_dot - condens_rate_ins;
        quality_ins =  m_dot_steam_out_ins/m_dot; %mdot steam/mdot total

        if (condens_rate_ins <= condens_rate_req) && (quality_ins > 0.99)
            satisfies_reqs = true;
        else 
            satisfies_reqs = false;
        end
        
        %Insulation wall temps
        T_ins_inner= T_steam - q_rem_ins*R_cond_pipe; % [K]
        T_ins_outer= T_inf + q_rem_ins*R_conv_ins; % [K]

        % Data consolidation
        this_results = [k_ins,th,q_rem_ins,T_ins_inner,T_ins_outer,condens_rate_ins,quality_ins,satisfies_reqs];
        results = [results;this_results]; %append this_results as a new row in results
    end
%end


%% Print Important Results
condens_rate_bare
quality_bare
results


%plot_results(results) %doesn't work and it too much of a pain
%wanted to make a contour plot showing a good design region
