DEBUG = 0

B = imread('back1.png');
O = imread('ob1.png');

fB = getFeatures(B);
fO = getFeatures(O);

if ndims(O) == 3
    O = rgb2gray(O);
end
if ndims(B) == 3
    B = rgb2gray(B);
end

tic;
if DEBUG == 0 % original simmap
    [I, idx, axis] = simMap(fO, fB, size(B,1),size(B,2));
    [simH, idx] = simHat(fO, fB, 8, 0.3);
    newSim = [simH [1:size(simH,1)]'];
    newSim = sortrows(newSim, 1);
    scatter3(fB(:,1)',fB(:,2)' ,simH');
%     [dummy fromIdx] = min(simH);
%     fromIdx = find(simH>prctile(simH, 90));

    save('test');
elseif DEBUG == -1
    [idx cost] = mapping(fO, fB);
    fromIdx = idx;
else
    load('test');
end
fprintf('Similarity computation took %f seconds.\n', toc);

O(O>180)=255;

for i=1:10
    idxB = newSim(i, 2);
    idxO = idx(idxB);
    
    [result ff] = objectHide(axis, fB, fO, idxB, idxO, B, O);
    
    imshow(result);
    hold on;
    bb = fB(idxB,:);
    plot(bb(1), bb(2), 'r.', 'MarkerSize', 20, 'Color', 'Magenta');
    plot(ff(2), ff(1), 'r.', 'MarkerSize', 10, 'Color', 'Cyan');
    hold off;
    saveas(gcf, sprintf('results/%d.png', i));
%     imwrite(result, sprintf('results/%d.png', i));
end