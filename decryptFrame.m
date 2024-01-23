function [text] = decryptFrame(frame, decryptKey)

    bitsR = decryptKey(2);
    bitsG = decryptKey(3) + bitsR;
    bitsB = decryptKey(4) + bitsG;

    pixels = decryptKey(5:length(decryptKey));

    pixelsR = pixels(1:bitsR);
    pixelsG = pixels(bitsR+1:bitsG);
    pixelsB = pixels(bitsG+1:bitsB);

    imgR = frame(:,:,1);
    imgG = frame(:,:,2);
    imgB = frame(:,:,3);

    pixelsToDecryptR = dec2bin(imgR(pixelsR),8);
    pixelsToDecryptG = dec2bin(imgG(pixelsG),8);
    pixelsToDecryptB = dec2bin(imgB(pixelsB),8);

    pixelsToDecryptR = pixelsToDecryptR(:,8);
    pixelsToDecryptG = pixelsToDecryptG(:,8);
    pixelsToDecryptB = pixelsToDecryptB(:,8);

    pixelsToDecrypt = cat(1,pixelsToDecryptR, pixelsToDecryptG, pixelsToDecryptB)';
    pixelsToDecrypt = reshape(pixelsToDecrypt, 8, length(pixelsToDecrypt)/8)';
    text = bin2dec(pixelsToDecrypt);

end