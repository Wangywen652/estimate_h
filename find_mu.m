function [mu] = find_mu(b_s_k,C_s_k,Nt_BS,K_IU,NR_IU,P,mu_a,mu_b)
mu = (mu_a+mu_b)/2;
P_a = norm(pinv(C_s_k + mu_a .* eye(Nt_BS*K_IU*NR_IU))*b_s_k','fro')^2;
P_b = norm(pinv(C_s_k + mu_b .* eye(Nt_BS*K_IU*NR_IU))*b_s_k','fro')^2;
count = 1;
while count <= 200
    if (P_a - P_b <= 1e-10)
        break
    end
    mu = (mu_a+mu_b)/2;
    term = norm(pinv(C_s_k + mu .* eye(Nt_BS*K_IU*NR_IU))*b_s_k','fro')^2;
    if term <= P
        mu_b = mu;
        P_b = term;
    else
        mu_a = mu;
        P_a = term;
    end
    count = count+1;
end
end