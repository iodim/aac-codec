function frameF = iAACquantizer(S, sfc, G, frameType)
%IAACQUANTIZER Implements the inverse Quantizer step for one channel.
%   frameF = iAACquantizer(S, sfc, G, frameType)
%   See help AACquantizer for details.
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    
    if frameType == ESH
        subframes = 8;
        freqs = 128;
        S = reshape(S, [freqs, subframes]);
        sfc = reshape(sfc, [freqs, subframes]);
    else
        subframes = 1;
        freqs = 1024;
    end
    
    frameF = zeros(freqs, subframes);
    for i = 1:subframes
        sfc(2:end, i) = sfc(2:end, i) + sfc(1:end-1, i);
        a = G(i) - sfc(:, i);
        frameF(:, i) = sign(S(:, i)).*abs(S(:, i)).^(4/3).*2.^(1/4*a);
    end
end

