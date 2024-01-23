function [bitPlan, x] = restoreBitPlanYUV(frame)
    [Y, U, V] = rgb2yuv(frame);
    Ybin = dec2bin(Y, 8);
    bitPlan = Ybin(:,5);
end