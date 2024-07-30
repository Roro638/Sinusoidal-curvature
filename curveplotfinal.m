% Data points for mode 1
x_mode1 = [4.07609, 7.8125];
y_mode1 = [0.9029, 0.975933];
% x_mode1 = [x_mode1; Z_t];
% y_mode1 = [y_mode1; persistance_length];

x_mode2 = [];
y_mode2 = [];

x_mode22 = [];
y_mode22 = [];

x_mode3 = [];
y_mode3 = [];

x_mode15 = [6.11413];
y_mode15 = [2.13781];

% Create the scatter plot with a logarithmic x-axis
figure;
hold on; % Hold on to plot multiple data sets on the same figure
scatter(x_mode1, y_mode1, 'x');
scatter(x_mode22, y_mode22, 'o', 'filled');
scatter(x_mode3, y_mode3, 'd');
scatter(x_mode15, y_mode15, '*');
set(gca, 'XScale', 'log');  % Set the x-axis to a logarithmic scale

xlabel('Z/t');
ylabel('Lp/W');
legend('Mode 1', 'Mode 2', 'Mode 3', 'Mode 1.5');