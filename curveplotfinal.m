% Data points for mode 1
x_mode1 = [4.07609, 7.8125, 44.734, 3.125, 0.2534, 0.069];
y_mode1 = [0.9029, 0.975933, 1.8051, 0.90336, 0.5894, 0.4907];
% x_mode1 = [x_mode1; Z_t];
% y_mode1 = [y_mode1; persistance_length];

x_mode2 = [];
y_mode2 = [];

x_mode22 = [4.068,2.3391, 11.6959, 31.1883, 2.7412];
y_mode22 = [1.159,0.94305, 1.335, 2.1774, 1.0027];

x_mode3 = [1.6268, 3.9065, 0.5458, 6.23, 18.6452, 8.4464];
y_mode3 = [0.7272, 0.9445, 0.5702, 1.2181, 1.6091, 1.3155];

x_mode15 = [9.375,0.82,2.8125, 2.5, 0.069, 0.2369];
y_mode15 = [2.18, 1.4718, 1.8861, 1.6672, 0.7657, 1.0796];

x_mode25 = [0.3125,1.4062,21.7285, 11.52];
y_mode25 = [1.0592, 1.4336, 2.2528, 2.2544];

x_parabolic = [0.1,1,10,40];
y_parabolic = [0.5,0.6,1,2];

% Create the scatter plot with a logarithmic x-axis
figure;
hold on; % Hold on to plot multiple data sets on the same figure
scatter(x_mode1, y_mode1, 'x');
scatter(x_mode22, y_mode22, 'o', 'filled');
scatter(x_mode3, y_mode3, 'd');
scatter(x_mode15, y_mode15, '*');
scatter(x_mode25, y_mode25, 'p');
scatter(x_parabolic, y_parabolic, '^');
set(gca, 'XScale', 'log');  % Set the x-axis to a logarithmic scale

xlabel('Z/t');
ylabel('Lp/W');
legend('Mode 1', 'Mode 2', 'Mode 3', 'Mode 1.5', 'Mode 2.5', 'Parabolic');