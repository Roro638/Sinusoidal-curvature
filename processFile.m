function [Frequency, z_final] = processFile(filePath, num_nodes_row, num_nodes_width, mesh_size)
    % Read data from file
    dataTable = readtable(filePath, 'Delimiter', '\t');

    % Extract data from table
    displacement_x = dataTable{:,2};
    displacement_y = dataTable{:,3};
    displacement_z = dataTable{:,4};

    % Initialize variables
    z = zeros(1, length(displacement_y));
    x_initial = zeros(1, length(displacement_y));

    % Create x positions for all nodes
    for i = 1:length(displacement_y)
        z(i) = mod(i-1, num_nodes_row) * mesh_size;
        group_index = floor((i-1) / num_nodes_row);
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

    Frequency = [];
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

        Frequency = [Frequency, fittedParams(2)];
    end
end


