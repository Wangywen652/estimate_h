clc;
clear;
%发射基站阵列参数
N_a = 4;                 
N_e = 4;                 
Nt_BS = N_a * N_e;     
P = 10.^(15/10)*1e-3;    
L = 24;                  
K_IU = 6;              
NR_IU = 2;             
noise = 1;               
for s = 1:3 
    disp(['--- 正在运行第 ', num2str(s), ' 次仿真 ---']);
    [W, obj_LSE, obj_fS, obj_time, obj_MM, count] = optimization_LSE(P, K_IU, Nt_BS, NR_IU, noise, L);
    Count(s) = count;
    Result(s).obj_LSE = obj_LSE;    
    Result(s).obj_fS = obj_fS;      
    Result(s).obj_time = obj_time; 
    Result(s).obj_MM = obj_MM;   
    Result(s).W = W;                
end
save('Algorithm1_LSE_result_N_36_P_20_L_48.mat', 'Result', 'Count', 'P', 'L', 'K_IU', 'NR_IU', 'Nt_BS', 'noise');
disp('所有仿真运行完毕，结果已保存');
