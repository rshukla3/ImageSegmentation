image = imread('jump.jpg');     % read image

% get image dimensions: an RGB image has three planes
% reshaping puts the RGB layers next to each other generating
% a two dimensional grayscale image
[height, width, planes] = size(image);
rgb = reshape(image, height, width * planes);

imagesc(rgb);                   % visualize RGB planes
colorbar on                     % display colorbar

r = image(:, :, 1);             % red channel
g = image(:, :, 2);             % green channel
b = image(:, :, 3);             % blue channel