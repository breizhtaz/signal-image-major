function [ usigma ] = Convolution_Gaussian( u , sigma)

G = Gaussian(size(u,2),size(u,1),sigma);
usigma = ifft2(fft2(G).*fft2(u));

end

