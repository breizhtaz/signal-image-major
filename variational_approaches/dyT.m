function [ py ] = dyT( p )

py = zeros(size(p));
py(:,2:end-1) = p(:,2:end-1)-p(:,1:end-2);
py(:,1)=p(:,1);
py(:,end) = -p(:,end-1);

end

