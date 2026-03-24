function [rho] = generate_steering_vectors(theta_deg, phi_deg, Na, Ne, M)
    theta = deg2rad(theta_deg);
    phi = deg2rad(phi_deg);
    d = 0.5;
    alpha = zeros(Na * Ne, 1);
    for ne = 1:Ne
        for na = 1:Na
            n = (ne-1)*Na + na; 
            phase = 2*pi * ((ne-1)*d*sin(theta)*cos(phi) + (na-1)*d*cos(theta));
            alpha(n) = exp(-1j * phase); 
        end
    end
    beta = exp(-1j * 2*pi * (0:M-1)' * d * sin(theta) * cos(phi));
    rho_1= beta * alpha';
    rho = rho_1(:);  % 展平矩阵成列向量
end