%%
clear all
close all
clc

watermark = 'secret key secret key secret key secret key secret key secret key';
binaryWatermark = dec2bin(uint8(watermark),8);
[numWords, numBits] = size(binaryWatermark);
binaryWatermark = reshape(binaryWatermark', 1, numBits*numWords);

% Load video and watermark
videoRGBFlag = boolean(0);
watermarkRGBFlag = boolean(0);

% Extracting video info
video = VideoReader('video.avi'); % load video
index=1;
while hasFrame(video)
    image = readFrame(video);
    index = index + 1;
end
imageSize = size(image);
width = imageSize(2); % horizontal resolution
height = imageSize(1); % vertical resolution
numFrames = index - 1; % number of frames

% Checking if video is RGB format
if length(size(image)) == 3
    videoRGBFlag = boolean(1);
end

% Checking if text watermark fits the video
if videoRGBFlag
    if length(binaryWatermark) <= width*height*3
        flag = true;
    else
        disp('Text too long.')
    end
else 
    if length(binaryWatermark) <= width*height
        flag = true;
    else
        disp('Text too long')
    end
end

frameNumber = randi(numFrames,[1, 1]);


if flag
    video = VideoReader('video.avi'); % load video
    for idx=1:numFrames
        frame = readFrame(video);
        if idx == frameNumber
            [frame, pixelsModified, colorNumBits] = encryptFrame(frame, width, height, binaryWatermark);
        end
        outputFrame(idx) = im2frame(frame);
    end
    
    outputVideo = VideoWriter('results/encryptedVideo.avi','Uncompressed AVI'); % open an empty vide
    outputVideo.FrameRate = 30; % set frame rate
    outputVideo.open()
    writeVideo(outputVideo,outputFrame);
    close(outputVideo);
    
    encryptKey = [frameNumber double(colorNumBits) pixelsModified];
    writematrix(encryptKey, 'key/key.txt')
    
    decryptKey = readmatrix('key/key.txt');
      
    frameNumberDecrypt = decryptKey(1);
    
    video = VideoReader('encryptedVideo.avi'); % load video
    for idx=1:numFrames
        frame = readFrame(video);
        if idx == frameNumberDecrypt
            text = decryptFrame(frame, decryptKey);
        end
        outputFrame(idx) = im2frame(frame);
    end
    
    fileID = fopen('results/decryptedText.txt','w');
    nbytes = fprintf(fileID,'%s',text);
    
    implay('encryptedVideo.avi');

end

FINISHED = 0

%%

% Plot bit plans 
original_image = imread('lena.bmp');

image = original_image;

bitPlan1 = bitand(image, 128, "uint8");
bitPlan2 = bitand(image, 64, "uint8");
bitPlan3 = bitand(image, 32, "uint8");
bitPlan4 = bitand(image, 16, "uint8");
bitPlan5 = bitand(image, 8, "uint8");
bitPlan6 = bitand(image, 4, "uint8");
bitPlan7 = bitand(image, 2, "uint8");
bitPlan8 = bitand(image, 1, "uint8");

figure
imshow(bitPlan8)
title('Bit Plane 8')
