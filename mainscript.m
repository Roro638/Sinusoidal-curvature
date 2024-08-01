% Define a list of file paths
filePaths = {"/home/s2239369/Internship/FEA results/63/variables63 .dat",
             };

% Constants
num_nodes_row = 351; %351  %151
num_nodes_width = 41; %41  %51
mesh_size = 0.02439; %0.02439 %0.019608

% Initialize cell arrays to store results
allFrequencies = cell(1, length(filePaths));
allZ_final = cell(1, length(filePaths));

% Process each file and store the results
for fileIdx = 1:length(filePaths)
    [Frequency, z_final] = processFile(filePaths{fileIdx}, num_nodes_row, num_nodes_width, mesh_size);
    allFrequencies{fileIdx} = Frequency;
    allZ_final{fileIdx} = z_final;
end

% Plot all results
figure;
hold on;

for fileIdx = 1:length(filePaths)
    scatter(allZ_final{fileIdx}, abs(allFrequencies{fileIdx}), 'DisplayName', ['File ' num2str(fileIdx)]);
end

title('Frequency vs z');
xlabel('z');
ylabel('Frequency');
legend show;
grid on;
hold off;