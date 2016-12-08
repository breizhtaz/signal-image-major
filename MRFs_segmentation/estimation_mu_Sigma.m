function [mu Sigma] = estimation_mu_Sigma(X)

% Author: Gweltaz Lever, ISAE Supaero, All rights reserved.

[dimension,nb_donnees] = size(X);
mu = sum(X,1)/dimension;
X_moyen = mu*ones(dimension,1);
X_centre = X-X_moyen;
Sigma = transpose(X_centre)*X_centre/dimension;
