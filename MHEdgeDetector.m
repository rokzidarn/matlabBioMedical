function MHEdgeDetector(imageName)
    % Marr-Hildreth Edge Detector

    imageName = strcat(imageName,'.png');
    imageRaw = im2double(imread(imageName)); % read image/file of CT
    figure; imshow(imageRaw); % show raw image, before processing

    % STEP 1: calculate size of kernel, gauss coefficients, filter image
    sigma = min(size(imageRaw))*0.005; % sigma=0.5% of min. image size dimension in pixels
    gaussKernel = calcGauss(sigma);
    %disp(sigma); disp(size(gaussKernel)); % sigma value and size of gauss kernal for image filtering (smoothing)

    imageFiltered = conv2(imageRaw, gaussKernel, 'same');
    %figure; imshow(imageFiltered);

    % STEP 2: calculate Laplacian of filtered image to enhance edges
    laplaceKernel = [0 1 0; 1 -4 1; 0 1 0];
    imageLaplace = conv2(imageFiltered, laplaceKernel, 'same');
    %figure; imshow(imageLaplace, [min(imageLaplace(:)), max(imageLaplace(:))]);

    % thresholding
    % imageThreshold = im2bw(imageLaplace, 0);
    %figure; imshow(imageThreshold);

    % STEP 3: zero-crossings
    imageData = imageLaplace;
    [n,m] = size(imageData);
    newImageData = zeros([n,m]);

    for i = 2:n-1
        for j = 2:m-1
            if(imageData(i,j)>0)
                if((imageData(i,j+1)>=0 && imageData(i,j-1)<0) || (imageData(i,j+1)<0 && imageData(i,j-1)>=0))
                    newImageData(i,j) = imageData(i,j);
                elseif((imageData(i+1,j)>=0 && imageData(i-1,j)<0) || (imageData(i+1,j)<0 && imageData(i-1,j)>=0))
                    newImageData(i,j) = imageData(i,j);
                elseif((imageData(i+1,j+1)>=0 && imageData(i-1,j-1)<0) || (imageData(i+1,j+1)<0 && imageData(i-1,j-1)>=0))
                    newImageData(i,j) = imageData(i,j);
                elseif((imageData(i-1,j+1)>=0 && imageData(i+1,j-1)<0) || (imageData(i-1,j+1)<0 && imageData(i+1,j-1)>=0))
                    newImageData(i,j) = imageData(i,j);
                end
            end
        end
    end

    imageFinal=im2uint8(newImageData);
    %figure; r = imshow(imageFinal, [min(imageFinal(:)), max(imageFinal(:))]);

    % binarization
    maxPixel = max(imageFinal(:));
    imageBinaryFinal = imageFinal > 0.005 * maxPixel; 
    figure; imshow(imageBinaryFinal);

    % TODO: edge linking

    % COMPARISON
    % figure; edge(imageRaw, 'canny');

    % STEP BY STEP PLOT
    % figure;
    % subplot(2,3,1); imshow(imageRaw); title('Raw');
    % subplot(2,3,2); imshow(imageFiltered); title('Gauss');
    % subplot(2,3,3); imshow(imageLaplace, [min(imageLaplace(:)), max(imageLaplace(:))]); title('Laplace');
    % subplot(2,3,4); imshow(imageFinal, [min(imageFinal(:)), max(imageFinal(:))]); title('Zero-crossings');
    % subplot(2,3,5); imshow(imageBinaryFinal); title('Binarized');
    % subplot(2,3,6); edge(imageRaw, 'log'); title('MATLAB edge() function');

    % store
    imwrite(imageBinaryFinal,'edited.png');