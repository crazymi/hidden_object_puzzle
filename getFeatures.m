function [ list ] = getFeatures( img, count )
% input arguments
% img : NxM greyscale image
% count [optional] : maximum number of features

% output arguments
% list : kx2 list of features.
% each row represent x, y coordinate of feature

threshold = 0.1;
suppress = 0;

if size(img,3) == 3
    img = rgb2gray(img);
end

pts = detectHarrisFeatures(img,'MinQuality',threshold);
n = length(pts);
m = n;
lst = pts.selectStrongest(n).Location;

for i = n:-1:1
    for j = i-1:-1:1
        d = sum((lst(i,:)-lst(j,:)).^2);
        if d < suppress
            lst(i,1) = -1;
            m = m - 1;
            break;
        end
    end
end

list = zeros(m,2);
j = 1;
for i = 1:n
    if lst(i,1) < 0
        continue;
    end
    list(j,:) = lst(i,:);
    j = j + 1;
end

if nargin > 2
    count = min(count, size(list,1));
    list = list(1:count,:);
end

end
