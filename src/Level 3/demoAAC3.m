function [SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded)
%DEMOAAC3 Demonstrates Level 3 encoding/decoding
    disp('Level 3 demo');
    disp('------------');

    [x, fs] = audioread(fNameIn);

    tic;
    AACSeq3 = AACoder3(fNameIn, frameAACoded);
    disp(['Coding time: ' num2str(toc) ' seconds']);

%     load('L3.mat')

    tic;
    y = iAACoder3(AACSeq3, fNameOut);
    disp(['Decoding time: ' num2str(toc) ' seconds']);

    N = min(size(y, 1), size(x, 1));
    x = x(1:N, :);
    y = y(1:N, :);

    SNR(1) = snr(y(:, 1), x(:, 1) - y(:, 1));
    SNR(2) = snr(y(:, 2), x(:, 2) - y(:, 2));

    duration = N/fs;
    fstruct = dir(frameAACoded);
    c_size = fstruct.bytes/1024;
    c_bitrate = c_size/duration;

    fwave = dir(fNameIn);
    u_size = fwave.bytes/1024;
    u_bitrate = u_size/duration;

    bitrate = [u_bitrate c_bitrate];
    compression = u_bitrate/c_bitrate;

    disp(['Channel 1 SNR: ' num2str(SNR(1)) ' dB']);
    disp(['Channel 2 SNR: ' num2str(SNR(2)) ' dB']);
    disp(['Uncompressed audio size: ' num2str(u_size/1024) ' MB'])
    disp(['Uncompressed audio bitrate: ' num2str(u_bitrate) ' KB/s'])
    disp(['Compressed struct size: ' num2str(c_size) ' KB'])
    disp(['Compressed struct bitrate: ' num2str(c_bitrate) ' KB/s'])
    disp(['Compression ratio: ' num2str(100/compression) ' % (x ' num2str(compression) ')'])
end

