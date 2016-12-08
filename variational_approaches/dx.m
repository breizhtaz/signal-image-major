function [ ux ] = dx( u )

ux = zeros(size(u));
ux(1:end-1,:) = u(2:end,:)-u(1:end-1,:);


end

