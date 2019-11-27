function plot_results = plot_results(results)

%% Prepare data
k_vals = [0.01:0.005:0.04]; % x axis, [W/m*K]
th_vals = [0.25:0.125:5.5]; % y axis, [inch]

[X,Y]=meshgrid(k_vals,th_vals)

satisfies = results(:,6); % z axis [1 or 0]

cols=size(k_vals)
Z=vector2matrix(satisfies',cols)




%% Make plots
font_size = 15;
line_size = 15;
line_width = 2;

figure 
hold on
contour(X,Y,Z)
%title('Design Chart','fontsize',font_size,'Interpreter','latex')
xlabel('Thermal Conductivity (W/m*K)','fontsize',font_size,'Interpreter','latex');
ylabel('Insulation Thickness (inch)','fontsize',font_size,'Interpreter','latex');

print('Done plotting')
end
