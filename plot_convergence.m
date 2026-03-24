Objective_History = Result(1).obj_fS; 
LSE_History = Result(1).obj_LSE;
LSE_History = LSE_History(~isnan(LSE_History));
       
num_iterations_obj = length(Objective_History);
num_iterations_lse = length(LSE_History);
figure('Name', 'Convergence of Objective Function', 'Position', [100, 100, 600, 450]);
plot(1:num_iterations_obj, Objective_History, '-*', 'LineWidth', 1.2, 'MarkerSize', 6);
xlabel('Number of iterations', 'FontSize', 12);
ylabel('The objective function', 'FontSize', 12);
legend('Algorithm 1', 'Location', 'SouthEast', 'FontSize', 11);
box on; 
set(gca, 'FontSize', 11);

figure('Name', 'Convergence of LSE', 'Position', [750, 100, 600, 450]);
plot(1:num_iterations_lse, LSE_History, '-*', 'LineWidth', 1.2, 'MarkerSize', 6);
xlabel('Number of iterations', 'FontSize', 12);
ylabel('MMSE', 'FontSize', 12);
legend('Algorithm 1', 'Location', 'NorthEast', 'FontSize', 11);
box on;
set(gca, 'FontSize', 11);
