function [bitPlanR, bitPlanG, bitPlanB] = restoreBitPlan(frame)
    frameR = frame(:,:,1);
    frameG = frame(:,:,2);
    frameB = frame(:,:,3);

    frameRbin = dec2bin(frameR, 8);
    frameGbin = dec2bin(frameG, 8);
    frameBbin = dec2bin(frameB, 8);

    bitPlanR = frameRbin(:,8);
    bitPlanG = frameGbin(:,8);
    bitPlanB = frameBbin(:,8);
end