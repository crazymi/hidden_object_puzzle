function [output] = objectHide(axis, fB, fO, idxB, idxO, B, O)

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
% theta = acos((xX1+xY1*xY2/xX2) / (xX2+xY2*xY2/xX2));
c = (xX1+xY1*xY2/xX2) / (xX2+xY2*xY2/xX2);
s = sqrt(1-c*c);
H = [c -s 0; s c 0; 0 0 1];
affH = affine2d(H);
% warped object image
warpO = imwarp(B, affH, 'FillValues', 255);
wO = H*[fO(idxO, :)';1];
wO = wO(1:2)/wO(3);
wB = fB(idxB);
diff = double(round(wB-wO));
[m n] = size(warpO);
rect4 = [1 1; 1 m; n m; n 1];
% rect4B = bsxfun(@plus, rect4, diff');
rect4B = rect4 + diff';

output = B;
for i=rect4B(5):rect4B(6)
    for j=rect4B(1):rect4B(3)
        x = min(max(i-diff(1), 1), size(O,1));
        y = min(max(i-diff(1), 1), size(O,2));
        cur = O(x, y);
        if cur==255
            continue;
        end
        output(i,j) = cur;
    end
end
end