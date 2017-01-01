function SNR = demoAAC2(fNameIn, fNameOut)
%DEMOAAC2 Demonstrates Level 2 encoding/decoding
    disp('Level 2 demo');
    disp('------------');

    [x, ~] = audioread(fNameIn);

    tic;
    AACSeq2 = AACoder2(fNameIn);
    disp(['Coding time: ' num2str(toc) ' seconds']);

    tic;
    y = iAACoder2(AACSeq2, fNameOut);
    disp(['Decoding time: ' num2str(toc) ' seconds']);

    N = min(size(y, 1), size(x, 1));
    x = x(1:N, :);
    y = y(1:N, :);
    SNR(1) = snr(y(:, 1), x(:, 1) - y(:, 1));
    SNR(2) = snr(y(:, 2), x(:, 2) - y(:, 2));

    disp(['Channel 1 SNR: ' num2str(SNR(1)) ' dB']);
    disp(['Channel 2 SNR: ' num2str(SNR(2)) ' dB']);
end
