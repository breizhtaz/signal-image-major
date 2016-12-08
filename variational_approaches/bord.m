function [ B ] = bord( A, d )
% Gweltaz Lever, ISAE Supaero, All rights reserved.
% BORD extension de l'image A par reflexion pour d pixels

[m,n]=size(A);
% On cree la matrice B de la bonne taille
M=m+2*d;
N=n+2*d;
B=zeros(M,N);
B(d+1:M-d,d+1:N-d)=A;
%On complete par reflexion
for i=1:m
    for j=1:d
        B(i+d,j)=A(i,d-j+1);
    end;
    for j=N-d+1:N
        B(i+d,j)=A(i,n+N-j-d);
    end;
end;
for j=1:N
    for i=1:d
        B(i,j)=B(2*d-i+1,j);
    end;
    for i=M-d+1:M
        B(i,j)=B(2*M-i-2*d,j);
    end;
end;


end

