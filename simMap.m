function [simImg, idx, axis] = simMap(featureO,featureB,height,width)

[simH, idx, axis] = simHat(featureO, featureB, 8, 0.3);
simImg = 0;
[dummy, from] = max(simH);
to = idx(from);

end