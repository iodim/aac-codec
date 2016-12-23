function AACSeq1 = AACoder1(fNameIn)
%AACODER1 Implements Level 1 encoding
%   AACSeq1 = AACoder1(fNameIn)
%   Returns the following values:
%    - AACSeq1: Struct of Kx1 dimensions, where K is the number of encoded
%    frames. Every element has the following properties:
%        - AACSeq1(i).frameType
%        - AACSeq1(i).winType
%        - AACSeq1(i).chl.frameF
%        - AACSeq1(i).chr.frameF
%   Accepts the following arguments:
%    - fNameIn: Name of input .wav file
    NUL = 0;
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    KBD = 5;
    SIN = 6;
    
    defaultWinType = KBD;

%     [y, fs] = audioread(fNameIn);
%     y = [y; zeros(1024 - mod(size(y, 1), 1024), 2)];
%     y = [zeros(1024, 2); y; zeros(1024, 2)];
%     N = size(y, 1);
    [y, fs] = audioread(fNameIn);
    N = size(y, 1);
    N = N - mod(N, 2048);
    y = [zeros(1024, 2); y(1:N, :); zeros(1024, 2)];

    K = N/1024 - 1;
    prevFrameType = NUL;
    
    AACSeq1 = struct('frameType', num2cell(zeros(K-1,1)), ...
                     'winType', num2cell(zeros(K-1,1)), ...
                     'chl', struct('frameF',  0), ...
                     'chr', struct('frameF',  0));
    
    for k = 1:(K-1)
        currFrameT = y(((k-1)*1024 + 1):(k+1)*1024, :);
        nextFrameT = y((k*1024 + 1):(k+2)*1024, :);
        frameType = SSC(currFrameT, nextFrameT, prevFrameType);
        prevFrameType = frameType;
        currframeF = filterbank(currFrameT, frameType, defaultWinType);
        AACSeq1(k).winType = defaultWinType;
        AACSeq1(k).frameType = frameType;
        AACSeq1(k).chl.frameF = currframeF(:, 1);
        AACSeq1(k).chr.frameF = currframeF(:, 2);
    end
end

