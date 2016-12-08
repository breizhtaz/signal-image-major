function [ u ] = deconvolution_FBS( f, nit, tau, lambda, nu, epsilon, sigma )
%DECONVOLUTION_FBS 
% Algorithme de deconvolution base sur du Forward Backward Splitting
% Inputs : 
% f : l'image bruitee
% nit : nombre d'iterations
% tau : pas de temps
% sigma^2 : variance du noyau gaussien 

u = f;

for i = 1:nit
    % Calcul de v
    convol1 = Convolution_Gaussian(u,sigma);
    convol = Convolution_Gaussian(f-convol1, sigma); 
    v = u + nu*convol;
    
    [gradu_x gradu_y] = gradient(u); % calcul du second terme de l'eq. 39
    dist2 = (gradu_x.^2 + gradu_y.^2);
    gu_x = gradu_x./(epsilon^2 + dist2);
    gu_y = gradu_y./(epsilon^2 + dist2);
    div_nu = divergence(gu_x, gu_y);
    
    u = u - tau*(convol + lambda*div_nu);
    
end



end

