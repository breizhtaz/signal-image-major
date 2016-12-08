%function image=urban(name1,name2,name3,winsize,threshold1,threshold2)
clear all; close all; clc

% Written by Gweltaz Lever, ISAE Supaero & Xavier Descombes, INRIA, All rights reserved

% Lecture de l'image
%if nargin==0
    name1 = 'village.gif';
    name2 = 'village_est1.gif';
    name3 = 'village_est2.gif';
    winsize = 25; %doit etre impair
    threshold1 = 10;
    threshold2 = 8;
%end

imsat = imread(name1);
imsat = double(imsat);
% Affichage de l'image

imagesc(imsat);
colormap(gray);


dim = size(imsat);
offset = (winsize-1)/2;
nb_nvg = 256;
% initialization 

num = winsize*winsize;

est1 = zeros(dim(1),dim(2)); % matrice du 1er estimateur
est2 = zeros(dim(1),dim(2)); % matrice du 2nd estimateur
card_ij = zeros(nb_nvg,nb_nvg); % l'indice (i,j) comptabilise le nombre d'elements de la fenetre
                              % qui ont la moyenne de valeur j (en colonne) et la
                              % valeur du pixel qui vaut i (en ligne).
card_j = zeros(1,nb_nvg); % comptabilise le nombre d'elements de moyenne j.
C = zeros(nb_nvg,nb_nvg); % permet de stocker card_ij/card_j.

x = (0:255);% les intensites
y = zeros(1,256);
Int(:,1:256) = meshgrid(x,y)';

% Computation of the pixel square value

imsquare = double(imsat).*double(imsat);

%%% Calcul de la matrice des voisins

imvoisins = zeros(dim);
% On additionne les differentes contributions des voisins
imvoisins(:,1:end-1) = imsat(:,2:end);
imvoisins(:,2:end) = imvoisins(:,2:end) + imsat(:,1:end-1);
imvoisins(1:end-1,:) = imvoisins(1:end-1,:) + imsat(2:end,:);
imvoisins(2:end,:) = imvoisins(2:end,:) + imsat(1:end-1,:);
% on moyenne
imvoisins(2:end-1,2:end-1) = imvoisins(2:end-1,2:end-1)/4;
imvoisins(2:end-1,1) = imvoisins(2:end-1,1)/3;
imvoisins(2:end-1,end) = imvoisins(2:end-1,end)/3;
imvoisins(1,2:end-1) = imvoisins(1,2:end-1)/3;
imvoisins(end,2:end-1) = imvoisins(end,2:end-1)/3;
imvoisins(1,1) = imvoisins(1,1)/2;
imvoisins(1,end) = imvoisins(1,end)/2;
imvoisins(end,1) = imvoisins(end,1)/2;
imvoisins(end,end) = imvoisins(end,end)/2;

% Original image is called val and mean of
% neighbors moy.
val = imsat;
moy = ceil(imvoisins);


% Sliding window

%%% Initialization
 
 for i = 1 : winsize 
  for j = 1 : winsize
      % on compte les premiers pixels dans la matrice card_ij 
      card_ij(val(i,j)+1,moy(i,j)+1) = card_ij(val(i,j)+1,moy(i,j)+1) + 1;
      card_j(1, moy(i,j)+1) = card_j(1, moy(i,j)+1) + 1; 
  end
 end
 
id = find(card_j);% vecteur des indices non nuls de card_j
for j = id 
    C(:,j) = card_ij(:,j)/card_j(j); % calcul de la proba conditionnelle      
end

%sigma_2 = sum(C.*(0:1:255)'.^2)-(sum(C.*(0:1:255)')).^2;
sigma_2 = sum(C.*(Int.^2)) - (sum(C.*Int)).^2;
[Mx,I] = max(card_j);% moyenne de cardinal maximale

% Estimations calculation 
est1(offset+1,offset+1) = sum(card_j.*sigma_2)/(sum(card_j));
est2(offset+1,offset+1) = max(sigma_2(I)); % on prend le max au cas ou plusieurs indices seraient renvoyes par I (egalite de cardinal)


%%% Main algorithm
 for i = offset+1 : 2 : dim(1)-offset-1 
    
