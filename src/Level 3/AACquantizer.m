function [S, sfc, G] = AACquantizer(frameF, frameType, SMR)
%AACQUANTIZER Implements the Quantizer step for one channel.
%   [S, sfc, G] = AACquantizer(frameF, frameType, SMR)
%   Returns the following values:
%    - S: Vector of size 1024x1 containing the symbols from MDCT
%    coefficients quantization of the current frame, for all type of frame.
%    - sfc: NBx8 matrix for ESH frames, else NBx1 vector, containing
%    scalefactor gains for each band.
%    - G: Current frame's global gain (1x8 for ESH, else scalar).
%   Accepts the following arguments:
%    - frameF: Current frame's frequency domain represantation. 128x8 
%   matrix if frame is ESH, else 1024x1 vector.
%    - frameType: see SSC.m
%    - SMR: see psycho.m
    OLS = 1;
    LSS = 2;
    ESH = 3;
    LPS = 4;
    
    load('TableB219.mat');
    
    if frameType == ESH
        wlow = B219b(:, 2);
        whigh = B219b(:, 3);
        width = B219b(:, 4);
        bval = B219b(:, 5);
        qsthr = B219b(:, 6);
    else
        wlow = B219a(:, 2);
        whigh = B219a(:, 3);
        width = B219a(:, 4);
        bval = B219a(:, 5);
        qsthr = B219a(:, 6);
    end
    
    Nb = size(wlow, 1);
    P = zeros(Nb, size(frameF, 2));
    for b = 1:Nb
        P(b, :) = sum(frameF((wlow(b)+1):(whigh(b)+1), :).^2);
    end
    T = P ./ SMR;
    
    S = zeros(size(frameF));
    G = zeros(1, size(frameF, 2));
    sfc = zeros(Nb, size(frameF, 2));
    
    % Quantizization
    MQ = 8191;
    for i = 1:size(frameF, 2)
        X = frameF(:, i);
        a_hat = repmat(16/3*log2(max(X).^(3/4)./MQ), Nb, 1);
        a_hat_next = a_hat;
        Pe = zeros(Nb, 1);
        while 1
            a_hat = a_hat_next;
            S(:, i) = sign(X).*fix(abs(X).*2.^(-1/4 * a_hat).^(3/4) + 0.4054);
            X_hat = sign(S).*abs(S).^(4/3).*2.^(1/4*a_hat);
            for b = 1:Nb
                Pe(b) = sum((X((wlow(b)+1):(whigh(b)+1)) - X_hat((wlow(b)+1):(whigh(b)+1))).^2);
            end
            if all(Pe >= T(:, i)), break; end
            a_hat_next = a_hat;
            a_hat_next(Pe < T(:, i)) = a_hat_next(Pe < T(:, i)) + 1;
            if max(abs(a_hat_next - a_hat)) > 60, break; end
        end
        S(:, i) = sign(X).*fix(abs(X).*2.^(-1/4 * a_hat).^(3/4) + 0.4054);
        G(i) = max(a_hat);
        sfc(:, i) = G(i) - a_hat;
        sfc(2:end, i) = sfc(2:end, i) - sfc(1:end-1, i);
    end
    S = S(:);
end

