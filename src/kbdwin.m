function [WL, WR] = kbdwin(N, alpha)
    tsum = 0;
    WL = zeros(N/2, 1);
    w = kaiser(N/2+1, 2.8*pi*alpha);
    for n = 1:(N/2)
        tsum = tsum + w(n);
        WL(n) = tsum;
    end
    WL = sqrt(WL./tsum);
    WR = WL(end:-1:1);
    WL = WL(:);
    WR = WR(:);
end
