%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%         Approches variationnelles et EDP pour le traitement d'images    %
%                                    TP2                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gweltaz Lever, ISAE Supaero, All rights reserved.

clear all;
close all;
clc

% Parametres
pas = 8;

% Discretisation 
Im = imread('lena.png');
Im = im2double(Im);
Im = rgb2gray(Im);

[M N] = size(Im);

% Gradient
[gradx grady] = gradient(Im);
[x,y] = meshgrid(1:pas:M, 1:pas:N);

figure;
imshow(Im);
hold on
quiver(1:8:M,1:8:N,gradx(1:8:end,1:8:end), grady(1:8:end,1:8:end));
set(gca,'YDir','reverse');
title('Representation du gradient');
hold off

% Lapalcien
Lapalcien = divergence(gradx,grady);

figure;
imshow(Lapalcien);
title('Laplacien de l''image')

% Courbure
courbure = curvature(Im, 10^(-3));

figure;
imshow(courbure);

%% Test courbure carre
[X,Y]=meshgrid(-256:256-1,-256:256-1);
sigma = 2;

% Convolution par une gaussienne
G = Gaussian(512,512,sigma);
u=double(max(abs(X),abs(Y))<=128);% carre
ug=ifft2(fft2(G).*fft2(u));


% Calcul du gradient
[gradx grady] = gradient(ug);

% Calcul de la courbure
courbure = curvature(ug, 10^(-3));

figure;colormap gray;imagesc(courbure);

% Courbure forte au niveau des forts changements lorsqu'on suit une ligne de
% niveau: d'ou forte valeur dans les coins

%% Equation de la chaleur

% test sur image non bruitee
dt = 0.1;%pas de temps
it = 300;
I = Im;

I = eq_chaleur(I,it,dt);

% test sur image bruitee
Ib = imnoise(Im,'salt & pepper', 0.05);
Ibf = Ib;

Ibf = eq_chaleur(Ibf,it,dt);


figure;
subplot(2,2,1); colormap gray; imagesc(Im);
title('Image non bruitee initiale');
subplot(2,2,2); colormap gray; imagesc(I);
title('Image non bruitee finale');
subplot(2,2,3); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(2,2,4); colormap gray; imagesc(Ibf);
title('Image bruitee finale');

% Convolution Gaussienne
sigma = 4;
Ig = Convolution_Gaussian(Im,sigma);

figure; colormap gray;imagesc(Ig);
title('convolution par une gaussienne');

% Detecteur Hildrett-Marr
%img = Convolution_Gaussian(Im,10);
Ih = hildrett(I, 0.0001);
figure(3); colormap gray; imagesc(Ih);

% Fonction edge
Ie = edge(Im, 'sobel');
figure; colormap gray;imagesc(Ie);

%% Perona Malik

% test sur image non bruitee
dt = 0.3;%pas de temps
it = 200;
alpha = 0.01;
n = 2;
Ip = Im;

Ip = perona(Ip,it,dt, alpha, n);

% test sur image bruitee
Ib = imnoise(Im,'salt & pepper', 0.05);
Ibfp = Ib;

Ibfp = perona(Ibfp,it,dt, alpha, n);

% Resultats
figure;
subplot(2,2,1); colormap gray; imagesc(Im);
title('Image non bruitee initiale');
subplot(2,2,2); colormap gray; imagesc(Ip);
title('Image non bruitee finale');
subplot(2,2,3); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(2,2,4); colormap gray; imagesc(Ibfp);
title('Image bruitee finale');

%imwrite(Ibfp,'perona_b11.png')

