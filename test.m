B = imread('test_back2.png');
O = imread('test_object.png');

fB = getFeatures(B);
fO = getFeatures(O);


[I, idx] = simMap(fO, fB, size(B,1),size(B,2));
[a,b] = max(I);
[i,j] = ind2sub(size(I),b);

imshow(B), hold on;
scatter(i,j,'+');
hold off;
%Irgb = cat(3, I, I, I);
%figure; hold on; % Creates a figure
%imshow(Irgb) % Show image
%colormap jet; % Sets the color map you want
%hold off;