function [mu_a,mu_b] = find_mu_init(b_s_k,C_s_k,Nt_BS,K_IU,NR_IU,P)
mu_a = 0;
mu_b = 2;
mu = (mu_a + mu_b)/2;
term = norm(pinv(C_s_k + mu .* eye(Nt_BS*K_IU*NR_IU))*b_s_k','fro')^2;
if term <= P
    mu_b = mu;
else
    mu_a = mu;
    count = 1;
    while count <= 100
        term = norm(pinv(C_s_k + 2 * mu_a .* eye(Nt_BS*K_IU*NR_IU))*b_s_k','fro')^2;
        if term <= P
            mu_b = 2 * mu_a;
            break
        else
            mu_a = 2 * mu_a;
        end
    end
end
end