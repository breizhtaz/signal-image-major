function [ u ] = deconvolution_FA( f, nit, tau, lambda, epsilon, sigma )
%DECONVOLUTION_FA Calcul de la deconvolution par fonctionnelle approchee.
% Notre algorithme se base sur une descente de gradient
% Inputs : 
% f : l'image bruitee
% nit : nombre d'iterations
% tau : pas de temps
% lambda
% epsilon : parametre empechant l'instabilite de notre division par |grad(u)|
% sigma^2 : variance du noyau gaussien 

u = f;
[M N] = size(f);

for i=1:nit
    convol1 = Convolution_Gaussian(u,sigma);
    convol = Convolution_Gaussian(convol1-f, sigma); % calcul du premier terme
    
    [gradu_x gradu_y] = gradient(u); % calcul du second terme de l'eq. 39
    dist2 = (gradu_x.^2 + gradu_y.^2);
    gu_x = gradu_x./(epsilon^2 + dist2);
    gu_y = gradu_y./(epsilon^2 + dist2);
    div_nu = divergence(gu_x, gu_y);
    
    u = u - tau*(convol - lambda*div_nu);
    
    % Affichage
      figure(1); colormap(gray);imagesc(u);axis equal
      title(sprintf('Deconvolution desc grad : Iteration %i/%i',i-1,nit));
end

end

