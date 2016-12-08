function [ pk_x pk_y ] = projection( px, py )
%PROJECTION 
% Calcule la projection orthogonal de notre element de L2 x L2 sur 
% l'ensemble K (cf. Weiss p.27)
d = sqrt(px.^2 + py.^2);
maximum = max(ones(size(d)),d);

pk_x = px./maximum;
pk_y = py./maximum;



end

