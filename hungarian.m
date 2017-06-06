function [ matched, cost ] = hungarian( mat )
% input arguments
% mat: N by M cost matrix
%
% output arguments
% matched: vector of M variables,
%          i-th element represents matched column for row i
% cost: total cost matching

inf_ = int32(1e9);

mat = [zeros(size(mat,1),1),mat];
mat = [zeros(1,size(mat,2));mat];
mat = int32(mat);

n = size(mat,1);
m = size(mat,2);

u = int32(zeros(n,1));
v = int32(zeros(m,1));
p = int32(ones(m,1));
way = int32(ones(m,1));

for i = 2:n
    p(1) = i;
    j0 = 1;
    minv = int32(ones(m,1)) * inf_;
    used = false(m,1);
    while true
        used(j0) = true;
        i0 = p(j0);
        j1 = 1;
        delta = inf_;
        for j = 2:m
            if used(j)
                continue;
            end
            cur = mat(i0,j) - u(i0) - v(j);
            if cur < minv(j)
                minv(j) = cur;
                way(j) = j0;
            end
            if minv(j) < delta
                delta = minv(j);
                j1 = j;
            end
        end
        for j = 1:m
            if used(j)
                u(p(j)) = u(p(j)) + delta;
                v(j) = v(j) - delta;
            else
                minv(j) = minv(j) - delta;
            end
        end
        j0 = j1;
        if p(j0) == 1
            break;
        end
    end
    while true
        j1 = way(j0);
        p(j0) = p(j1);
        j0 = j1;
        if j0 == 1
            break;
        end
    end
end

matched = zeros(m-1,1);
for j = 2:m
    matched(int32(p(j)-1)) = j - 1;
end
cost = -v(1);
end