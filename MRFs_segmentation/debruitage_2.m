%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apprentissage artificiel : segmentation d'une image par la texture %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Gweltaz Lever, ISAE Supaero, All rights reserved.

% Le projet se deroule en trois etapes :
% 1) Segmentation en classes predefinies (modele de Potts 4-connexe ou 8-connexe).
% 2) Segmentation par classification supervisee.
% 3) Debruitage (deux methodes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Etape 3 : Debruitage (modele de Potts 4-connexe) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function debruitage_2(T_0,q_max,alpha,beta)

% Parametres par defaut de la methode de segmentation :
% A DECOMMENTER
if nargin==0
	T_0 = 1.0;
	q_max = 250;
	alpha = 0.995;
	beta = 2.0;
end
intervalle_entre_affichages = 10;
temps_affichage = 0.5;

% Lecture et affichage de l'image d'origine :
% A DECOMMENTER
% Dans le cas du cameraman
x = cameraman_bruite(20);
%x = imread('image.bmp');
x = double(x);
[nb_lignes,nb_colonnes] = size(x);
figure('Name','Image d''origine','Position',[0,0,550,500]);
imagesc(x);
axis('image');
nb_nvg = 256;
colormap(gray(nb_nvg));

% Initialisation
y = x; % image debruitee
figure('Name','Image segmentee','Position',[550,0,550,500]);
imagesc(y), colormap(gray(nb_nvg));
axis('image');
hold on;
pause(temps_affichage);

% Boucle du recuit simule :
% A COMPLETER/DECOMMENTER
T = T_0;
for q = 1:q_max
	for i = 1:nb_lignes
		for j = 1:nb_colonnes
			intensite_courante = y(i,j);
            intensite_nouvelle = ceil(rand*nb_nvg);
			while intensite_nouvelle==intensite_courante
				intensite_nouvelle = ceil(rand*nb_nvg);
			end

			% Energie correspondant a la vraisemblance (attache aux donnees) :
			energie_courante = (intensite_courante-x(i,j))^2;
            % Attention : la variance est egale au carre de l'ecart-type sigma !
			energie_nouvelle = (intensite_nouvelle-x(i,j))^2;

			% Energie correspondant a l'a priori (modele de Potts 4-connexe) :
			if i>1
				energie_courante = energie_courante ...
                    + beta*((intensite_courante-y(i-1,j))^2);
				energie_nouvelle = energie_nouvelle ...
                    + beta*((intensite_nouvelle-y(i-1,j))^2);
			end
			if j>1
				energie_courante = energie_courante ...
                    + beta*((intensite_courante-y(i,j-1))^2);
				energie_nouvelle = energie_nouvelle ...
                    + beta*((intensite_nouvelle-y(i,j-1))^2);
			end
			if i<nb_lignes
				energie_courante = energie_courante ...
                    + beta*((intensite_courante-y(i+1,j))^2);
				energie_nouvelle = energie_nouvelle ...
                    + beta*((intensite_nouvelle-y(i+1,j))^2);
			end
			if j<nb_colonnes
				energie_courante = energie_courante ...
                    + beta*((intensite_courante-y(i,j+1))^2);
				energie_nouvelle = energie_nouvelle ...
                    + beta*((intensite_nouvelle-y(i,j+1))^2);
			end

			% Dynamique de Metropolis :
			if energie_nouvelle<energie_courante
				y(i,j) = intensite_nouvelle;
			else
				if rand<= exp(-(energie_nouvelle-energie_courante)/T_0)
					y(i,j) = intensite_nouvelle;
				end
			end
		end
	end
	if rem(q,intervalle_entre_affichages)==0
		imagesc(y);
		pause(temps_affichage);
		title(['Pas ' num2str(q) '/' num2str(q_max)]);
	end
	T = alpha*T;
end

