function [ list ] = getFeatures( img, count )
% input arguments
% img : NxM greyscale image
% count [optional] : maximum number of features

% output arguments
% list : kx2 list of features.
% each row represent x, y coordinate of feature

threshold = 0.01;

if size(img,3) == 3
    img = rgb2gray(img);
end

pts = detectHarrisFeatures(img,'MinQuality',threshold);
if nargin > 1
    list = pts.selectStrongest(count).Location;
else
    list = pts.Location;
end

end

