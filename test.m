B = imread('back2.png');
O = imread('ob2.png');

fB = getFeatures(B);
fO = getFeatures(O);


[I, idx, axis] = simMap(fO, fB, size(B,1),size(B,2));

[simH, idx] = simHat(fO, fB, 8, 0.3);
[dummy, from] = max(simH);
to = idx(from);

[a,b] = max(I);
[i,j] = ind2sub(size(I),b);

imshow(B), hold on;
scatter(i,j,'+');
hold off;

idxO = to;
idxB = from;
result = objectHide(axis, fB, fO, idxB, idxO, B, O);
figure, imshow(result);

%Irgb = cat(3, I, I, I);
%figure; hold on; % Creates a figure
%imshow(Irgb) % Show image
%colormap jet; % Sets the color map you want
%hold off;