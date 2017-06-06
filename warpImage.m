function [Iwarp] = warpImage(Iin, H)
[m n] = size(rgb2gray(Iref));

p0 = (H*[0 0 1]')';
p0=p0/p0(3);
p1 = (H*[m 0 1]')';
p1=p1/p1(3);
p2 = (H*[0 n 1]')';
p2=p2/p2(3);
p3 = (H*[m n 1]')';
p3=p3/p3(3);

xLim = ceil(max([p0(1) p1(1) p2(1) p3(1)]));
yLim = ceil(max([p0(2) p1(2) p2(2) p3(2)]));
% Iwrap = zeros(yLim, xLim);

[X, Y] = meshgrid(n,m);

Xq = [];
Yq = [];
for i=1:yLim
    for j=1:xLim
        p = H\[i j 1]';
        p=p/p(3);
        % out of original image range
        if(p(1)<0 || p(1)>n || p(2)<0 || p(2)>m)
            continue;
        end
        Xq = [Xq p(1)];
        Yq = [Yq p(2)];
    end
end

Iwarp = interp2(X, Y, Iin, Xq, Yq);

end

