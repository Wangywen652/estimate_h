clc; clear; close all;

% 设置需要绘制的 L 序列
L_vec = [24,32,48,64];
colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'}; 
markers = {'o', 's', 'd', '^'};

%% 图 1：实际平方误差 (Actual Squared Error) vs PL
figure('Color', 'w', 'Position', [100, 100, 600, 450]);
hold on; grid on; box on;
for i_L = 1:length(L_vec)
    L_current = L_vec(i_L);
    filename = ['Actual_Error_Data_L_', num2str(L_current), '.mat'];
    
    if isfile(filename)
        load(filename);
        % 将实际平方误差转换为 dB 并画图
        plot(PL_dBm, 10*log10(Actual_SE_vs_PL), ...
             '-', 'Color', colors{i_L}, 'Marker', markers{i_L}, ...
             'LineWidth', 1.5, 'MarkerSize', 8, ...
             'DisplayName', ['L = ', num2str(L_current)]);
    else
        warning(['找不到文件: ', filename, '，已跳过 L = ', num2str(L_current), ' 的曲线。']);
    end
end
xlabel('Total power, PL (dBm)', 'FontSize', 12);
ylabel('Actual Squared Error (dB)', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 11, 'Location', 'northeast');
%xlim([0, 1000]);

% 修改坐标轴范围为 0 到 5000
xlim([0, 500]);
% 强制指定横坐标只显示这 6 个具体的刻度值，即一格 1000
%xticks([0, 1000, 2000, 3000, 4000, 5000]);
title('Actual Squared Error vs Total Power');

%% 图 2：实际归一化平方误差 (Actual Normalized Squared Error) vs PL
figure('Color', 'w', 'Position', [750, 100, 600, 450]);
hold on; grid on; box on;
for i_L = 1:length(L_vec)
    L_current = L_vec(i_L);
    filename = ['Actual_Error_Data_L_', num2str(L_current), '.mat'];
    
    if isfile(filename)
        load(filename);
        % 将实际归一化平方误差转换为 dB 并画图
        plot(PL_dBm, 10*log10(Actual_NSE_vs_PL), ...
             '-', 'Color', colors{i_L}, 'Marker', markers{i_L}, ...
             'LineWidth', 1.5, 'MarkerSize', 8, ...
             'DisplayName', ['L = ', num2str(L_current)]);
    end
end
xlabel('Total power, PL (dBm)', 'FontSize', 12);
ylabel('Actual Normalized Squared Error (dB)', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 11, 'Location', 'northeast');
%xlim([0, 1000]);

% 修改坐标轴范围为 0 到 5000
xlim([0, 500]);
% 强制指定横坐标只显示这 6 个具体的刻度值，即一格 1000
%xticks([0, 1000, 2000, 3000, 4000, 5000]); 
title('Actual Normalized Squared Error vs Total Power');