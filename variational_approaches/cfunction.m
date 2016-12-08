function [ ct ] = cfunction( t , alpha, n )
%CFUNCTION calcule la valeur de la fonction c
% alpha un parametre de la fonction c
% le parametre n determine la forme de la fonction decroissante

if(n == 1)
    ct = 1./sqrt(1 + (t./alpha)^2);
else
    ct = 1./(1 + (t./alpha)^2);
end

end

