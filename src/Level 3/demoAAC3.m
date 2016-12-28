function [SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded)
%DEMOAAC3 Demonstrates Level 3 encoding/decoding
%   Detailed explanation goes here
    [x, ~] = audioread(fNameIn);
%     AACSeq3 = AACoder3(fNameIn, frameAACoded);
    load('peos.mat')
    y = iAACoder3(AACSeq3, fNameOut);
    
    N = min(size(y, 1), size(x, 1));
    x = x(1:N, :);
    y = y(1:N, :);
    SNR(1) = snr(y(:, 1), x(:, 1) - y(:, 1));
    SNR(2) = snr(y(:, 2), x(:, 2) - y(:, 2));

end

