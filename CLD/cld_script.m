input_img = 'e4.png';
l = size(input_img,2);
output_img = sprintf('%s_out.png', input_img(1:l-4));

img = imread(input_img);
if ndims(img) == 3
    img = rgb2gray(img);
end
% gradient function needs double input
% img = im2double(img);

% set parameters

% good values for halfw are between 1 and 8,
% halfw denotes size of neighborhood
halfw = 4;
% smoothPasses 1, and 4
% smoothPasses denotes the number of iteration
smoothPasses = 2;
% sigma1 between .01 and 2, sigma2 between .01 and 10,
sigma1 = .4;
sigma2 = 3;
% tau between .8 and 1.0
tau = .99;

etf = ETF(img, halfw, smoothPasses);

result = fDoG(img, etf, sigma1, sigma2, tau);

figure, imshowpair(img, result, 'montage');

imwrite(result, output_img);

