function [ u ] = rof_chambolle( f, nit, tau, lambda )
%ROF_CHAMBOLLE 
% Algorithme de projection de Chambolle permettant d'obtenir une image
% restauree a partir de notre image bruitee
px = zeros(size(f));
py = zeros(size(f));
[M N] = size(f);



for k = 1:nit
    div_p = divergence(px, py);
    [gradx grady] = gradient(div_p-f/lambda);
    abs_p = sqrt(gradx.^2 + grady.^2);
    px = (px + tau*gradx)./(1 + tau*abs_p);
    py = (py + tau*grady)./(1 + tau*abs_p);
end

    u = f - lambda*divergence(px, py);
    % Affichage
    figure(1); colormap(gray);imagesc(u);axis equal
    title(sprintf('ROF Chambolle'));

end
