clc;
clear all;

rgb = imread('35_l4c3.png');
I = rgb2gray(rgb);
%I = rgb(:,:,3);
% h = rgb2hsv(rgb);
% I = h(:,:,3);

%gaussian1 = fspecial('Gaussian', 100, 1);
% gaussian2 = fspecial('Gaussian', 100, 3);
%dog = gaussian1;
% %figure(4);
% %imagesc(dog);
%I = conv2(double(I), dog, 'same');

figure(110);
imshow(I);

[Sm, Sn] = size(I);

O1 = [1 0 -1; 2 0 -2; 1 0 -1];
O2 = [1 2 1; 0 0 0; -1 -2 -1];
O3 = [2 1 0; 1 0 -1; 0 -1 -2];
O4 = [0 1 2; -1 0 1; -2 -1 0];

O5 = -01;
O6 = -O2;
O7 = -O3;
O8 = -O4;

I_O1 = imfilter(double(I), O1, 'replicate');
I_O2 = imfilter(double(I), O2, 'replicate');
I_O3 = imfilter(double(I), O3, 'replicate');
I_O4 = imfilter(double(I), O4, 'replicate');

I_O5 = imfilter(double(I), O5, 'replicate');
I_O6 = imfilter(double(I), O6, 'replicate');
I_O7 = imfilter(double(I), O7, 'replicate');
I_O8 = imfilter(double(I), O8, 'replicate');
gradmag = sqrt(I_O1.^2 + I_O2.^2 + I_O3.^2 + I_O4.^2 + I_O5.^2 + I_O6.^2 + I_O7.^2 + I_O8.^2);
figure(1);
imshow(I_O1, []);

figure(2);
imshow(I_O2, []);

figure(3);
imshow(I_O3, []);

figure(4);
imshow(I_O4, []);

I_max_1 = max(max(max(I_O1, I_O2), I_O3), I_O4);

I_max_2 = max(max(max(I_O5, I_O6), I_O7), I_O8);

I_max = max(I_max_1, I_max_2);

%I_max = max(I_O1, I_O2);

figure(5);
imshow(I_max, []);

figure(6);
imshow(gradmag, []);

I_gray = mat2gray(I_max, [1 255]);
level= graythresh(I_gray);
BW_1 = im2bw(I_gray, level*0.75);
BW_1 = bwareaopen(BW_1, 40);
se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);
Test_Img_dilate = imdilate(BW_1, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
BW = imerode(Test_Img_Final,seD);
BWoutline = edge(BW_1);
BW = logical(zeros(Sm, Sn));
BW(BWoutline) = 1;
%[~,Thresh] = edge(I_gray, 'prewitt');
%BW = edge(I_gray, 'prewitt', Thresh*0.5);
figure(7);
imshow(BW_1);



se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);
%Test_Img_BW = bwareaopen(gradmag, 100);
Test_Img_dilate = imdilate(gradmag, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
%Test_Img_Fill = bwareaopen(Test_Img_Fill, 400);
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);
BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(Sm, Sn));
Test_Img(BWoutline) = 1;
Test_Img = single(Test_Img);

figure(8);
imshow(Test_Img);

