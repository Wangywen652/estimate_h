clc; clear; close all;
N_a   = 4;
N_e   = 4;
Nt_BS = N_a * N_e;
K_IU  = 6;
NR_IU = 2;
noise = 1;
L = 24;                    
PL_dBm = [0, 100, 200, 300, 400,500];  
LSE_vs_PL = zeros(size(PL_dBm));
M = 16; % 雷达接收端天线数
theta_deg = [30, 45, 60];  
phi_deg   = [10, -20, 50]; 
kappa_true = [1.0, 0.8 + 0.5j, 0.6 - 0.3j]; 

T = length(theta_deg);
h_true = zeros(M * Nt_BS, 1);     
for t = 1:T
    rho_t = generate_steering_vectors(theta_deg(t), phi_deg(t), N_a, N_e, M);
    h_true = h_true + kappa_true(t) * rho_t;
end
norm_h_true_sq = norm(h_true)^2; 
fprintf('\n>>>||h||^2 = %.2f <<<\n', norm_h_true_sq);
% ================================================================

fprintf('\n======================================\n');
fprintf('>>> 当前正在独立仿真 L = %d <<<\n', L);
fprintf('======================================\n');

for i_PL = 1:length(PL_dBm)
    PL_W = PL_dBm(i_PL);
    P0 = PL_W / L;
    P = 10.^(P0/10) * 1e-3;
    fprintf('PL = %d dBm,  L = %d,  P = %e W\n', PL_dBm(i_PL), L, P);
 
    [W, obj_LSE, obj_fS, obj_time, obj_MM, count] = optimization_LSE(P, K_IU, Nt_BS, NR_IU, noise, L);
    LSE_vs_PL(i_PL) = obj_LSE(end);
    
    Result(i_PL).PL_dBm  = PL_dBm(i_PL);
    Result(i_PL).P_limit = P;             
    Result(i_PL).obj_LSE = obj_LSE;       
    Result(i_PL).W       = W;             
end

True_MMSE_vs_PL = LSE_vs_PL;
NMSE_vs_PL = True_MMSE_vs_PL / norm_h_true_sq;

filename = ['Simulation_LSE_Data_L_', num2str(L), '.mat'];
save(filename, 'PL_dBm', 'LSE_vs_PL', 'True_MMSE_vs_PL', 'NMSE_vs_PL', 'norm_h_true_sq', 'M', 'L', 'Result');
fprintf('=== L = %d 的仿真完成，已保存至 %s ===\n', L, filename);