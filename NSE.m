clc;
clear;
load('Algorithm1_LSE_result_N_36_P_20_L_48.mat'); 
num_sims = length(Result);
min_LSE_val = inf;
best_idx = 1;
for s = 1:num_sims
    current_LSE_history = Result(s).obj_LSE;
    current_LSE_history = current_LSE_history(~isnan(current_LSE_history)); % 去除 NaN
    if ~isempty(current_LSE_history)
        final_LSE = current_LSE_history(end);
        if final_LSE < min_LSE_val
            min_LSE_val = final_LSE;
            best_idx = s;
        end
    end
end
W_opt = Result(best_idx).W; 
N_a = 4;                 
N_e = 4;                 
M = 16; %  ULA 天线数量
theta_deg = [30, 45, 60];  
phi_deg   = [10, -20, 50]; 
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

num_MC = 1000; 
SE_history = zeros(num_MC, 1);
NSE_history = zeros(num_MC, 1);
for mc = 1:num_MC
    X = zeros(Nt_BS, L);
    for k = 1:K_IU
        S_k = (randn(NR_IU, L) + 1j * randn(NR_IU, L)) / sqrt(2);
        X = X + W_opt{k} * S_k;
    end

    sigma_R2 = noise; % 雷达端噪声方差
    N_r = (randn(M, L) + 1j * randn(M, L)) * sqrt(sigma_R2 / 2);
    Y_R_mat = H_true_mat * X + N_r;
    H_hat_mat = Y_R_mat * pinv(X);
    h_hat = H_hat_mat(:); 
    SE_history(mc) = norm(h_true - h_hat)^2;
    NSE_history(mc) = SE_history(mc) / norm_h_true_sq;
end

mean_SE = mean(SE_history);
mean_NSE = mean(NSE_history);
mean_NSE_dB = 10 * log10(mean_NSE);

fprintf('||h||^2 : %.2f\n', norm_h_true_sq);
fprintf('平方误差 (MSE)      : %e\n', mean_SE);
fprintf('归一化平方误差 (NMSE)   : %e\n', mean_NSE);
fprintf('NMSE (in dB)           : %.2f dB\n', mean_NSE_dB);