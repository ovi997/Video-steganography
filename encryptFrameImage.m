function [encryptedFrame] = encryptFrameImage(frame, videoHeight, videoWidth, imageHeight, imageWidth, hiddenImage, bitPlan, numChannels)
    if numChannels == 3
        % Split color planes
        frameR = frame(:,:,1);
        frameG = frame(:,:,2);
        frameB = frame(:,:,3);
        
        % Convert values from each plan to binary
        frameRbin = dec2bin(frameR, 8);
        frameGbin = dec2bin(frameG, 8);
        frameBbin = dec2bin(frameB, 8);

        % Making video and image have the same resolution
        watermarkR = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, frame(:,:,1), hiddenImage(:,:,1));
        watermarkG = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, frame(:,:,2), hiddenImage(:,:,2));
        watermarkB = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, frame(:,:,3), hiddenImage(:,:,3));
        
        % Convert watermark values to binary
        watermarkRbin = dec2bin(watermarkR, 8);
        watermarkGbin = dec2bin(watermarkG, 8);
        watermarkBbin = dec2bin(watermarkB, 8);
        
        % Replace LSB Plan from the frame with the coresponding bit plan
        % from watermark
        frameRbin(:,8) = watermarkRbin(:,bitPlan);
        frameGbin(:,8) = watermarkGbin(:,bitPlan);
        frameBbin(:,8) = watermarkBbin(:,bitPlan);
        
        % Covert the new values to decimal 
        frameR = bin2dec(frameRbin);
        frameG = bin2dec(frameGbin);
        frameB = bin2dec(frameBbin);
        
        % Reconstruct the frame 
        frameR = reshape(frameR, videoHeight, videoWidth);
        frameG = reshape(frameG, videoHeight, videoWidth);
        frameB = reshape(frameB, videoHeight, videoWidth);
    
        encryptedFrame = cat(3, frameR, frameG, frameB);

        % For a single channel is the same, but it is used just R color plan
    elseif numChannels == 1
        frameR = frame(:,:,1);
        watermark = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, frameR, hiddenImage);
        frameRbin = dec2bin(frameR, 8);
        watermarkbin = dec2bin(watermark, 8);
        frameRbin(:, 8) = watermarkbin(:, bitPlan);

        frameR = bin2dec(frameRbin);
        frameR = reshape(frameR, videoHeight, videoWidth);
        frame(:,:,1) = frameR;
        
        encryptedFrame = frame;
        
        % Replacing a bit plan from Y component
        % The results are not so good, because of the conversion from RGB
        % to YUV and back
%         [Y, U, V] = rgb2yuv( frame );
%         watermark = scaleImage(imageHeight, imageWidth, videoHeight, videoWidth, Y, hiddenImage);
%         Ybin = dec2bin(Y, 8);
%         watermarkbin = dec2bin(watermark, 8);
%         Ybin(:, 5) = watermarkbin(:, bitPlan);
%         Y = double(bin2dec(Ybin));
%         Y = uint8(reshape(Y, videoHeight, videoWidth));
%         encryptedFrame = yuv2rgb(Y,U,V);

    end
end