% We scan line i from left to right

  for j = offset+2 : dim(2)-offset
   for k = (-offset) : offset       
      di = i+k; dj = j-offset-1; % on enleve le premier indice
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) - 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) - 1; 
      
      dj = j+offset; % on rajoute le nouvel indice
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) + 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) + 1;   
   end
   
    id = find(card_j);% vecteur des indices non nuls de card_j
    for indice = id 
        C(:,indice) = card_ij(:,indice)/card_j(indice); % calcul de la proba conditionnelle      
    end

   % sigma_2 = C*((0:1:255)'.^2) - (C*(0:1:255)').^2;
    sigma_2 = sum(C.*(Int.^2)) - (sum(C.*Int)).^2;
    [Mx,I] = max(card_j);% moyenne de cardinal maximale

    % Estimations calculation
    est1(i,j) = sum(card_j.*sigma_2)/(sum(card_j));
    est2(i,j) = max(sigma_2(I)); % on prend le max au cas ou plusieurs indices seraient renvoyes par I (egalite de cardinal)
 
 end
  
  % We change from line i to line i+1
  
  for k = (-offset) : offset 
      
      di = i-offset; dj = dim(2)-offset+k;
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) - 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) - 1; 
      
      di = i+1+offset;
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) + 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) + 1; 
  end
      
    id = find(card_j);% vecteur des indices non nuls de card_j
    for indice = id 
        C(:,indice) = card_ij(:,indice)/card_j(indice); % calcul de la proba conditionnelle      
    end

   % sigma_2 = C*((0:1:255)'.^2) - (C*(0:1:255)').^2;
   sigma_2 = sum(C.*(Int.^2)) - (sum(C.*Int)).^2; 
   [Mx,I] = max(card_j);% moyenne de cardinal maximale

    % Estimations calculation
    est1(i+1,dim(2)-offset) = sum(card_j.*sigma_2)/(sum(card_j));
    est2(i+1,dim(2)-offset) = max(sigma_2(I)); % on prend le max au cas ou plusieurs indices seraient renvoyes par I (egalite de cardinal)
 

% We scan line i+1 from right to left

for  j = dim(2)-offset-1 : -1 : offset+1 
     
     for k= (-offset) : offset        
      di = i+1+k; dj = j+offset+1;
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) - 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) - 1; 
      
      dj = j-offset;
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) + 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) + 1;  
     end
     
    id = find(card_j);% vecteur des indices non nuls de card_j
    for indice = id 
        C(:,indice) = card_ij(:,indice)/card_j(indice); % calcul de la proba conditionnelle      
    end

    %sigma_2 = C*((0:1:255)'.^2) - (C*(0:1:255)').^2;
    sigma_2 = sum(C.*(Int.^2)) - (sum(C.*Int)).^2;
    [Mx,I] = max(card_j);% moyenne de cardinal maximale

    % Estimations calculation
    est1(i+1,j) = sum(card_j.*sigma_2)/(sum(card_j));
    est2(i+1,j) = max(sigma_2(I)); % on prend le max au cas ou plusieurs indices seraient renvoyes par I (egalite de cardinal)  

end

%  change line i+1 to i+2
 
if (i<dim(1)-offset-2)

    for k=(-offset) : offset 
       di = i+1-offset; dj = offset+1+k;
       card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) - 1;
       card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) - 1; 
       di = i+2+offset;
      card_ij(val(di,dj)+1,moy(di,dj)+1) = card_ij(val(di,dj)+1,moy(di,dj)+1) + 1;
      card_j(1, moy(di,dj)+1) = card_j(1, moy(di,dj)+1) + 1; 
    end
    
    id = find(card_j);% vecteur des indices non nuls de card_j
    for indice = id 
        C(:,indice) = card_ij(:,indice)/card_j(indice); % calcul de la proba conditionnelle      
    end

    %sigma_2 = C*((0:1:255)'.^2) - (C*(0:1:255)').^2;
    sigma_2 = sum(C.*(Int.^2)) - (sum(C.*Int)).^2;
    [Mx,I] = max(card_j);% moyenne de cardinal maximale

    % Estimations calculation
    est1(i+2,offset+1) = sum(card_j.*sigma_2)/(sum(card_j));
    est2(i+2,offset+1) = max(sigma_2(I)); % on prend le max au cas ou plusieurs indices seraient renvoyes par I (egalite de cardinal)  
 
end  
end
 
% Result plot
figure, imagesc(est1)
figure, imagesc(est2)

imwrite(est1,name2)
imwrite(est2,name3)

% Threshold the texture parameter
 est1bis = est1;
 for i = 1 : dim(1)
      for j = 1 : dim(2)
       if est1(i,j) < threshold1
         est1bis(i,j) = 0;
       else
         est1bis(i,j) = 255;
       end
     end
 end
  
figure
imagesc(est1bis)

est2bis = est2;
 for i = 1 : dim(1)
      for j = 1 : dim(2)
       if est2(i,j) < threshold2
         est2bis(i,j) = 0;
       else
         est2bis(i,j) = 255;
       end
     end
 end
  
figure
imagesc(est2bis)


