function [from, to] = simMap(featureO,featureB,height,width)

[simH, idx] = simHat(featureO, featureB, 8, 0.3);

[dummy, from] = max(simH);
to = idx(from);

end