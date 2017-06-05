function [simImg, idx] = simMap(featureO,featureB,height,width)

[simH, idx] = simHat(featureO, featureB, 8, 0.3);

i = simH' > 0.9*(max(simH)-min(simH))+min(simH);
ht = simH(i);
bt = featureB(i,:);
hold on
scatter3(bt(:,1)',bt(:,2)' ,ht');
st = tpaps(bt', ht', 0.5);

fnplt(st),
hold off
[X,Y] = meshgrid(1:width, 1:height);
simImg = reshape(fnval(st, [X(:), Y(:)]'), height, width);
end