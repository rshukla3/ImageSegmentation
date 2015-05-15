%close all;
clc;
clear all;
image = imread('image_0033.jpg');     % read image

% get image dimensions: an RGB image has three planes
% reshaping puts the RGB layers next to each other generating
% a two dimensional grayscale image
[height, width, planes] = size(image);
rgb = reshape(image, height, width * planes);

figure(1);
imshow(image);                   % visualize RGB planes
%colorbar on                     % display colorbar
hsv1 = rgb2hsv(image);
figure(20);
imshow(hsv1);

h = hsv1(:,:,1);
s = hsv1(:,:,2);
%s(s>1) = 1;
v = hsv1(:,:,3);
image = hsv2rgb(hsv1);
figure(22);
imshow(h);

figure(23);
imshow(s);

figure(24);
imshow(v);

r = image(:, :, 1);             % red channel
g = image(:, :, 2);             % green channel
b = image(:, :, 3);             % blue channel

[~, Thresh] = edge(r, 'prewitt');
r_E = edge(r, 'prewitt', Thresh);

[~, Thresh] = edge(g, 'prewitt');
g_E = edge(g, 'prewitt', Thresh);

[~, Thresh] = edge(b, 'prewitt');
b_E = edge(b, 'prewitt', Thresh);

figure(2);
imshow(r);

figure(3);
imshow(g);

figure(4);
imshow(b);

gray = rgb2gray(image);
%gray = v;
V = v.*255;
%figure(4);
%imshow(gray);
Diff = isequal(gray,V);

L = (gray ~= V);

% gaussian1 = fspecial('Gaussian', 21, 1);
% gaussian2 = fspecial('Gaussian', 21, 3);
% dog = gaussian1 - gaussian2;
% %figure(4);
% %imagesc(dog);
% gray = conv2(double(gray), dog, 'same');


[~, Thresh] = edge(gray, 'prewitt');
gray_E = edge(gray, 'prewitt', Thresh*0.25);
%gray_E= bwareaopen(gray_E, 40);
figure(5);
imshow(gray_E);

r1 = double(r) - (double(g)+double(b))/2;
b1 = double(b) - (double(g)+double(r))/2;
g1 = double(g) - (double(r)+double(b))/2;

y1 = (double(r)+double(g))/2 - abs(double(r)-double(g))/2 -double(b);

r2 = r1-g1;
g2 = g1-r1;
b2 = b1;
y2 = y1-b1;

sigma1 = 1;
sigma2 = 3;


% r2 = dog(r2, sigma1, sigma2, 0);
% g2 = dog(g2, sigma1, sigma2, 0);
% b2 = dog(b2, sigma1, sigma2, 0);
% y2 = dog(y2, sigma1, sigma2, 0);

ThreshMul = 0.25;

[~, Thresh] = edge(r2, 'prewitt');
r2_E = edge(r2, 'prewitt', Thresh*ThreshMul);

[~, Thresh] = edge(g2, 'prewitt');
g2_E = edge(g2, 'prewitt', Thresh*ThreshMul);

[~, Thresh] = edge(y2, 'prewitt');
y2_E = edge(y2, 'prewitt', Thresh*ThreshMul);

[~, Thresh] = edge(y1, 'prewitt');
y1_E = edge(y1, 'prewitt', Thresh*ThreshMul);

[~, Thresh] = edge(b2, 'prewitt');
b2_E = edge(b2, 'prewitt', Thresh*ThreshMul);

figure(6);
imshow(r2_E);

figure(7);
imshow(g2_E);

figure(8);
imshow(y2_E);

figure(9);
imshow(b_E);


ThreshMul2 = 1;
L = (r+g+b)/3;
D = 255-L;
% L = dog(L, sigma1, sigma2, 0);
% D = dog(D, sigma1, sigma2, 0);
[~, Thresh] = edge(L, 'prewitt');
L_E = edge(L, 'prewitt', Thresh*ThreshMul2);

[~, Thresh] = edge(D, 'prewitt');
D_E = edge(D, 'prewitt', Thresh*ThreshMul2);

figure(15);
imshow(L_E);

figure(16);
imshow(D_E);

E1 = max(r2_E, g2_E);

E2 = max(b_E, E1);

E3 = max(D_E, L_E);

E4 = max(E1, E2);

Test_Img_BW = max(E2, E3);

figure(10);
imshow(Test_Img_BW);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Test_Img_BW = bwareaopen(Test_Img_BW, 40);
Test_Img_dilate = imdilate(Test_Img_BW, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
%Test_Img_Fill = bwareaopen(Test_Img_Fill, 400);
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);
figure(11);
imshow(Test_Img_Erode);

BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(height, width));
Test_Img(BWoutline) = 1;
Test_Img = single(Test_Img);

figure(12);
imshow(Test_Img);

se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);

Test_Img_dilate = imdilate(gray_E, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);
figure(13);
imshow(Test_Img_Erode);

BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(height, width));
Test_Img(BWoutline) = 1;
Test_Img = single(Test_Img);

figure(14);
imshow(Test_Img);