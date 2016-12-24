function x = iAACoder2(AACSeq2, fNameOut)
%iAACODER2 Implements Level 2 decoding
%   x = iAACoder1(AACSeq1, fNameOut)
%   Returns the following values:
%    - x: Optional, returns decoded values
%   Accepts the following arguments:
%    - AACSeq2: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. Every element has the following properties:
%        - AACSeq2(i).frameType
%        - AACSeq2(i).winType
%        - AACSeq2(i).chl.TNScoeffs
%        - AACSeq2(i).chr.TNScoeffs
%        - AACSeq2(i).chl.frameF
%        - AACSeq2(i).chr.frameF
%    - fNameOut: Name of output .wav file
    NUL = 0;
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    KBD = 5;
    SIN = 6;
    
    K = size(AACSeq2, 1);
    
    AACSeq1 = struct('frameType', num2cell(zeros(K, 1)), ...
                     'winType', num2cell(zeros(K, 1)), ...
                     'chl', struct('frameF',  0), ...
                     'chr', struct('frameF',  0));

    for k = 1:K
        AACSeq1(k).frameType = AACSeq2(k).frameType;
        AACSeq1(k).winType = AACSeq2(k).winType;
        AACSeq1(k).chl.frameF = iTNS(AACSeq2(k).chl.frameF, ...
            AACSeq2(k).frameType, AACSeq2(k).chl.TNScoeffs);
        AACSeq1(k).chr.frameF = iTNS(AACSeq2(k).chr.frameF, ...
            AACSeq2(k).frameType, AACSeq2(k).chr.TNScoeffs);
        AACSeq1(k).chl.frameF = AACSeq1(k).chl.frameF(:);
        AACSeq1(k).chr.frameF = AACSeq1(k).chr.frameF(:);
    end                 
     x = iAACoder1(AACSeq1, fNameOut);
end

