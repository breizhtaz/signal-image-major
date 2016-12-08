function [ snr ] = snr( I, Inoisy )
%SNR Calculates the signal to noise ratio beteen the initial image and the
% noisy image

snr = 20*log10(norm(I(:))/norm(I(:)-Inoisy(:)));


end

