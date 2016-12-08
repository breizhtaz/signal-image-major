function [ u ] = perona( u0, nit , dt, alpha, n)
% PERONA applique l'algorithme de Perona Malik a l'image u0

u=u0;
tau=dt;

    for i=1:nit
        [gradx grady] = gradient(u);
        norm_u = sqrt( gradx.^2 + grady.^2);
        cu = cfunction(norm_u, alpha, n);
        u=u + tau*divergence(cu.*gradx, cu.*grady);

        figure(1); colormap(gray);imagesc(u);axis equal
        title(sprintf('Perona Malik : Iteration %i/%i',i-1,nit));
    end

end

