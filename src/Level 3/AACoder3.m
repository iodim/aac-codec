function AACSeq3 = AACoder3(fNameIn, fnameAACoded)
%AACODER3 Implements Level 3 encoding
%   AACSeq3 = AACoder3(fNameIn, fnameAACoded)
%   Returns the following values:
%    - AACSeq3: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. Every element has the following properties:
%        - AACSeq3(i).frameType
%        - AACSeq3(i).winType
%        - AACSeq3(i).chl.TNScoeffs
%        - AACSeq3(i).chr.TNScoeffs
%        - AACSeq3(i).chl.Τ
%        - AACSeq3(i).chr.Τ
%        - ACCSeq3(i).chl.G
%        - ACCSeq3(i).chr.G
%        - ACCSeq3(i).chl.sfc
%        - ACCSeq3(i).chr.sfc
%        - ACCSeq3(i).chl.stream
%        - ACCSeq3(i).chr.stream
%        - ACCSeq3(i).chl.codebook
%        - ACCSeq3(i).chr.codebook
%   Accepts the following arguments:
%    - fNameIn: Name of input .wav file
%    - fnameAACoded: Name of output file containing AACSeq3 struct
    NUL = 0;
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    KBD = 5;
    SIN = 6;
    
    [y, ~] = audioread(fNameIn);
    % y should not be truncated but right padded with zeroes to be
    % congruent to 0 mod 2048. Left pad 2 1024-sized blocks, so that we can
    % use psychoacoustic function to the first 1024-sized block of y.
    trueN = size(y, 1);
    rightpad = 1024 - mod(trueN, 1024);
    N = trueN + rightpad;
    y = [zeros(2048, 2); y; zeros(rightpad + 1024, 2)];
    % K is the number of frames that correspond to original wav only
    K = N/1024 - 1;    
    
    AACSeq2 = AACoder2(fNameIn);
    K2 = size(AACSeq2, 1);
    
    if K == K2, disp('popa'); end
    
    AACSeq3 = struct('frameType', num2cell(zeros(K,1)), ...
                     'winType', num2cell(zeros(K,1)), ...
                     'chl', struct('TNScoeffs', 0, 'T', 0, 'G', 0, 'sfc', 0, 'stream', 0, 'codebook', 0), ...
                     'chr', struct('TNScoeffs', 0, 'T', 0, 'G', 0, 'sfc', 0, 'stream', 0, 'codebook', 0));

    % Load MPEG-4 standard huffman-coding books.
    % Codebooks are indexed from 1 to 12. 1-11 books are standard books for
    % encoding quantized spectrum stream (see pdf-page 60-61 in
    % 'w2203tfa.pdf'). Book 12 is the standard book for encoding
    % quantization scalefactors (here appended as 12 in the standard list
    % by 'loadLUT.m' - see Annex A, pdf-page 81 in 'w2203tft.pdf'.
    huffLUT = loadLUT();
    scalefactorsCodebookNum = 12;
    
    for k = 1:K
       frameType = AACSeq2(k).frameType;
       AACSeq3(k).frameType = frameType;
       AACSeq3(k).winType = AACSeq2(k).winType;
       AACSeq3(k).chl.TNScoeffs = AACSeq2(k).chl.TNScoeffs;
       AACSeq3(k).chr.TNScoeffs = AACSeq2(k).chr.TNScoeffs;
       
%        if frameType == ESH, idx = reshape(1:1024, [128, 8]);
%        else idx = 1:1024; end
       
       % NOTE: how can we take chl/chr.T since it is calculated inside psycho.m?
       
       % Calculate SMR for this frame using psychoacoustic model.
       % To be used in non homogenous quantization.
       frameT = y(((k+1)*1024 + 1):(k+3)*1024, :);
       frameTprev1 = y(((k)*1024 + 1):(k+2)*1024, :);
       frameTprev2 = y(((k-1)*1024 + 1):(k+1)*1024, :);
       SMR = psycho(frameT, frameType, frameTprev1, frameTprev2);
       
       % Quantize and huffman encode left channel frame frequencies.
       [S, sfc, AACSeq3(k).chl.G] = AACquantizer(AACSeq2(k).chl.frameF, frameType, SMR);
       [AACSeq3(k).chl.stream, AACSeq3(k).chl.codebook] = encodeHuff(S, huffLUT);
       [AACSeq3(k).chl.sfc, scalefactorsCodebookNum] = encodeHuff(sfc(:), huffLUT, scalefactorsCodebookNum);
       
       % Quantize and huffman encode right channel frame frequencies.
       [S, sfc, AACSeq3(k).chr.G] = AACquantizer(AACSeq2(k).chr.frameF, frameType, SMR);
       [AACSeq3(k).chr.stream, AACSeq3(k).chr.codebook] = encodeHuff(S, huffLUT);
       [AACSeq3(k).chr.sfc, scalefactorsCodebookNum] = encodeHuff(sfc(:), huffLUT, scalefactorsCodebookNum);
    end
    
    save(fnameAACoded, AACSeq3);
end

