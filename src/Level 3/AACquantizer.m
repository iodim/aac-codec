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
%    - frameF: Current frame's frequency domain representation. 128x8 
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
        P(b, :) = sum(frameF((wlow(b)+1):(whigh(b)+1), :).^2, 1);
    end
    T = P ./ SMR;
    
    T(isnan(T)) = 0;
    
    S = zeros(size(frameF));
    G = zeros(1, size(frameF, 2));
    sfc = zeros(Nb, size(frameF, 2));
    
    % Quantization
    MQ = 8191;
    magic = 0.4054;
    for i = 1:size(frameF, 2)
        X = frameF(:, i);
        a_hat = repmat(floor(16/3*log2(max(X)^(3/4)/MQ)), Nb, 1);
        a_hat(isinf(a_hat)) = 0;
        a_hat_next = a_hat;
        Pe = zeros(Nb, 1);
        bands = 1:Nb;
        while 1
            % End if discontinuity between scalefactors exceed 60.
            % This step enforces that scalefactor representation can be
            % huffman-encoded by its standard book.
            if max(abs(a_hat_next(2:end) - a_hat_next(1:end-1))) > 60, break; end
            % if abs(max(a_hat_next) - a_hat_next(1)) > 60, break; end
            % if abs(fix(mean(a_hat_next, 1)) - a_hat_next(1)) > 60, break; end
            
            a_hat = a_hat_next;
            % find energy of quantization loss
            for b = bands
                idx = (wlow(b)+1):(whigh(b)+1);
                S(idx, i) = sign(X(idx)) .* fix((abs(X(idx)) .* 2.^(-1/4 * a_hat(b))).^(3/4) + magic);
                X_hat = sign(S(idx, i)) .* (abs(S(idx, i)).^(4/3)) .* 2.^(1/4 * a_hat(b));              
                Pe(b) = sum((X(idx) - X_hat).^2, 1);
            end
            
            bands = find(Pe < T(:, i));
            bands = bands';
            % end if loss energy is over acoystic threshold for all bands
            if size(bands, 2) == 0, break; end
            
            % increment by one band scalefactors that have yet to reach
            % the acoustic threshold
            a_hat_next = a_hat;
            a_hat_next(bands) = a_hat_next(bands) + 1;
        end
        sfc(:, i) = a_hat;
    end
    % G = fix(mean(sfc, 1));
    G = sfc(1, :);
    % G = max(sfc, [], 1);
    sfc = bsxfun(@minus, G, sfc);
    sfc(2:end, :) = sfc(2:end, :) - sfc(1:end-1, :); 
    S = S(:);
end

