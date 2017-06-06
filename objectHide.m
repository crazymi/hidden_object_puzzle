function [output ff] = objectHide(axis, fB, fO, idxB, idxO, B, O)

tmpB = fB;
fB(:,1) = tmpB(:,2);
fB(:,2) = tmpB(:,1);
tmpO = fO;
fO(:,1) = tmpO(:,2);
fO(:,2) = tmpO(:,1);


idx_length = size(axis.O, 1);
Q = axis.B(idxB, :);
xX1 = Q(1);
xY1 = Q(2);
yX1 = Q(3);
yY1 = Q(4);

if idxO > idx_length
    % in O_180
    P = axis.O_180(idxO-idx_length, :);
    xX2 = P(1);
    xY2 = P(2);
    yX2 = P(3);
    yY2 = P(4);
    idxO = idxO - idx_length;
else
    % in O
    P = axis.O(idxO, :);
    xX2 = P(1);
    xY2 = P(2);
    yX2 = P(3);
    yY2 = P(4);
end

% theta in radian
theta = acos(xX1*xX2+xY1*xY2);
c = cos(theta);
s = sin(theta);
H = [c -s 0; s c 0; 0 0 1];
H = H*[1 0 0; 0 1 0 ; 0 0 1];
affH = affine2d(H);

% warped object image
[warpO, ref] = imwarp(O, affH, 'FillValues', 255);
[x1,y1]=transformPointsForward(affH,fO(idxO,2),fO(idxO,1));
x1 = x1 - ref.XWorldLimits(1);
y1 = y1 - ref.YWorldLimits(1);
% wO = [x1 y1];
wO = [y1 x1];

% imshow(O);
% hold on;
% plot(fO(idxO,2), fO(idxO,1), 'r.', 'MarkerSize', 20);
% imshow(warpO);
% hold on;
% plot(wO(2), wO(1), 'r.', 'MarkerSize', 20, 'Color', 'Red');
% hold off;

wB = fB(idxB,:);
diff = double(round(wB-wO));
output = B;
ff = wO+diff;

[m n] = size(warpO);
for i=1:m
    for j=1:n
        cur = warpO(i,j);
        if cur==255
            continue;
        end
        x = i+diff(1);
        y = j+diff(2);
        if x>0 && y>0 && x<size(B,1) && y<size(B,2)
            output(x,y) = cur;
        end
    end
end
end
