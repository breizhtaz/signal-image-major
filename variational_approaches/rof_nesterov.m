function [ u ] = rof_nesterov( f, nit, lambda )
%ROF_NESTEROV 
%   Algorithme de Nesterov

k = 0;
L = 8*lambda;
v_x = zeros(size(f));
v_y = zeros(size(f));

x_x = zeros(size(f));
x_y = zeros(size(f));

for i = 1:nit
    [eta_x eta_y] = gradient(f - lambda*divergence(x_x, x_y));
    [y_x y_y] = projection(x_x - eta_x/L, x_y - eta_y/L);
    v_x = v_x + (i+1)/2*eta_x;
    v_y = v_y + (i+1)/2*eta_y;
    [z_x z_y] = projection(-v_x/L, -v_y/L);
    x_x = 2/(i+3)*z_x + (i+1)/(i+3)*y_x;
    x_y = 2/(i+3)*z_y + (i+1)/(i+3)*y_y;
end

u = f - lambda*divergence(y_x, y_y);

end

