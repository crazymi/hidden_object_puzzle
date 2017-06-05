% B = imread('test_back2.png');
% O = imread('test_object.png');
% 
% fB = getFeatures(B);
% fO = getFeatures(O);
% 
% 
% [I, idx, axis] = simMap(fO, fB, size(B,1),size(B,2));
% 
% 
% [simH, idx] = simHat(fO, fB, 8, 0.3);
% 
% [dummy, from] = max(simH);
% to = idx(from);
% 
% idxO = to;
% idxB = from;
load('hi');
O = im2double(rgb2gray(O));
B = im2double(rgb2gray(B));

result = objectHide(axis, fB, fO, idxB, idxO, B, O);
% figure, imshowpair(B, result, 'montage');
imshow(result);

%Irgb = cat(3, I, I, I);
%figure; hold on; % Creates a figure
%imshow(Irgb) % Show image
%colormap jet; % Sets the color map you want
%hold off;