filePath = "/home/s2239369/Internship/FEA results/60/variables60.dat";

% Read data from file
dataTable = readtable(filePath, 'Delimiter', '\t');
%disp(dataTable);

% Constants
W = 1; % mm
t = 0.023; % mm
Z = [];
num_nodes_row = 351; %351  %151
num_nodes_width = 41; %41  %51
mesh_size = 0.02439; %0.02439 %0.019608

row1_start = 881;
row1_end = 1056;
row2_start = 3521;
row2_end = 3696;
persistance_length = 0;

% Extract data from table
node = dataTable{:,1};
displacement_x = dataTable{:,2};
displacement_y = dataTable{:,3};
displacement_z = dataTable{:,4};

% Initialize variables
z = zeros(1,length(displacement_y));
x_initial = zeros(1, length(displacement_y));

tolerance = 0.000005;

% Create x positions for all nodes
for i = 1:length(displacement_y)
    z(i) = mod(i-1, num_nodes_row) * mesh_size;
    
    % Calculate the group index
    group_index = floor((i-1) / num_nodes_row);
    
    % Set the x_initial value for each group of 176 nodes
    x_initial(i) = group_index * mesh_size - 0.02439;
end

% Create z positions for all nodes
z = z';
z_final = z + displacement_z;

x_initial = x_initial';
x_final = x_initial + displacement_x;

node_sets = cell(0, num_nodes_row);
displacement_x_sets = cell(0, num_nodes_row);
displacement_y_sets = cell(0, num_nodes_row);
x_final_sets = cell(0, num_nodes_row);

for set_idx = 1:num_nodes_row
    base_node = set_idx;
    node_set = base_node + (0:(num_nodes_width-1)) * num_nodes_row;
    node_sets{set_idx} = node_set;
    displacement_x_sets{set_idx} = displacement_x(node_set);
    displacement_y_sets{set_idx} = displacement_y(node_set);
    x_final_sets{set_idx} = x_final(node_set);
end

% Flatten the displacement arrays
all_displacement_x = cell2mat(displacement_x_sets);
all_displacement_y = cell2mat(displacement_y_sets);
all_x_final = cell2mat(x_final_sets);

for i = 1:num_nodes_row
    Amplitude = max(all_displacement_y(:,i));
    Z = [Z, 2 * Amplitude];
end

Z_0 = Z(1);
Z_t = Z_0 / t;
Frequency = [];
Amplitude = [];

% Loop to find persistence length
for i = 1:(num_nodes_row)

    x_data = all_x_final(:,i);
    y_data = all_displacement_y(:,i);
    
    % Define the linear function model
    linearModel = @(params, x) params(1) * x + params(2);

    % Initial guess for the parameters [a, b]
    initialGuess = [1, 0];

    options = optimoptions('lsqcurvefit', 'Display', 'off'); % suppress output
    [fittedParams, resnorm] = lsqcurvefit(linearModel, initialGuess, x_data, y_data, [], [], options);

    % Debugging output
    %fprintf('resnorm = %f\n', resnorm);
    
    if resnorm < tolerance
        persistance_length = z_final(i);
        break;
    end
    
    %figure;
    %scatter(x_data, y_data, 'bo', 'DisplayName', 'Data Points'); % Original data points
    %hold on;
    %plot(x_data, fittedY, 'r-', 'DisplayName', 'Fitted Sine Curve'); % Fitted sine curve
    %xlabel('x');
    %ylabel('y');
    %title(['Sine Curve Fitting for Column ', num2str(col)]);
    %legend show;
    %grid on;
end

% Initialize a matrix to store the fitted parameters for each column
fittedParamsMatrix = zeros(num_nodes_row, 4);

% Fit sine curve to our data points across all x
for col = 1:num_nodes_row
    x_data = all_x_final(:, col);
    y_data = all_displacement_y(:, col);

    x_data = x_data(:);
    y_data = y_data(:);

    % Define the sine function model
    sineModel = @(params, x) params(1) * sin(params(2) * x + params(3)) + params(4);

    % Initial guess for the parameters [A, B, C, D]
    initialGuess = [0.05, 0.1, 0, 0];

    options = optimoptions('lsqcurvefit', 'Display', 'off'); % suppress output
    fittedParams = lsqcurvefit(sineModel, initialGuess, x_data, y_data, [], [], options);

    fittedParamsMatrix(col, :) = fittedParams;

    fittedY = sineModel(fittedParams, x_data);

    %figure;
    %scatter(x_data, y_data, 'bo', 'DisplayName', 'Data Points'); % Original data points
    %hold on;
    %plot(x_data, fittedY, 'r-', 'DisplayName', 'Fitted Sine Curve'); % Fitted sine curve
    %xlabel('x');
    %ylabel('y');
    %title(['Sine Curve Fitting for Column ', num2str(col)]);
    %legend show;
    %grid on;

    
    Frequency = [Frequency, (fittedParams(2))];
    Amplitude = [Amplitude, (fittedParams(1))];

    % Display fitted parameters for the current column
    
    %disp(['Fitted Parameters for Column ', num2str(col), ':']);
    %disp(['Amplitude (A): ', num2str(fittedParams(1))]);
    %disp(['Frequency (B): ', num2str(fittedParams(2))]);
    %disp(['Phase (C): ', num2str(fittedParams(3))]);
    %disp(['Offset (D): ', num2str(fittedParams(4))]);
end

% Results plots

figure;
scatter(Z_t, persistance_length);
title('Lp/W vs Z/t');
xlabel('Z/t');
ylabel('Lp/W');

Lp_index = floor(persistance_length / mesh_size);

figure;
scatter(all_x_final(:,Lp_index), all_displacement_y(:,Lp_index));
title('Curvature at boundary');
xlabel('x');
ylabel('y');

figure;
scatter(all_x_final(:,1), all_displacement_y(:,1));
title('Curvature at boundary');
xlabel('x');
ylabel('y');

figure;
scatter3(x_final,displacement_y,z_final);
title('final strip displacement')
xlabel('x');
ylabel('y');
zlabel('z');

figure;
scatter(z_final(1: Lp_index), abs(Frequency(1: Lp_index)));
title('Frequency vs z');

figure;
scatter(z_final(1: Lp_index), abs(Amplitude(1:Lp_index)));

% Display results
disp('Persistence Length (Simulation):');
disp(persistance_length);