function [ u ] = rof_gradient( f, nit, dt, lambda, epsilon )
%ROF_GRADIENT 
% Algorithme de Rudin-Osher-Fatemi (descente de gradient)

u = f;

  for i=1:nit
      
      u = u + dt*(curvature(u, epsilon)-1/lambda*(u-f));
      
      % Affichage
      figure(1); colormap(gray);imagesc(u);axis equal
      title(sprintf('ROF desc grad : Iteration %i/%i',i-1,nit));
  end

end

