function [ u ] = tychonov_TF( f, lambda )
%TYCHONOV_TF regularisation de Tychonov basee sur l'utilisation de la
%transformee de Fourier

d = 10; % elargissement de l'image par reflexion de d pixels
fpro = bord(f, d); % image prolongee
[M, N] = size(fpro);

fft_f = fft2(fpro);

fft_u = zeros(size(fpro));
for i = 1:M
    for j = 1:N
        fft_u(i,j) = fft_f(i,j)/(1+8*lambda*(sin(pi*i/M)^2+sin(pi*j/N)^2));
    end
end

utemp = abs(ifft2(fft_u)); % obtention de l'image restauree
u = utemp((d+1):(M-d), (d+1):(N-d)); % on ote les bords rajoutes precedement

end

