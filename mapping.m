function [ index, cost ] = mapping( fO, fB )

% input arguments
% fO: Nx2 matrix of x,y coordinate of features in Object
% fB: Mx2 matrix of x,y coordinate of features in Background
%
% output arguments
% index: Nx1 array of indexes of matching points in fB
%
% time complexity: O(max(N,M)^2*min(N,M))

N = size(fO,1);
M = size(fB,1);

mat = zeros(M,N);
for i = 1:M
    for j = 1:N
        mat(i,j) = sum((fO(j,:)-fB(i,:)).^2);
    end
end
[index, cost] = hungarian(mat);

end
