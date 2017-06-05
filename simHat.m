function [simH, idx] = simHat(featureO, featureB, T, w)
% real similarity of feature point Bj and Object

% in
% featureO : Object feature list : Nx2, XY cordi
% featureB : Background feature list : Mx2, XY cordi
% T : usually 8
% w : usually 0.3
% F : from calF

% ret
% simH : sim hat, real similarity of feature point Bj and Object


% assume N << M
N = size(featureO,1);
M = size(featureB,1);
[O, radiO] = shapeContext(featureO,N,1);
[O_180, radiO_180] = shapeContext(featureO,N,-1);
[B, radiB] = shapeContext(featureB,2*N,1);

[sim, idx] = localSim(O, B, O_180);

scatter3(featureB(:,1)',featureB(:,2)' ,sim');


% calculate simHat
simH = zeros(M,1);
for j = 1:M
  neighbor_idxB = knnsearch(featureB, featureB(j,:),'dist','euclidean', 'k',T);
  Bjt = B(neighbor_idxB,:);
  if idx(j) <= N %pca +
    neighbor_idxO = knnsearch(featureO, featureO(idx(j),:),'dist','euclidean', 'k',T);
    Ojt = O(neighbor_idxO,:);
    F = min(radiB(j,2),radiO(idx(j),2))/max(radiB(j,1), radiO(idx(j),1));
  else %pca -
    neighbor_idxO = knnsearch(featureO, featureO(idx(j)-N,:),'dist','euclidean', 'k',T);
    Ojt = O_180(neighbor_idxO,:);
    F = min(radiB(j,2),radiO_180(idx(j)-N,2))/max(radiB(j,1), radiO_180(idx(j)-N,1));
  end
  D = sum(min(Bjt, Ojt),2)./sum(Ojt,2);
  %D = dot(normr(Bjt), normr(Ojt),2);
  simH(j) = sim(j)*sum(D)/T + w*F;
end

end