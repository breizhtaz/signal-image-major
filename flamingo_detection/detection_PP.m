%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apprentissage artificiel : detection de flamants roses %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Gweltaz Lever, ISAE Supaero, All rights reserved.

% Le projet se deroule en deux etapes :
% 1) Detection de flamants roses sans a priori.
% 2) Detection de flamants roses avec a priori.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etape 3 : Detection par processus ponctuels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all, clc;


% Lecture et affichage de l'image :
I = imread('colonie.png');
I = double(I);
I = I(1:500,1:500);
[nb_lignes,nb_colonnes] = size(I);
figure('Name','Image d''origine','Position',[0,0,550,500]);
imagesc(I);
axis('image');							% Orientation des axes : x <-> j et y <-> i
nb_nvg = 256;
colormap(gray(nb_nvg));
hx = xlabel('$x$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('$y$','FontSize',20);
set(hy,'Interpreter','Latex');

disp('Tapez retour-chariot pour lancer la detection');
pause;

% Parametres divers :
%N = 50;									% Nombre de disques d'une configuration
R = 10;									% Rayon d'un disque
R_au_carre = R*R;
nb_points_cercle = 30;
increment_angulaire = 2*pi/nb_points_cercle;
theta = 0:increment_angulaire:2*pi;
rose = [253 108 158]/255;
q_max = 1000000;
nb_points_sur_la_courbe = 500;
intervalle_entre_points_sur_la_courbe = floor(q_max/nb_points_sur_la_courbe);
energie_max = 12000;
temps_affichage = 0.01;

% Parametres processus ponctuels
beta = 1.0;
S = 150;
gamma = 5.0;
T0 = 0.1; % temperature initiale
lambda0 = 100.0; % taux de naissance initial
alpha = 0.99;

% Initialisation de l'algorithme naissances et morts multiples
T = T0;
lambda = lambda0;
abscisses_disques_courants = [];
ordonnees_disques_courants = [];
intensites_courantes = [];
attache_donnees = [];

% Initialisation de la condition d'arret
stop = 0;

while(stop ~=1)
    abscisses_disques_prec = abscisses_disques_courants;
    ordonnees_disques_prec = ordonnees_disques_courants;
    
    %%% Naissances %%%
    % Tirage aleatoire du nombre de nouveaux disques
    N_tild = poissrnd(lambda);
    
    % Tirage aleatoire d'une configuration qui s'ajoute a la configuration courante :
    abscisses_centres_disques_nouveaux = zeros(N_tild,1);
    ordonnees_centres_disques_nouveaux = zeros(N_tild,1);
    energies = zeros(N_tild,1);
    for k = 1:N_tild
        abscisse_centre_disque = rand(1,1)*nb_colonnes;
        ordonnee_centre_disque = rand(1,1)*nb_lignes;
        abscisses_centres_disques_nouveaux(k) = abscisse_centre_disque;
        ordonnees_centres_disques_nouveaux(k) = ordonnee_centre_disque;

        cpt_pixels = 0;
        somme_nvg = 0;
        for j = max(1,floor(abscisse_centre_disque-R)):min(nb_colonnes,ceil(abscisse_centre_disque+R))
            for i = max(1,floor(ordonnee_centre_disque-R)):min(nb_lignes,ceil(ordonnee_centre_disque+R))
                abscisse_relative = j-abscisse_centre_disque;
                ordonnee_relative = i-ordonnee_centre_disque;
                if abscisse_relative*abscisse_relative+ordonnee_relative*ordonnee_relative<=R_au_carre
                    cpt_pixels = cpt_pixels+1;
                    somme_nvg = somme_nvg+I(i,j);
                end
            end
        end
        energies(k) = somme_nvg/cpt_pixels;
    end
    
    abscisses_disques_courants = [abscisses_disques_courants; abscisses_centres_disques_nouveaux];
    ordonnees_disques_courants = [ordonnees_disques_courants; ordonnees_centres_disques_nouveaux];
    intensites_courantes = [intensites_courantes; energies];
    
    %%% Tri des disques %%%
    % Calcul de l'attache aux donnees
    Ntot = length(abscisses_disques_courants);
    attache_donnees_nouvelles = 1 - 2./(1 + exp(-gamma*(energies/S-1)));
    attache_donnees = [attache_donnees; attache_donnees_nouvelles];
    
    % Tri 
    [attache_temp1 IX] = sort(attache_donnees,'descend');
    abscisses_disques_courants = abscisses_disques_courants(IX);
    ordonnees_disques_courants = ordonnees_disques_courants(IX);
    intensites_courantes = intensites_courantes(IX);
    attache_donnees = attache_temp1;
    
    U_complet = calcul_U( abscisses_disques_courants, ordonnees_disques_courants, ...
    attache_donnees, beta, R );

    %%% Morts %%%
    i = 1;
    while(i~=(length(abscisses_disques_courants)+1))
        abscisses_temp = abscisses_disques_courants;
        abscisses_temp(i) = [];
        ordonnees_temp = ordonnees_disques_courants;
        ordonnees_temp(i) = [];
        attache_temp = attache_donnees;
        attache_temp(i) = [];
        
        % Calcul des energies avec et sans le disque considere
        U_sans = calcul_U( abscisses_temp, ordonnees_temp, attache_temp, beta, R );
        
        proba = lambda/(lambda + exp((U_sans-U_complet)/T));
        
        % Suppression de l'element i selon la proba
        if(rand<proba)
           abscisses_disques_courants(i) = [];
           ordonnees_disques_courants(i) = [];
           attache_donnees(i) = [];
           intensites_courantes(i) = [];
           U_complet = U_sans;
           % Pas besoin de se decaler, l'element suivant est desormais en
           % position i
        else
           i = i+1; % pas d'element supprime donc on passe a l'element suivant
        end
    end
    
    %%% Condition d'arret %%%
    if(length(abscisses_disques_courants) == length(abscisses_disques_prec))&&(isempty(abscisses_disques_courants) == 0)
        if(isequal(abscisses_disques_courants, abscisses_disques_prec)&& isequal(ordonnees_disques_courants,ordonnees_disques_prec))
            stop = 1;
        end
    else 
        T = alpha*T;
        lambda = alpha*lambda;
    end    
    
        hold off;
    imagesc(I);
    axis('image');
    colormap(gray(nb_nvg));
    hx = xlabel('$x$','FontSize',20);
    set(hx,'Interpreter','Latex');
    hy = ylabel('$y$','FontSize',20);
    set(hy,'Interpreter','Latex');
    hold on;
    if(isempty(abscisses_disques_courants) == 0)
        for k = 1:length(abscisses_disques_courants)
            abscisses_cercle = abscisses_disques_courants(k)+R*cos(theta);
            ordonnees_cercle = ordonnees_disques_courants(k)+R*sin(theta);
            plot(abscisses_cercle,ordonnees_cercle,'Color',rose,'LineWidth',2);
        end
    end
    pause(temps_affichage);

end



