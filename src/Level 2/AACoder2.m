function AACSeq2 = AACoder2(fNameIn)
%AACODER2 Implements Level 2 encoding
%   AACSeq2 = AACoder2(fNameIn)
%   Returns the following values:
%    - AACSeq2: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. Every element has the following properties:
%        - AACSeq2(i).frameType
%        - AACSeq2(i).winType
%        - AACSeq2(i).chl.TNScoeffs
%        - AACSeq2(i).chr.TNScoeffs
%        - AACSeq2(i).chl.frameF
%        - AACSeq2(i).chr.frameF
%   Accepts the following arguments:
%    - fNameIn: Name of input .wav file
    NUL = 0;
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    KBD = 5;
    SIN = 6;
    
    AACSeq1 = AACoder1(fNameIn);
    K = size(AACSeq1, 1);
    AACSeq2 = struct('frameType', num2cell(zeros(K,1)), ...
                     'winType', num2cell(zeros(K,1)), ...
                     'chl', struct('TNScoeffs', 0, 'frameF',  0), ...
                     'chr', struct('TNScoeffs', 0, 'frameF',  0));
    for k = 1:K
       if AACSeq1(k).frameType == ESH, idx = reshape(1:1024, [128, 8]);
       else idx = 1:1024; end
       AACSeq2(k).frameType = AACSeq1(k).frameType;
       AACSeq2(k).winType = AACSeq1(k).winType;
       [AACSeq2(k).chl.frameF, AACSeq2(k).chl.TNScoeffs] = ...
           TNS(AACSeq1(k).chl.frameF(idx), AACSeq1(k).frameType);
       [AACSeq2(k).chr.frameF, AACSeq2(k).chr.TNScoeffs] = ...
           TNS(AACSeq1(k).chr.frameF(idx), AACSeq1(k).frameType);
    end
end

