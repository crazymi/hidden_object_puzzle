function [sim, idx] = localSim(O, B, O_180)
%calculate local similarity

% in
% O : Nx32 : Object histogram vector, +PCA
% B : Mx32 : Background histogram vector, +PCA
% O_180 : Nx32 : Object histogram vector, -PCA
% B_180 : Mx32 : Background histogram vector, -PCA (don't need)

% ret
% sim : Mx1 : sim vec
% idx : Mx1 : idx vec (max Obj index)

N = size(O,1);
M = size(B,1);

sim = zeros(M,1);
idx = zeros(M,1);

for j = 1:M
  Bs = repmat(B(j,:),N,1);
  D1 = dot(normr(Bs), normr(O),2);
  D2 = dot(normr(Bs), normr(O_180),2);
  [sim(j),idx(j)] = max([D1; D2]);
end

end