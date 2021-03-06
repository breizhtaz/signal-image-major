function [ Irec SNR ] = wavelet_thresholding( f, thres, string, original)
%WAVELET_THRESHOLDING Performs the wavelet thresholding on a noisy image
%   INPUTS
% f : image to be denoised
% thres : threshold value
% string : type of wavelet used
% original image

[wave_dec S] = wavedec2(f, 8, string ); % decomposition
Ithres = wthresh(wave_dec, 's', thres); % thresholding
Irec = waverec2(Ithres, S, string); % reconstruction

figure;
subplot(1,2,1); colormap gray; imagesc(f);
title('Image bruitee initiale');
subplot(1,2,2); colormap gray; imagesc(Irec);
title(sprintf('Seuillage ondelettes treshold : %i', thres));

SNR = snr(original, Irec)
end

