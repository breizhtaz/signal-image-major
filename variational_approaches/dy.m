function [ uy ] = dy( u )

uy = zeros(size(u));
uy(:,1:end-1) = u(:,2:end)-u(:,1:end-1);


end

