function [shape, radius, axis] = shapeContext(input, N, sign)
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
% axis : k x 4 2-by-2 matrix holding axis information

K = size(input,1);

if N > K
    N = K;
end

shape = zeros(K,32);
radius = zeros(K,2);

[idx,dists] = knnsearch(input,input,'K',K);
axis = zeros(K,4);
for k = 1 : K
    ld = log(dists(k,1:N));
    % find N neighbors and their position relative to k
    rpts = zeros(N,2);
    for i = 1 : N
        rpts(i,1) = input(idx(k,i),1) - input(k,1);
        rpts(i,2) = input(idx(k,i),2) - input(k,2);
    end
    radius(k,1) = dists(k,N);
    radius(k,2) = dists(k,2);
    coeff = pca(rpts) * sign;
    axis(k,:) = coeff(:)';
    % change coordinate system
    % assume each column of coeff has magnitude 1
    pts = rpts/coeff;
    r = ld(N) / 4 + 1e-9;
    % first one is k itself, so don't count it
        
        % khg change
    %    a = 0;
    %    s = d/r;
    %    for p = 1:4
    %      if s >= 1
    %        a = a + 1;
    %        s = s/2;
%           else
%             break;
%           end
%         end
%        a = a * 8;
        %%% end
    
    for i = 2:N
        d = ld(i);
        a = 8 * int32(floor(d/r));
                
        if a < 0
            a = 0;
        elseif a > 24
            a = 24;
        end
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

