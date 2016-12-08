function [ l ] = laplacien( Im )
%LAPLACIEN 
[gradx, grady] = gradient(Im);

l = divergence(gradx, grady);

end

