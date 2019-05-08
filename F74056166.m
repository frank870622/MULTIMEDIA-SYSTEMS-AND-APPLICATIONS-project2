clear;
for picturenum = 1:2
    if picturenum == 1
        X = imread('airplane.jpg');
    end
    if picturenum == 2
        X = imread('spider.png');
    end
    imagesize = size(X);
    
    %~~~~~~~~~~~~~~~~rgb to grayscale
    for i = 1:imagesize(1)
        for j = 1:imagesize(2)
            grayscale(i, j) = round(X(i, j, 1)*0.299 + X (i, j, 2)*0.587 + X (i, j, 3)*0.114);
        end
    end
    %grayscale = rgb2gray(X);
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Gaussian Blur
    %copy array
    for i = 1:imagesize(1)
        for j = 1:imagesize(2)
            Gaussian(i, j) = grayscale(i, j);
        end
    end
    %get gaussian array
    a = 0.84089642;         %Standard Deviation
    k = 3;                  %gaussian array size-1 /2
    k_row = 2*k + 1;        %gaussian array size
    for i=1:7
        for j = 1:7
            g(i, j) = exp(-((i-k-1)^2+(j-k-1)^2)/(2*a*a))/(2*pi*a*a);
        end
    end
    % gaussian filter
    for i = k+1:imagesize(1)-k-1
        for j = k+1:imagesize(2)-k-1
            temp = 0;
            for n = 1:k_row
                for m = 1:k_row
                    temp= temp+(Gaussian(i+n-k,j+m-k)*g(n,m));
                end
            end
            grayscale(i,j) = temp;
        end
    end
    
    %mak=fspecial('gaussian');
    %grayscale=imfilter(Gaussian,mak);
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Histogram equalization
    for i = 1:256
        pdf(i) = 0;             %probability density function
        cdf(i) = 0;             %Cumulative Distribution Function
    end
    %set probability density function
    for i = 1:imagesize(1)
        for j = 1:imagesize(2)
            pdf(grayscale(i, j)+1) = pdf(grayscale(i, j)+1) + 1;
        end
    end
    %set Cumulative Distribution Function
    cdf(1) = pdf(1);
    for i = 2:256
        cdf(i) = pdf(i) + cdf(i-1);
    end
    
    %Histogram equalization calculation
    cdfmin = min(cdf(:));
    for i = 1:256
        h(i) = round((cdf(i)-cdfmin)/((imagesize(1)*imagesize(2)) - cdfmin) * 255);
    end
    %set new array after Histogram equalization
    for i = 1:imagesize(1)
        for j = 1:imagesize(2)
            equalization(i, j) = uint8(h(grayscale(i,j)+1));
        end
    end
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Sobel operator
    equalization = double(equalization);
    Gx = [-1 0 1; -2 0 2; -1 0 1];
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];
    % Gx = [3 0 -3; 10 0 -10; 3 0 -3];
    % Gy = [3 10 3; 0 0 0; -3 -10 -3];
    for i = 1:imagesize(1)-2
        for j = 1:imagesize(2)-2
            mag(i,j) = 0;
        end
    end
    
    for i = 1:imagesize(1)-2
        for j = 1:imagesize(2)-2
            S1=sum(sum(Gx.*equalization(i:i+2,j:j+2)));
            S2=sum(sum(Gy.*equalization(i:i+2,j:j+2)));
            mag(i+1,j+1) = sqrt(S1.^2+S2.^2);
            
        end
    end
    %change array to uint8
    mag = uint8(mag);
    subplot(2,1,picturenum);
    imshow(mag(:,:));
    clear x;
    clear grauscale;
    clear equalization;
    clear mag;
end
