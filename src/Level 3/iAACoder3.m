function x = iAACoder3(AACSeq3, fNameOut)
%IAACODER3 Implements Level 3 decoding
%   x = iAACoder3(AACSeq3, fNameOut)
%   Returns the following values:
%    - x: Optional, returns decoded values
%   Accepts the following arguments:
%    - AACSeq3: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. See file AACoder3 for details about its elements.
%    - fNameOut: Name of output .wav file
    
    K = size(AACSeq3, 1);
    AACSeq2 = struct('frameType', num2cell(zeros(K,1)), ...
                     'winType', num2cell(zeros(K,1)), ...
                     'chl', struct('TNScoeffs', 0, 'frameF',  0), ...
                     'chr', struct('TNScoeffs', 0, 'frameF',  0));
    
    huffLUT = loadLUT();
    scalefactorsCodebookNum = 12;
    
    for k = 1:K
        frameType = AACSeq3(k).frameType;
        AACSeq2(k).frameType = frameType;
        AACSeq2(k).winType = AACSeq3(k).winType;
        AACSeq2(k).chl.TNScoeffs = AACSeq3(k).chl.TNScoeffs;
        AACSeq2(k).chr.TNScoeffs = AACSeq3(k).chr.TNScoeffs;
        
        % Huffman-decode and inverse quantization in left channel
        sfc = decodeHuff(AACSeq3(k).chl.sfc, scalefactorsCodebookNum, huffLUT);
        sfc = sfc(1:1024);  % See CAUTION at 'decodeHuff.m', dims of sfc??
        S = decodeHuff(AACSeq3(k).chl.stream, AACSeq3(k).chl.codebook, huffLUT);
        S = S(1:1024);  % See CAUTION at 'decodeHuff.m'
        AACSeq2(k).chl.frameF = iAACquantizer(S, sfc, AACSeq3(k).chl.G, frameType);
        AACSeq2(k).chl.frameF = AACSeq2(k).chl.frameF(:);
        
        % Huffman-decode and inverse quantization in right channel
        sfc = decodeHuff(AACSeq3(k).chr.sfc, scalefactorsCodebookNum, huffLUT);
        sfc = sfc(1:1024);  % See CAUTION at 'decodeHuff.m', dims of sfc??
        S = decodeHuff(AACSeq3(k).chr.stream, AACSeq3(k).chr.codebook, huffLUT);
        S = S(1:1024);  % See CAUTION at 'decodeHuff.m'
        AACSeq2(k).chr.frameF = iAACquantizer(S, sfc, AACSeq3(k).chr.G, frameType);
        AACSeq2(k).chr.frameF = AACSeq2(k).chr.frameF(:);
    end
    
    x = iAACoder2(AACSeq2, fNameOut);
end

