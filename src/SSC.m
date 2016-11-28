function frameType = SSC(frameT, nextFrameT, prevFrameType)
%SSC Implements Sequence Segmentation Control step
%   frameType = SSC(frameT, nextFrameT, prevFrameType)
%   frameType: Can take one of the following values:
%       -'OLS' for ONLY_LONG_SEQUENCE (1)
%       -'LSS' for LONG_START_SEQUENCE (2)
%       -'ESH' for EIGHT_SHORT_SEQUENCE (3)
%       -'LPS' for LONG_STOP_SEQUENCE (4)
%   frameT: Frame i in the time domain. Contains 2 audio channels. 2048x2
%       matrix.
%   nextFrameT: Next frame, with index i+1. Used for window selection.
%       2048x2 matrix.
%   prevFrameType: Type that was chosen for the previous frame, with index
%       i-1.
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    candidate = zeros(2,1);
    for ch = 1:2
        filtered = filter([0.7548, -0.7548], [1, -0.5095], nextFrameT(:, ch));
        s = sum(reshape(filtered(577:1600), [128, 8]).^2, 1)';
        ds = zeros(8, 1);
        for l = 1:8
            ds(l) = l*s(l)/sum(s(1:l));
        end
        isNextFrameESH = any((s > 1e-3) & (ds > 10));
        switch prevFrameType
            case OLS
                if (isNextFrameESH) candidate(ch) = LSS;
                else candidate(ch) = OLS;
                end
            case ESH
                if (isNextFrameESH) candidate(ch) = ESH;
                else candidate(ch) = LPS;
                end
            case LSS
                candidate(ch) = ESH;
            case LPS
                candidate(ch) = OLS;
        end
    end
    if any(candidate == ESH)
        frameType = ESH;
    elseif any(candidate == LSS) && any(candidate == LPS)
        frameType = ESH;
    elseif any(candidate == LSS)
        frameType = LSS;
    elseif any(candidate == LPS)
        frameType = LPS;
    elseif candidate(1) == candidate(2)
        frameType = candidate(1);
    end
end
