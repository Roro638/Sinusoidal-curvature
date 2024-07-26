filePath = '/home/s2239369/Internship/FEA results/54/variables.dat';

% Read data from file
dataTable = readtable(filePath, 'Delimiter', '\t');
disp(dataTable);

% Constants
W = 1; % mm
t = 0.05; % mm
Z = [];
num_nodes_row = 176;
num_nodes_width = 21;
mesh_size = 0.04545;

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

tolerance = 0.0001;

% Create x positions for all nodes
for i = 1:length(displacement_y)
    z(i) = mod(i-1, num_nodes_row) * mesh_size;
    
    % Calculate the group index
    group_index = floor((i-1) / num_nodes_row);
    
    % Set the x_initial value for each group of 176 nodes
    x_initial(i) = group_index * mesh_size - 0.4545;
end

% Create z positions for all nodes
z = z';
z_final = z + displacement_z;

x_initial = x_initial';
x_final = x_initial + displacement_x;

% Loop to find persistence length
for i = 1:(row1_end - row1_start + 1)
    row1_index = row1_start + i - 1;
    y_diff = abs(displacement_y(row1_index)-displacement_y(row1_end));
    
    % Debugging output
    fprintf('y_diff = %f\n', y_diff);
    
    if y_diff < tolerance
        persistance_length = z_final(row1_index);
        break;
    end
end

nodes_length = 176;
nodes_width = 21;

node_sets = cell(0, nodes_length);
displacement_x_sets = cell(0, nodes_length);
displacement_y_sets = cell(0, nodes_length);
x_final_sets = cell(0, nodes_length);

for set_idx = 1:nodes_length
    base_node = set_idx;
    node_set = base_node + (0:(nodes_width-1)) * nodes_length;
    node_sets{set_idx} = node_set;
    displacement_x_sets{set_idx} = displacement_x(node_set);
    displacement_y_sets{set_idx} = displacement_y(node_set);
    x_final_sets{set_idx} = x_final(node_set);
end

% Flatten the displacement arrays
all_displacement_x = cell2mat(displacement_x_sets);
all_displacement_y = cell2mat(displacement_y_sets);
all_x_final = cell2mat(x_final_sets);

for i = 1:nodes_length
    Amplitude = max(all_displacement_y(:,i));
    Z = [Z, 2 * Amplitude];
end

Z_0 = Z(1);
Z_t = Z_0 / t;
Frequency = [];

% Initialize a matrix to store the fitted parameters for each column
fittedParamsMatrix = zeros(176, 4);

% Fit sine curve to our data points across all x
for col = 1:176
    x_data = all_x_final(:, col);
    y_data = all_displacement_y(:, col);

    x_data = x_data(:);
    y_data = y_data(:);

    % Define the sine function model
    sineModel = @(params, x) params(1) * sin(params(2) * x + params(3)) + params(4);

    % Initial guess for the parameters [A, B, C, D]
    initialGuess = [1, 1, 0, 0];

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

    % Display fitted parameters for the current column
    disp(['Fitted Parameters for Column ', num2str(col), ':']);
    disp(['Amplitude (A): ', num2str(fittedParams(1))]);
    disp(['Frequency (B): ', num2str(fittedParams(2))]);
    disp(['Phase (C): ', num2str(fittedParams(3))]);
    disp(['Offset (D): ', num2str(fittedParams(4))]);
end

% Results plots

figure;
plot(z(1:176), Z);
title('Z(2*Amplitude) vs z');
xlabel('z');
ylabel('Z(2*Amplitude)');

figure;
plot(z(1:176), abs(Frequency));
title('Frequency vs z');
xlabel('z');
ylabel('Frequency');

figure;
scatter(Z_t, persistance_length);
title('Lp/W vs Z/t');
xlabel('Z/t');
ylabel('Lp/W');

set_1234 = floor(persistance_length / 0.04545);

figure;
scatter(all_x_final(:,set_1234), all_displacement_y(:,set_1234));
title('Curvature at boundary');
xlabel('x');
ylabel('y');

figure;
scatter(all_x_final(:,10), all_displacement_y(:,10));
title('Curvature at boundary');
xlabel('x');
ylabel('y');

figure;
scatter3(x_final,displacement_y,z_final);
title('final strip displacement')
xlabel('x');
ylabel('y');
zlabel('z');

% Display results
disp('Persistence Length (Simulation):');
disp(persistance_length);