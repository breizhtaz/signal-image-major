%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%         Approches variationnelles et EDP pour le traitement d'images    %
%                                    TP4                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc

% chargement de l'image
Im = imread('lena.png');
Im = im2double(Im);
Im = rgb2gray(Im);
[M N] = size(Im);

% Ajout de bruit (suppose gaussien)
Ib = imnoise(Im,'gaussian', 0.01);
%figure,colormap gray;imagesc(Ib);
snr(Im,Ib)

%% Regularisation de Tychonov  
% Par descente de gradient et transformee de Fourier

% Parametres
lambda = 2 % optimum pour le cas desc grad | pour TF = 0.7
nit = 300;
dt = 0.05;

% Application de la regularisation
%tic
If = tychonov_grad( Ib , lambda, nit , dt);
%toc

lambda = 0.7
%tic
Iftf = tychonov_TF(Ib, lambda);
%toc

% Resultats
figure;
subplot(2,2,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(2,2,2); colormap gray; imagesc(If);
title('Image finale descente de gradient');
subplot(2,2,3); colormap gray; imagesc(Iftf);
title('Image finale par transformee de Fourier');


% SNR
SNRinitial = snr(Im, Ib) % SNR initial
SNRfinal_gradient = snr(Im, If) % SNR final en descente du gradient
SNRfinal_tf = snr(Im, Iftf) % SNR final en tf

%imwrite(Ib,'lena_bruit_gaus.png')
%imwrite(Iftf,'lena_tychonov_tf_lambda07.png')

%% Recherche du lambda optimal (cas TF ou desc gradient)

lambda = [0.1 : 0.1 : 10];
SNR = zeros(length(lambda),1);
i = 1;
for l = lambda
   %If = tychonov_grad( Ib , l, nit , dt);
   %SNR(i) = snr(Im,If);
   Iftf = tychonov_TF(Ib, l); 
   SNR(i) = snr(Im,Iftf);
   i = i+1;
end

[Maximum pos] = max(SNR);

lambda(pos) % on obtient 0.8 et un SNR de 22.67 pour le cas TF | 2 pour desc grad

%% Modele de Rudin-Osher-Fatemi

% Descente de gradient
epsilon = 1;
lambda = 1.5; 
% lambda = [1.2:0.1:2];  % on cherche une valeur correcte pour lambda
nit = 200;
SNR_rof_grad = zeros(size(lambda,1));
%tic
i=1;
for l = lambda
dt = 2/(1+8*l/epsilon); % valeur maximale de dt = 2/(1+8*lambda/epsilon)

Irof_grad = rof_gradient( Ib, nit, dt, l, epsilon );

SNR_rof_grad(i) = snr(Im, Irof_grad)
i = i+1;
end
%toc

figure;
subplot(1,2,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(1,2,2); colormap gray; imagesc(Irof_grad);
title('Image finale ROF descente gradient');

% Algorithme de Chambolle
nit = 100;
lambda = 0.1;
%lambda = [0.01 :0.05:0.25]; % pour la recherche de lambda optimum
tau = 1/8;
SNR_rof_chamb = zeros(size(lambda,1));
i = 1;
%tic
for l = lambda
Irof_chamb = rof_chambolle( Ib, nit, tau, l );

SNR_rof_chamb(i) = snr(Im, Irof_chamb)
i = i+1;
end
%toc

figure;
subplot(1,2,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(1,2,2); colormap gray; imagesc(Irof_chamb);
title('Image finale ROF Chambolle');

% Algorithme du gradient projete
nit = 200;
lambda = 0.1;
%lambda = [0.01 :0.05:0.25];
tau = 1/8;

SNR_rof_gp = zeros(size(lambda,1));
i = 1;
%tic
for l = lambda
Irof_gp = rof_gradproj( Ib, nit, tau, l );
SNR_rof_gp(i) = snr(Im, Irof_gp)
i = i+1;
end
%toc

figure;
subplot(1,2,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(1,2,2); colormap gray; imagesc(Irof_gp);
title('Image finale ROF gradient projete');

% Algorithme de Nestorov
nit = 100;
lambda = 0.1;
%lambda = [0.01 :0.05:0.25];

SNR_rof_nest = zeros(size(lambda,1));
i = 1;
tic
for l = lambda
Irof_nest = rof_nesterov( Ib, nit, l );
SNR_rof_nest(i) = snr(Im, Irof_nest)
i = i+1;
end
toc

figure;
subplot(1,2,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(1,2,2); colormap gray; imagesc(Irof_nest);
title('Image finale ROF Nesterov');

%% Deconvolution

% Deconvolution par descente de gradient
nit = 50;
lambda = 0.02;
tau = 1/8;
epsilon = 0.1;
sigma = 2;

%lambda = [0.01 :0.01:0.1];

SNR_dec_FA = zeros(size(lambda,1));
i = 1;

for l = lambda
Idec_fa = deconvolution_FA( Ib, nit, tau, l, epsilon, sigma );
SNR_dec_FA(i) = snr(Im, Idec_fa)
i = i+1;
end

figure;
subplot(1,3,1); colormap gray; imagesc(Ib);
title('Image bruitee initiale');
subplot(1,3,2); colormap gray; imagesc(Idec_fa);
title('Image deconvolution (des grad)');
subplot(1,3,3); colormap gray; imagesc(Idec_fabis);
title('Image deconvolution (desc grad bis)');

imwrite(Idec_fa, 'deconv_fa50.png')

%% Seuillage en ondelettes
% valeur propose par Donoho thres = sigma*sqrt(2*log(M^2));
thres = [0.15:0.01:0.25];
SNR_wave = zeros(length(thres),1);
i = 1;

thres = 0.16
for t = thres

%[Irec SNR_wave(i)]= wavelet_thresholding( Ib, t, 'sym2', Im);
[Irec SNR_wave(i)]= wavelet_thresholding_invariante( Ib, t, 'sym10', Im);
i = i+1;

end

%imwrite(Irec, 'Iwi_sym10_0.16.png')