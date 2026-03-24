clc; clear; close all;

L_vec = [24,32,48,64];
colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'}; 
markers = {'o', 's', 'd', '^'};

%% 图 1：绝对误差 (MMSE)
figure('Color', 'w', 'Position', [100, 100, 600, 450]);
hold on; grid on; box on;
for i_L = 1:length(L_vec)
    L_current = L_vec(i_L);
    filename = ['Simulation_LSE_Data_L_', num2str(L_current), '.mat'];
    if isfile(filename)
        load(filename);
        % 直接画读取到的 True_MMSE_vs_PL
        plot(PL_dBm, 10*log10(True_MMSE_vs_PL), ...
             '-', 'Color', colors{i_L}, 'Marker', markers{i_L}, ...
             'LineWidth', 1.5, 'MarkerSize', 8, ...
             'DisplayName', ['L = ', num2str(L_current)]);
    else
        warning(['找不到文件: ', filename, '，已跳过该曲线的绘制。']);
    end
end
xlabel('Total power, PL (dBm)', 'FontSize', 12);
ylabel('MMSE (dB)', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 11, 'Location', 'northeast');
%xlim([0, 1000]);

% 修改坐标轴范围为 0 到 5000
xlim([0, 500]);
% 强制指定横坐标只显示这 6 个具体的刻度值，即一格 1000
%xticks([0, 1000, 2000, 3000, 4000, 5000]);
title('MMSE vs Total Power');

%% 图 2：归一化均方误差 (NMSE)
figure('Color', 'w', 'Position', [750, 100, 600, 450]);
hold on; grid on; box on;
for i_L = 1:length(L_vec)
    L_current = L_vec(i_L);
    filename = ['Simulation_LSE_Data_L_', num2str(L_current), '.mat'];
    if isfile(filename)
        load(filename);
        % 直接画读取到的 NMSE_vs_PL
        plot(PL_dBm, 10*log10(NMSE_vs_PL), ...
             '-', 'Color', colors{i_L}, 'Marker', markers{i_L}, ...
             'LineWidth', 1.5, 'MarkerSize', 8, ...
             'DisplayName', ['L = ', num2str(L_current)]);
    end
end
xlabel('Total power, PL (dBm)', 'FontSize', 12);
ylabel('Normalized MMSE (dB)', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 11, 'Location', 'northeast');
%xlim([0, 1000]);
% 修改坐标轴范围为 0 到 5000
xlim([0, 500]);
% 强制指定横坐标只显示这 6 个具体的刻度值，即一格 1000
%xticks([0, 1000, 2000, 3000, 4000, 5000]);
title('Normalized MMSE vs Total Power');