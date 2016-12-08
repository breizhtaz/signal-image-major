function [ u ] = eq_chaleur( u0, nit , dt )

u=u0;
tau=dt;
    for i=1:nit
        u=u + tau*laplacien(u);
        
        figure(1); colormap(gray);imagesc(u);axis equal
        title(sprintf('Equation chaleur : Iteration %i/%i',i-1,nit));
    
    end
end