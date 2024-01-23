clear all
close all
clc
%%
% Extracting video info
video = VideoReader('small.mp4'); % load video
index=1;
while hasFrame(video)
    frame = readFrame(video);
    index = index + 1;
end
[videoHeight, videoWidth, videoNumColorChannels] = size(frame);
numFrames = index - 1; % number of frames
frameRate = video.FrameRate;

% Extracting image info
filename = 'lena.bmp';
hiddenImage = imread(filename);
[imageHeight, imageWidth, imageNumColorChannels] = size(hiddenImage);

% if video is RGB and image is GrayScale, then numChannels=1
% if both are RGB, then numChannels=3
% for the first case, the image will be hidden in R plan of the video
if videoNumColorChannels > imageNumColorChannels
    numChannels = 1;
elseif videoNumColorChannels == imageNumColorChannels
    numChannels = 3;
end
% Generating the key
frameNumbers = generateUniqueIndexes(numFrames, 8);

%%
% Encrypt video
% The numbers generated for the key aren't ordered, so to keep this
% randomness, the video will be processed 8 times, each time for a bit plan
for bitPlan=1:8
    video = VideoReader('small.mp4'); % load video
    for idx=1:numFrames
        frame = readFrame(video);
        if idx == frameNumbers(bitPlan)
            [encryptedFrame]= encryptFrameImage(frame, videoHeight, videoWidth, imageHeight, imageWidth, hiddenImage, bitPlan, numChannels);
            frame = uint8(encryptedFrame);
        end
        if bitPlan == 1
            outputFrame(idx) = im2frame(frame); % storing frames for the result video
        elseif idx == frameNumbers(bitPlan)
            outputFrame(idx) = im2frame(frame);
        end
    end
end

outputVideo = VideoWriter('results/encryptedVideo.avi','Uncompressed AVI'); % open an empty video
outputVideo.FrameRate = frameRate; % set frame rate
outputVideo.open()
writeVideo(outputVideo,outputFrame); % write stored frames
close(outputVideo);

encryptKey = frameNumbers;
writematrix(encryptKey, 'key/key.txt') % save the key on a txt file

%%
% Decrypt video and restore the image
decryptKey = readmatrix('key/key.txt'); % read the key from the file

if numChannels == 3
    decryptedImage = zeros(videoHeight,videoWidth,videoNumColorChannels, 'uint8'); % initialize a zero matrix with the frame shape
    decryptedImageRbin = dec2bin(decryptedImage(:,:,1), 8);
    decryptedImageGbin = dec2bin(decryptedImage(:,:,2), 8);
    decryptedImageBbin = dec2bin(decryptedImage(:,:,3), 8);
    
    for bitPlan=1:8
        video2 = VideoReader('encryptedVideo.avi'); % load video
        for idx=1:numFrames
            frame = readFrame(video2);
            if idx == decryptKey(bitPlan)
                [bitPlanR, bitPlanG, bitPlanB] = restoreBitPlan(frame); % restore bit plans from frames
                decryptedImageRbin(:, bitPlan) = bitPlanR;
                decryptedImageGbin(:, bitPlan) = bitPlanG;
                decryptedImageBbin(:, bitPlan) = bitPlanB;
                break
            end
        end
    end
    
    decryptedImageR = reshape(bin2dec(decryptedImageRbin), videoHeight, videoWidth);
    decryptedImageG = reshape(bin2dec(decryptedImageGbin), videoHeight, videoWidth);
    decryptedImageB = reshape(bin2dec(decryptedImageBbin), videoHeight, videoWidth);
    
    decryptedImage = cat(3, decryptedImageR, decryptedImageG, decryptedImageB); % reconstruct original image
    decryptedImage = uint8(decryptedImage); 
    imshow(decryptedImage)

    % For the grayscaled images, the process is the same, but it will be
    % used just the R color plan
elseif numChannels == 1
    decryptedImage = zeros(videoHeight, videoWidth, 'uint8');
    decryptedImageBin = dec2bin(decryptedImage, 8);
    for bitPlan=1:8
        video2 = VideoReader('encryptedVideo.avi'); % load video
        for idx=1:numFrames
            frame = readFrame(video2);
            if idx == decryptKey(bitPlan)
                [bitPlanR, bitPlanG, bitPlanB] = restoreBitPlan(frame);
%                 bitPlanR = restoreBitPlanYUV(frame);
                decryptedImageBin(:, bitPlan) = bitPlanR;
                break
            end
        end
    end
    decryptedImage = reshape(bin2dec(decryptedImageBin), videoHeight, videoWidth);
    decryptedImage = uint8(decryptedImage);
    imshow(decryptedImage)
end

%%
FINISHED = 0

