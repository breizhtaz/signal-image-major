function [ h ] = hildrett( u, epsilon )
%HILDRETT 
% cherche les zeros du laplacien d'une image

l = laplacien(u);
[gradx, grady] = gradient(u);

h=double((abs(l)<epsilon));


end

