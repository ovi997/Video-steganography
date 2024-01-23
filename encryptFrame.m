function [encryptedFrame, pixelsModified, colorNumBits] = encryptFrame(originalFrame, width, height, binaryWatermark)
    
    % Determine number of pixels modified for each color plan
    bitsR = uint64(length(binaryWatermark)/3);
    bitsG = uint64(length(binaryWatermark)/3);
    bitsB = length(binaryWatermark) - (bitsR + bitsG);
    length(binaryWatermark);
    % Generate random numbers serving as pixels to be modified
    idxsR = generateUniqueIndexes((width*height), bitsR);
    idxsG = generateUniqueIndexes((width*height), bitsG);
    idxsB = generateUniqueIndexes((width*height), bitsB);
    
    % Create a mask for informational bits
    maskR = zeros([height width],"uint8");
    maskG = zeros([height width], "uint8");
    maskB = zeros([height width], "uint8");
  
    maskR(idxsR) = 255;
    maskG(idxsG) = 255;
    maskB(idxsB) = 255;
    
    % Modify the pixels
    imageR = originalFrame(:,:,1);
    imageG = originalFrame(:,:,2);
    imageB = originalFrame(:,:,3);
    
    binaryPixelsR = dec2bin(imageR(idxsR), 8);
    binaryPixelsG = dec2bin(imageG(idxsG), 8);
    binaryPixelsB = dec2bin(imageB(idxsB), 8);
    
    for idx=1:length(binaryPixelsR)
        binaryPixelsR(idx, 8) = binaryWatermark(idx);
    end
    
    for idx=1:length(binaryPixelsG)
        binaryPixelsG(idx, 8) = binaryWatermark(idx + length(binaryPixelsR));
    end
    
    for idx=1:length(binaryPixelsB)
        binaryPixelsB(idx, 8) = binaryWatermark(idx + length(binaryPixelsR) + length(binaryPixelsG));
    end
    
    decimalPixelsR = bin2dec(binaryPixelsR);
    decimalPixelsG = bin2dec(binaryPixelsG);
    decimalPixelsB = bin2dec(binaryPixelsB);
    
    imageR(idxsR) = decimalPixelsR;
    imageG(idxsG) = decimalPixelsG;
    imageB(idxsB) = decimalPixelsB;
    
    encryptedFrame = cat(3, imageR, imageG, imageB);
    pixelsModified = [idxsR, idxsG, idxsB];
    colorNumBits = [bitsR, bitsG, bitsB];
end