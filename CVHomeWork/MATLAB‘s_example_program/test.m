% READ IMAGE, GET SIZE INFORMATION
input_A = '../Test2_1.jpg';
input_B = '../Test2_2.jpg';

image_A = imread(input_A);
image_B = imread(input_B);
[height_wrap, width_wrap,~] = size(image_A);
[height_unwrap, width_unwrap,~] = size(image_B);

% CONVERT TO GRAY SCALE
gray_A = im2double(rgb2gray(image_A));
gray_B = im2double(rgb2gray(image_B));


% FIND HARRIS CORNERS IN BOTH IMAGE
[x_A, y_A, v_A] = harris(gray_A, 2, 0.0, 2);
[x_B, y_B, v_B] = harris(gray_B, 2, 0.0, 2);

% ADAPTIVE NON-MAXIMAL SUPPRESSION (ANMS)
ncorners = 500;
[x_A, y_A, ~] = ada_nonmax_suppression(x_A, y_A, v_A, ncorners);
[x_B, y_B, ~] = ada_nonmax_suppression(x_B, y_B, v_B, ncorners);

% EXTRACT FEATURE DESCRIPTORS
sigma = 7;
[des_A] = getFeatureDescriptor(gray_A, x_A, y_A, sigma);
[des_B] = getFeatureDescriptor(gray_B, x_B, y_B, sigma);

% IMPLEMENT FEATURE MATCHING
dist = dist2(des_A,des_B);
[ord_dist, index] = sort(dist, 2);
% THE RATIO OF FIRST AND SECOND DISTANCE IS A BETTER CRETIA THAN DIRECTLY
% USING THE DISTANCE. RATIO LESS THAN .5 GIVES AN ACCEPTABLE ERROR RATE.
ratio = ord_dist(:,1)./ord_dist(:,2);
threshold = 0.5;
idx = ratio<threshold;

x_A = x_A(idx);
y_A = y_A(idx);
x_B = x_B(index(idx,1));
y_B = y_B(index(idx,1));
npoints = length(x_A);

% USE 4-POINT RANSAC TO COMPUTE A ROBUST HOMOGRAPHY ESTIMATE
% KEEP THE FIRST IMAGE UNWARPED, WARP THE SECOND TO THE FIRST
matcher_A = [y_A, x_A, ones(npoints,1)]'; %!!! previous x is y and y is x,
matcher_B = [y_B, x_B, ones(npoints,1)]'; %!!! so switch x and y here.
[hh, ~] = ransacfithomography(matcher_B, matcher_A, npoints, 10);

% s = load('matcher.mat');
% matcher_A = s.matcher(1:3,:);
% matcher_B = s.matcher(4:6,:);
% npoints = 60;
% [hh, inliers] = ransacfithomography(matcher_B, matcher_A, npoints, 10);


% USE INVERSE WARP METHOD
% DETERMINE THE SIZE OF THE WHOLE IMAGE
[newH, newW, newX, newY, xB, yB] = getNewSize(hh, height_wrap, width_wrap, height_unwrap, width_unwrap);

[X,Y] = meshgrid(1:width_wrap,1:height_wrap);
[XX,YY] = meshgrid(newX:newX+newW-1, newY:newY+newH-1);
AA = ones(3,newH*newW);
AA(1,:) = reshape(XX,1,newH*newW);
AA(2,:) = reshape(YY,1,newH*newW);

AA = hh*AA;
XX = reshape(AA(1,:)./AA(3,:), newH, newW);
YY = reshape(AA(2,:)./AA(3,:), newH, newW);

% INTERPOLATION, WARP IMAGE A INTO NEW IMAGE
newImage(:,:,1) = interp2(X, Y, double(image_A(:,:,1)), XX, YY);
newImage(:,:,2) = interp2(X, Y, double(image_A(:,:,2)), XX, YY);
newImage(:,:,3) = interp2(X, Y, double(image_A(:,:,3)), XX, YY);

% BLEND IMAGE BY CROSS DISSOLVE
[newImage] = blend(newImage, image_B, xB, yB);

% DISPLAY IMAGE MOSIAC
imshow(uint8(newImage));

