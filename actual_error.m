clc; clear; close all;
L = 24; 
N_a   = 4;
N_e   = 4;
Nt_BS = N_a * N_e;
K_IU  = 6;
NR_IU = 2;
M     = 16;      % 雷达接收天线数
noise = 1;       % 雷达端噪声方差
num_MC = 1000;    % 蒙特卡洛仿真次数

fprintf('\n======================================\n');
fprintf('>>> 当前正在独立计算 L = %d 的实际误差 <<<\n', L);
fprintf('======================================\n');

source_filename = ['Simulation_LSE_Data_L_', num2str(L), '.mat'];
if ~isfile(source_filename)
    error(['找不到源文件: ', source_filename, '，请先运行 teest1.m 生成该 L 的基础数据！']);
end
load(source_filename, 'Result', 'PL_dBm');

theta_deg  = [30, 45, 60];  
phi_deg    = [10, -20, 50]; 
kappa_true = [1.0, 0.8 + 0.5j, 0.6 - 0.3j]; 

T = length(theta_deg);
h_true = zeros(M * Nt_BS, 1);     
H_true_mat = zeros(M, Nt_BS);

for t = 1:T
    rho_t = generate_steering_vectors(theta_deg(t), phi_deg(t), N_a, N_e, M);
    h_true = h_true + kappa_true(t) * rho_t;
    H_true_mat = H_true_mat + kappa_true(t) * reshape(rho_t, M, Nt_BS);
end
norm_h_true_sq = norm(h_true)^2; 
fprintf('>>> 真实信道生成完毕，||h||^2 = %.2f <<<\n', norm_h_true_sq);
Actual_SE_vs_PL  = zeros(size(PL_dBm));
Actual_NSE_vs_PL = zeros(size(PL_dBm));

for i_PL = 1:length(PL_dBm)
    W_opt = Result(i_PL).W; % 提取当前 PL 下优化好的 W
    
    SE_mc = zeros(num_MC, 1);
    % 蒙特卡洛仿真计算误差
    for mc = 1:num_MC
        % 每次随机生成新的符号矩阵 S 并构造 X (保持不变)
        X = zeros(Nt_BS, L);
        for k = 1:K_IU
            S_k = (randn(NR_IU, L) + 1j * randn(NR_IU, L)) / sqrt(2);
            X = X + W_opt{k} * S_k;
        end
        % 构造 A 矩阵，对应公式(16)中的 (X^T \otimes I_M)
        A = kron(X.', eye(M));
        % 构造向量化噪声，对应公式(16)中的 \nu_R
        nu_R = (randn(M * L, 1) + 1j * randn(M * L, 1)) * sqrt(noise / 2);
        %生成雷达接收信号，对应公式(16)的 y_R = (X^T \otimes I_M)h + \nu_R
        y_r = A * h_true + nu_R;
        %进行 Least Squares 估计，对应公式(21)
        % 其中 A' 对应 (X^T \otimes I_M)^H
        % pinv(A' * A) 对应 [(X^T \otimes I_M)^H(X^T \otimes I_M)]^{\dagger}
        h_hat = pinv(A' * A) * (A' * y_r);
        % 记录单次平方误差 (保持不变)
        SE_mc(mc) = norm(h_true - h_hat)^2;
    end
    % 计算平均误差和归一化误差
    Actual_SE_vs_PL(i_PL) = mean(SE_mc);
    Actual_NSE_vs_PL(i_PL) = Actual_SE_vs_PL(i_PL) / norm_h_true_sq;
    
    fprintf('  PL = %3d dBm -> Actual SE: %.4e, Actual NSE: %.4e\n', ...
            PL_dBm(i_PL), Actual_SE_vs_PL(i_PL), Actual_NSE_vs_PL(i_PL));
end
% 保存数据
save_filename = ['Actual_Error_Data_L_', num2str(L), '.mat'];
save(save_filename, 'PL_dBm', 'Actual_SE_vs_PL', 'Actual_NSE_vs_PL', 'L', 'norm_h_true_sq');
fprintf('=== L = %d 的实际误差数据已成功保存至 %s ===\n', L, save_filename);