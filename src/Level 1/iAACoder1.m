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

    % normalize signal in order to prevent clipping
    x(abs(x(:, 1)) > 1, 1) = x(abs(x(:, 1)) >= 1, 1)./abs(x(abs(x(:, 1)) >= 1, 1));
    x(abs(x(:, 2)) > 1, 2) = x(abs(x(:, 2)) >= 1, 2)./abs(x(abs(x(:, 2)) >= 1, 2));

    audiowrite(fNameOut, x, fs);
end
