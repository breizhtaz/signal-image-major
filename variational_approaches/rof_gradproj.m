function [ u ] = rof_gradproj( f, nit, tau, lambda )
%ROF_GRADPROJ 
%   Algorithme du gradient projete

px = zeros(size(f));
py = zeros(size(f));
[M N] = size(f);



for k = 1:nit
    div_p = divergence(px, py);
    v = f/lambda + div_p;
    [gradvx gradvy] = gradient(v);
    abs = sqrt((px+tau*gradvx).^2 + (py + tau*gradvy).^2);
    maximum = max(ones(size(abs)),abs);
    
    px = (px + tau*gradvx)./maximum; 
    py = (py + tau*gradvy)./maximum;
end

    u = lambda*v;
    % Affichage
    figure(1); colormap(gray);imagesc(u);axis equal
    title(sprintf('ROF gradient projete'));


end

