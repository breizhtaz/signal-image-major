function [ u ] = tychonov_grad( f , lambda, nit , dt)
%TYCHONOV_GRAD Resolution du probleme de minimisation
% inf ||f-u||^2 + 2*lambda ||grad(u)||^2
% On applique la methode de Tychonov par descente de gradient
% INPUTS
% f : image bruite par un bruit gaussien
% lambda : parametre de regularisation
% nit : nombre d'iterations
% dt : pas de temps
% OUTPUT
% u : image restauree

u = f;

 for i=1:nit
        u = u + dt*(lambda*(laplacien(u)) - u + f);
        
        figure(1); colormap(gray);imagesc(u);axis equal
        title(sprintf('Tychonov : Iteration %i/%i',i-1,nit));
    
    end


end

