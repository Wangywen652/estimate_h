function [W_update, surrogate_val] = script_W_LSE(W_init, K_IU, NR_IU, Nt_BS, P, noise, L)
    W_total_init = [];
    for k = 1:K_IU
        W_total_init = [W_total_init, W_init{k}];
    end
    % 构建基础矩阵V和Y
    V = W_total_init.'; 
    Y = V * V' + (noise / L) * eye(K_IU * NR_IU);

    % 计算A_s和B_s ---
    A_s = V' * pinv(Y); 
    temp_B = (pinv(Y) * V)';
    B_s = kron(temp_B, eye(Nt_BS)); 

    %提取二次型参数a_s, b_s 和C_s ---
    a_s = -(noise / L) * norm(pinv(Y) * V, 'fro')^2;
    b_s = reshape(A_s, [], 1).'; 
    C_s = B_s' * B_s;
    %更新W
    term_1 = norm(pinv(C_s) * b_s', 'fro')^2;

    if term_1 <= P
        W_vec_update = pinv(C_s) * b_s';
    else
        [mu_a, mu_b] = find_mu_init(b_s, C_s, Nt_BS, K_IU, NR_IU, P);
        [mu] = find_mu(b_s, C_s, Nt_BS, K_IU, NR_IU, P, mu_a, mu_b);
        W_vec_update = pinv(C_s + mu .* eye(size(C_s))) * b_s';
    end
    surrogate_val = real(a_s + 2 * real(b_s * W_vec_update) - W_vec_update' * C_s * W_vec_update);

    W_total_update = reshape(W_vec_update, Nt_BS, []);
    W_update = cell(1, K_IU);
    for k = 1:K_IU
        W_update{k} = W_total_update(:, (k-1)*NR_IU+1 : k*NR_IU);
    end
end