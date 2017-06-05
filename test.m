DEBUG = 0

if ~DEBUG
    B = imread('back2.png');
    O = imread('ob2.png');

    fB = getFeatures(B);
    fO = getFeatures(O);


    [I, idx, axis] = simMap(fO, fB, size(B,1),size(B,2));

    [simH, idx] = simHat(fO, fB, 8, 0.3);
    [dummy, from] = max(simH);
    to = idx(from);
    
    fromIdx= find(simH>prctile(simH, 90));
    

    [a,b] = max(I);
    [i,j] = ind2sub(size(I),b);

    % imshow(B), hold on;
    % scatter(i,j,'+');
    % hold off;

    O = rgb2gray(O);
    B = rgb2gray(B);

    idxO = to;
    idxB = from;
else
    load('test')
end
O = rgb2gray(O);
B = rgb2gray(B);
O(O>180)=255;
for i=1:size(fromIdx)
    result = objectHide(axis, fB, fO, idxB, idxO, B, O);
    % imshowpair(B, result, 'montage');
    imshow(result);
    imwrite(result, sprintf('result_%d.png', i));
end

%Irgb = cat(3, I, I, I);
%figure; hold on; % Creates a figure
%imshow(Irgb) % Show image
%colormap jet; % Sets the color map you want
%hold off;