function [ px ] = dxT( p )

px = zeros(size(p));
px(2:end-1,:) = p(2:end-1,:)-p(1:end-2,:);
px(1,:)=p(1,:);
px(end,:) = -p(end-1,:);

end

