function [ U ] = calcul_U( abscisses_disques_courants, ordonnees_disques_courants, ...
    attache_donnees, beta, R )
% Author: Gweltaz Lever, ISAE Supaero, All rights reserved.
% CALCUL_U 
% Permet de calculer l'energie U en prenant en compte l'attache aux donnees
% et la penalite d'intersection

delta = [];

for i = 1:(length(abscisses_disques_courants)-1)
    for j = (i+1):length(abscisses_disques_courants)
        dist = sqrt((abscisses_disques_courants(i)-abscisses_disques_courants(j)).^2 ...
            +(ordonnees_disques_courants(i)-ordonnees_disques_courants(j)).^2);
        
        bool  = (dist < sqrt(2)*R);
        delta = [delta bool];
    end
end

U_attache = sum(attache_donnees);
U_penalite = beta*sum(delta);

U = U_attache + U_penalite;
end

