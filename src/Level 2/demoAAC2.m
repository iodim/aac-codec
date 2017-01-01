function SNR = demoAAC2(fNameIn, fNameOut)
%DEMOAAC2 Demonstrates Level 2 encoding/decoding
    [x, ~] = audioread(fNameIn);
    AACSeq2 = AACoder2(fNameIn);
    y = iAACoder2(AACSeq2, fNameOut);
    
    N = min(size(y, 1), size(x, 1));
    x = x(1:N, :);
    y = y(1:N, :);
    SNR(1) = snr(y(:, 1), x(:, 1) - y(:, 1));
    SNR(2) = snr(y(:, 2), x(:, 2) - y(:, 2));
end
