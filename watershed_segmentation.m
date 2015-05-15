rgb = imread('image_0033.jpg');
%I = rgb2gray(rgb);
I = rgb(:,:,3);
imshow(I);

[Sm,Sn] = size(I);

se = strel('disk', 20);
Io = imopen(I, se);
figure(1);
imshow(Io), title('Opening (Io)');

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure(2);
imshow(Iobr), title('Opening-by-reconstruction (Iobr)');

Ioc = imclose(Io, se);
figure(3);
imshow(Ioc), title('Opening-closing (Ioc)');

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure(4);
imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)');

fgm = imregionalmax(Iobrcbr);
figure(5);
imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)');

I2 = I;
I2(fgm) = 255;
figure(6);
imshow(I2), title('Regional maxima superimposed on original image (I2)');

se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
figure(7)
imshow(I3);
title('Modified regional maxima superimposed on original image (fgm4)');

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
figure(8);
imshow(bw), title('Thresholded opening-closing by reconstruction (bw)');

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure(9);
imshow(bgm), title('Watershed ridge lines (bgm)');

hy = fspecial('sobel');
hx = hy'
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

figure(10);
imshow(gradmag,[]), title('Gradient magnitude (gradmag)');



[~, Thresh] = edge(gradmag, 'prewitt');
gradmag = edge(gradmag, 'sobel', Thresh*0.3);
% figure(13);
% imshow(gradmag);
% 
se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);
Test_Img_BW = bwareaopen(gradmag, 100);
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

figure(14);
imshow(Test_Img);

% L = watershed(gradmag);
% Lrgb = label2rgb(L);
% figure(11), imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)');
% 
% 
% gradmag2 = imimposemin(gradmag, bgm | fgm4);
% L = watershed(gradmag2);
% I4 = zeros(Sm, Sn);
% I4(imdilate(L == 0, ones(3, 3))) = 255;
% figure(12);
% imshow(I4);
% title('Markers and object boundaries superimposed on original image (I4)');
% 
