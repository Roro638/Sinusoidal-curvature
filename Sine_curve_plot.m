% Data points for mode 1
x_mode1 = [4.0761, 39, 10.3027, 1.25];
y_mode1 = [0.77318, 1.68, 0.86366, 0.59085];
x_mode1 = [x_mode1; Z_t];
y_mode1 = [y_mode1; persistance_length];

x_mode2 = [1.3061, 0.99067,11.8,1.0049, 6.78];
y_mode2 = [0.909, 1.8194,1.5918, 1.0027, 1.7285];

x_mode22 = [1.2393, 1.088,14.303,3.8196];
y_mode22 = [2.0484, 1.0029, 2.1888, 1.5059];

x_mode3 = [7.8812, 6.0986, 1.6602,1.1328];
y_mode3 = [1.7293,1.6389, 0.6877, 0.6408];

x_mode15 = [3.3966, 1.3271,4.3848];
y_mode15 = [2.3281,1.5490, 2.0084];

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
legend('Mode 1', 'Mode 2', 'Mode 3');