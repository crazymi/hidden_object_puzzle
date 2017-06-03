function [shape, radius] = shapeContext(input, N, sign)
% get feature list, grouping N neighbor,
% return shape context histogram for each group.
% maybe use PCA

% input : kx2
%         k point with XY cordi
% N : number of neightbor to calculate shape context
% sign : PCA direction,
%        if 1 : same direction, -1 : opposite direciton.


% ret
% shape : k x 32 shape context histogram. 
% radius : k x 2 : max radi, min radi for each histogram.

K = size(input,1);

if N > K
    N = K;
end

shape = zeros(K,32);
radius = zeros(K,2);

for k = 1 : K
    % find N neighbors and their position relative to k
    dist_sq = (input(:,1)-input(k,1)).^2 + (input(:,2)-input(k,2)).^2;
    [dsq,idx] = sort(dist_sq);
    rpts = zeros(N,2);
    for i = 1 : N
        rpts(i,1) = input(idx(i),1) - input(k,1);
        rpts(i,2) = input(idx(i),2) - input(k,2);
    end
    radius(k,1) = sqrt(dsq(N));
    radius(k,2) = sqrt(dsq(2));
    r = 0;
    coeff = pca(rpts) * sign;
    % change coordinate system
    % assume each column of coeff has magnitude 1
    pts = rpts/coeff;
    for i = 1:N
        tmp = sqrt(sum(pts(i,:).^2));
        if tmp > r
            r = tmp;
        end
    end
    r = r / 4 + 1e-9;
    % first one is k itself, so don't count it
    for i = 2:N
        d = sqrt(sum(pts(i,:).^2));
        a = 8 * int32(floor(d/r));
        x = pts(i,1);
        y = pts(i,2);
        if x>=0 && y>=0
            if x>y
                shape(k,a+1) = shape(k,a+1) + 1;
            else
                shape(k,a+2) = shape(k,a+2) + 1;
            end
        elseif x<0 && y>=0
            if y>-x
                shape(k,a+3) = shape(k,a+3) + 1;
            else
                shape(k,a+4) = shape(k,a+4) + 1;
            end
        elseif x<0 && y<0
            if -x>-y
                shape(k,a+5) = shape(k,a+5) + 1;
            else
                shape(k,a+6) = shape(k,a+6) + 1;
            end
        elseif x>=0 && y<0
            if -y>x
                shape(k,a+7) = shape(k,a+7) + 1;
            else
                shape(k,a+8) = shape(k,a+8) + 1;
            end
        end
    end
end

end

