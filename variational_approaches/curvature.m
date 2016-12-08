function [ c ] = curvature( u , epsilon)
% Calcul de la courbure en tout point de notre image
% epsilon : param?tre de stabilisation du calcul dans les zones homogenes
% (division par zero rendrait l'algo instable)
[gradx, grady] = gradient(u);

% Courbure
qx = gradx./(sqrt(gradx.^2+grady.^2+epsilon^2)); 
qy = grady./(sqrt(gradx.^2+grady.^2+epsilon^2));

c = divergence(qx,qy);

end

