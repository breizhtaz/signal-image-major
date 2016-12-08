function [ gradx grady ] = gradient( Im )
%GRADIENT calcule le gradient (discret) d'une image

gradx = dx(Im);
grady = dy(Im);

end

