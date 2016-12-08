function [ divU ] = divergence( ux, uy )
%DIVERGENCE calcule la divergence de u (ux et uy)

divU = dxT(ux)+dyT(uy); 

end

