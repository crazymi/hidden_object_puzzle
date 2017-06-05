function [output] = objectHide(axis, fB, fO, idxB, idxO, B, O)

idx_length = size(axis.O, 1);
[xX1 xY1 yX1 yY1] = axis.B(idxB);
if idxO > idx_length
    % in O_180
    [xX2 xY2 yX2 yY2] = axis.O_180(idxO-idx_length);
else
    % in O
    [xX2 xY2 yX2 yY2] = axis.O(idxO);
end

% theta in radian
% theta = acos((xX1+xY1*xY2/xX2) / (xX2+xY2*xY2/xX2));
c = (xX1+xY1*xY2/xX2) / (xX2+xY2*xY2/xX2);
s = sqrt(1-c*c);
H = [c -s 0; s c 0; 0 0 1];
H = affine2d(H);
% warped object image
warpO = imwarp(img, H, 'FillValues', 255);
wO = fO(idxO)*H;
wB = fB(idxB);
diff = wB-wO;
[m n] = size(warpO);
rect4 = [0 0; 0 m; n m; n 0];
rect4B = bsxfun(@plus, rect4(:,2), diff);

output = B;
for i=rect4B(5):rect4B(6)
    for j=rect4B(1):rect4B(3)
        cur = O(i-diff(1), j-diff(2));
        if cur==255
            continue;
        end
        B(i,j) = cur;
    end
end
end