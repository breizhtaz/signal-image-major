%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apprentissage artificiel : detection de flamants roses %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Gweltaz Lever, ISAE Supaero, All rights reserved.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etape 4 : detection de flamants roses avec a priori compare a l'etape 3%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
N = 205;								% Nombre de disques d'une configuration
R = 10;									% Rayon d'un disque
R_au_carre = R*R;
nb_points_cercle = 30;
increment_angulaire = 2*pi/nb_points_cercle;
theta = 0:increment_angulaire:2*pi;
rose = [253 108 158]/255;
q_max = 1000000;
nb_points_sur_la_courbe = 500;
intervalle_entre_points_sur_la_courbe = floor(q_max/nb_points_sur_la_courbe);
energie_max = 3*10^4;
temps_affichage = 0.01;

% Tirage aleatoire d'une configuration initiale et calcul de l'energie correspondante :
abscisses_centres_disques = zeros(N,1);
ordonnees_centres_disques = zeros(N,1);
energies = zeros(N,1);

%Initialisation du premier element
abscisse_centre_disque = rand(1,1)*nb_colonnes;
ordonnee_centre_disque = rand(1,1)*nb_lignes;
abscisses_centres_disques(1) = abscisse_centre_disque;
ordonnees_centres_disques(1) = ordonnee_centre_disque;

for k = 2:N
	% Tirage aleatoire d'un nouveau disque. On prend en compte le fait que
	% l'ecart entre le centre du disque et le disque existant doit etre au
	% moins de R.
    t = 1;
    distances = zeros(k-1,1);% vecteur des distances entre le nouveau disque et les disques existants
    while(t == 1)
        abscisse_centre_disque = rand(1,1)*nb_colonnes;
        ordonnee_centre_disque = rand(1,1)*nb_lignes;
        
        distances = sqrt((abscisses_centres_disques(1:k-1)-abscisse_centre_disque*ones(k-1,1)).^2 ...
            +(ordonnees_centres_disques(1:k-1)-ordonnee_centre_disque*ones(k-1,1)).^2);
        
        f = (distances<sqrt(2)*R);% condition sur la distance entre le nouvel objet et les objets existants
        if(f==zeros(k-1,1))
            t = 0;
        end
    end
    
    % on ajoute le disque a l'ensemble
	abscisses_centres_disques(k) = abscisse_centre_disque;
	ordonnees_centres_disques(k) = ordonnee_centre_disque;

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
energies_a_afficher = [sum(energies)];
abscisses_a_afficher = [0];

hold off;
imagesc(I);
axis('image');
colormap(gray(nb_nvg));
hx = xlabel('$x$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('$y$','FontSize',20);
set(hy,'Interpreter','Latex');
hold on;
for k = 1:N
	abscisses_cercle = abscisses_centres_disques(k)+R*cos(theta);
	ordonnees_cercle = ordonnees_centres_disques(k)+R*sin(theta);
	plot(abscisses_cercle,ordonnees_cercle,'Color',rose,'LineWidth',2);
end

pause(temps_affichage);

% Recherche de la configuration optimale :
for q = 1:q_max
	k = rem(q,N)+1;						% On parcourt les N disques en boucle
	energie_courante = energies(k);

	% Tirage aleatoire d'un nouveau disque. On prend en compte le fait que
	% l'ecart entre le centre du disque et le disque existant doit etre au
	% moins de R.
    t = 1;
    distances = zeros(N,1);% vecteur des distances entre le nouveau disque et les disques existants
    while(t == 1)
        abscisse_centre_disque = rand(1,1)*nb_colonnes;
        ordonnee_centre_disque = rand(1,1)*nb_lignes;
        
        distances = sqrt((abscisses_centres_disques-abscisse_centre_disque*ones(N,1)).^2 ...
            +(ordonnees_centres_disques-ordonnee_centre_disque*ones(N,1)).^2);
        
        f = (distances<2*R);% condition sur la distance entre le nouvel objet et les objets existants
        if(f==zeros(N,1))
            t = 0;
        end
    end
    % En realite, il faut ecarter le cas de l'indice k qui n'est plus a
    % tester!
    
	% Calcul de l'energie du nouveau disque :
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
	energie_nouvelle = somme_nvg/cpt_pixels;

	% Si le disque propose est meilleur, mises a jour :
	if energie_nouvelle>energie_courante
		energies(k) = energie_nouvelle;
		abscisses_centres_disques(k) = abscisse_centre_disque;
		ordonnees_centres_disques(k) = ordonnee_centre_disque;

		hold off;
		imagesc(I);
		axis('image');
		colormap(gray(nb_nvg));
		hx = xlabel('$x$','FontSize',20);
		set(hx,'Interpreter','Latex');
		hy = ylabel('$y$','FontSize',20);
		set(hy,'Interpreter','Latex');
		hold on;
		for k = 1:N
			abscisses_cercle = abscisses_centres_disques(k)+R*cos(theta);
			ordonnees_cercle = ordonnees_centres_disques(k)+R*sin(theta);
			plot(abscisses_cercle,ordonnees_cercle,'Color',rose,'LineWidth',2);
		end
		pause(temps_affichage);
	end

	% Ecritures pour tracer la courbe d'energie :
	if rem(q,intervalle_entre_points_sur_la_courbe)==0
		abscisses_a_afficher = [abscisses_a_afficher q];
		energies_a_afficher = [energies_a_afficher sum(energies)];
	end
end

% Trace de l'evolution de l'energie :
figure('Name','Evolution de l''energie','Position',[550,0,550,500]);
plot(abscisses_a_afficher,energies_a_afficher,'r.');
axis([min(abscisses_a_afficher) max(abscisses_a_afficher) 0 energie_max]);
hx = xlabel('$q$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('Energie','FontSize',20);
