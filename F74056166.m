clear;
X = imread('airplane.jpg');
%image(X)
imagesize = size(X);


%~~~~~~~~~~~~~~~~rgb to grayscale
for i = 1:imagesize(1)
    for j = 1:imagesize(2)
        grayscale(i, j) = round(X(i, j, 1)*0.299 + X (i, j, 2)*0.587 + X (i, j, 3)*0.114);
    end
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Histogram equalization 
for i = 1:256
    pdf(i) = 0;
    cdf(i) = 0;
    pdf_after(i) = 0;
end

for i = 1:imagesize(1)
    for j = 1:imagesize(2)
        pdf(grayscale(i, j)+1) = pdf(grayscale(i, j)+1) + 1;
    end
end

cdf(1) = pdf(1);
for i = 2:256
    cdf(i) = pdf(i) + cdf(i-1);
end

cdfmin = min(cdf(:));
for i = 1:256
    h(i) = round((cdf(i)-cdfmin)/((imagesize(1)*imagesize(2)) - cdfmin) * 255);
end

for i = 1:imagesize(1)
    for j = 1:imagesize(2)
        equalization(i, j) = uint8(h(grayscale(i,j)+1));
    end
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



imshow(equalization(:,:));
% subplot(2,1,1);
% imhist(grayscale);
% subplot(2,1,2);
% imhist(equalization);
%functiongray = rgb2gray(X);


