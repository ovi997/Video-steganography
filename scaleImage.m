function [watermark] = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, videoFrame, image)

    % If image to be hidden is bigger than the original image, scale it down.
    if imageHeight > videoHeight || imageWidth > videoWidth
	    amountToShrink = min([videoHeight / imageHeight, videoWidth / imageWidth]);
	    image = imresize(image, amountToShrink);
	    % Need to update the number of rows and columns.
	    [imageHeight, imageWidth] = size(image);
    end
    
    % Tile the hiddenImage, if it's smaller, so that it will cover the original image.
    if imageHeight < videoHeight || imageWidth < videoWidth
	    watermark = zeros(size(videoFrame), 'uint8');
	    for column = 1:videoWidth
		    for row = 1:videoHeight
			    watermark(row, column) = image(mod(row,imageHeight)+1, mod(column,imageWidth)+1);
		    end
	    end
	    % Crop it to the same size as the original image.
	    watermark = watermark(1:videoHeight, 1:videoWidth);
    else
	    % Watermark is the same size as the original image.
	    watermark = image;
    end
end