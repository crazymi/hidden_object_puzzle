function etf = etf_init(img)
[m n] = size(img);
img = double(img);
etf = zeros(m,n,3);

MAX_VAL = 1020.;

for i=2:m-1
    for j=2:n-1
        etf(i,j,1) = (img(i+1,j-1)+2*img(i+1,j)+img(i+1,j+1) ...
                        -img(i-1,j-1)-2*img(i-1,j)-img(i-1,j+1))/MAX_VAL;
        etf(i,j,2) = (img(i-1,j+1)+2*img(i,j+1)+img(i+1,j+1) ...
                        -img(i-1,j-1)-2*img(i,j-1)-img(i+1,j-1))/MAX_VAL;
        etf(i,j,3) = sqrt(etf(i,j,1)*etf(i,j,1)+etf(i,j,2)*etf(i,j,2));
    end
end
tmp = etf(:,:,1);
etf(:,:,1) = -etf(:,:,2);
etf(:,:,2) = tmp;
max_grad = max(reshape(etf(:,:,3), [1 m*n]));

etf((2:m-2), 1, :) = etf((2:m-2), 2, :);
etf((2:m-2), n, :) = etf((2:m-2), n-1, :);
etf(1, (2:n-2), :) = etf(2, (2:n-2), :);
etf(m, (2:n-2), :) = etf(m-1, (2:n-2), :);

etf(1,1,:) = (etf(1,2,:)+etf(2,1,:))/2;
etf(1,n,:) = (etf(1,n-1,:)+etf(2,n,:))/2;
etf(m,1,:) = (etf(m,2,:)+etf(m-1,1,:))/2;
etf(m,n,:) = (etf(m,n-1,:)+etf(m-1,n,:))/2;

etf(:,:,1) = etf(:,:,1)./etf(:,:,3);
etf(:,:,2) = etf(:,:,2)./etf(:,:,3);
etf(:,:,3) = etf(:,:,3)/max_grad;

etf(isnan(etf)) = 0;

end