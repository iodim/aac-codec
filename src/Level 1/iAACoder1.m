function x = iAACoder1(AACSeq1, fNameOut)
%IAACODER1 Implements  Level 1 decoding
%   x = iAACoder1(AACSeq1, fNameOut)
%   Returns the following values:
%    - x: Optional, returns decoded values
%   Accepts the following arguments:
%    - AACSeq1: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. Every element has the following properties:
%        - AACSeq1(i).frameType
%        - AACSeq1(i).winType
%        - AACSeq1(i).chl.frameF
%        - AACSeq1(i).chr.frameF
%    - fNameOut: Name of output .wav file
    fs = 48000;
    K = size(AACSeq1, 1);
    N = (K + 1)*1024;
    x = zeros(N, 2);
    for k = 1:K
        currFrameF = [AACSeq1(k).chl.frameF AACSeq1(k).chr.frameF];
        x(((k-1)*1024 + 1):(k+1)*1024, :) = x(((k-1)*1024 + 1):(k+1)*1024, :) ...
            + iFilterbank(currFrameF, AACSeq1(k).frameType, AACSeq1(k).winType);
    end
    x = x(1025:(N-1024), :);

    % audiowrite issues a warning when writing from L3, so suppress
    % warnings temporarily
    warning('off','all');
    audiowrite(fNameOut, x, fs);
    warning('on','all');
end
