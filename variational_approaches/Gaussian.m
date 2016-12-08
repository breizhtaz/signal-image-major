function [ G ] = Gaussian( X, Y, sigma )

[X,Y]=meshgrid(-floor(X/2):floor(X/2)-1,-floor(Y/2):floor(Y/2)-1);

G=exp(-(X.^2+Y.^2)/(2*sigma^2));
G=G/sum(G(:));
G=fftshift(G);

end

