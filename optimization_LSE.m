function [W, obj_LSE, obj_fS, obj_time, obj_MM, count] = optimization_LSE(P, K_IU, Nt_BS, NR_IU, noise, L)
    A1 = randn(Nt_BS, K_IU, NR_IU);
    Wd = zeros(Nt_BS, K_IU, NR_IU); 
    for n = 1:Nt_BS
        for k = 1:K_IU
            for m = 1:NR_IU
                Wd(n,k,m) = cos(A1(n,k,m)) - 1i * sin(A1(n,k,m));
            end
        end
    end
    W_init = cell(1, K_IU);
    for k = 1:K_IU
        % Power normalization to satisfy \sum_k ||W_k||_F^2 <= P
        W_init{k} = squeeze(Wd(:,k,:)) * sqrt(P / (Nt_BS * K_IU * 2)); 
    end  
    W = W_init;
    W_total = [];
    for k = 1:K_IU
        W_total = [W_total, W{k}];  
    end
     [f_S, LSE_error] = LSE_eval(W_total, Nt_BS, K_IU, NR_IU, noise, L);
    
    obj_fS(1)  = f_S;
    obj_LSE(1) = LSE_error;
    %优化主循环
    count = 2;     
    max_iter = 200; 

    while count <= max_iter
        tic; 
        % 调用script_W_LSE更新预编码矩阵 W
        [W, current_surrogate] = script_W_LSE(W, K_IU, NR_IU, Nt_BS, P, noise, L);
        % 重新拼接更新后的 W
        W_total = [];
        for k = 1:K_IU
            W_total = [W_total, W{k}];
        end
        % 评估更新后的目标函数值
        [f_S, LSE_error] = LSE_eval(W_total, Nt_BS, K_IU, NR_IU, noise, L);
        % 记录历史数据
        obj_fS(count)  = f_S;
        obj_LSE(count) = LSE_error;
        obj_time(count - 1) = toc;
        obj_MM(count - 1) = current_surrogate; 
        
        % 收敛判断
        if abs((obj_fS(count) - obj_fS(count-1)) / obj_fS(count-1)) <= 1e-4
            break; % 满足收敛条件，跳出循环
        end
        
        count = count + 1;
    end
end