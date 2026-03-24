function [f_S, LSE_error] = LSE_eval(W_total, Nt_BS, K_IU, NR_IU, noise, L)
    % 对应公式 (27) 和 (28)
    V = W_total.'; % V = W^T
    
    % Y = [W^T]^2 + (sigma_R / L) * I_KNr
    Y = V * V' + (noise / L) * eye(K_IU * NR_IU);
    
    % f_S(W) = trace( [W^T]^2 * Y^-1 )
    f_S = real(trace( (V * V') * pinv(Y) ));
    
    % LSE (Least Squared Error) = N - f_S(W)
    LSE_error = real(Nt_BS - f_S);
end
