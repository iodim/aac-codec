clc; clear; close all;

load('TableB219');

bvall = B219a(:, 5);
bvals = B219b(:, 5);

Nl = size(B219a, 1);
Ns = size(B219b, 1);
xl = zeros(Nl);
xs = zeros(Ns);

for i = 1:Nl
    for j = 1:Nl
        if i >= j, tmpx = 3*(bvall(j) - bvall(i));
        else tmpx = 1.5*(bvall(j) - bvall(i)); end
        tmpz = 8 * min((tmpx - 0.5)^2 - 2*(tmpx - 0.5), 0);
        tmpy = 15.811389 + 7.5*(tmpx + 0.474) - 17.5*sqrt(1 + (tmpx + 0.474)^2);
        if tmpy < -100, xl(i, j) = 0;
        else xl(i, j) = 10^((tmpz + tmpy)/10); end            
    end
end

for i = 1:Ns
    for j = 1:Ns
        if i >= j, tmpx = 3*(bvals(j) - bvals(i));
        else tmpx = 1.5*(bvals(j) - bvals(i)); end
        tmpz = 8 * min((tmpx - 0.5)^2 - 2*(tmpx - 0.5), 0);
        tmpy = 15.811389 + 7.5*(tmpx + 0.474) - 17.5*sqrt(1 + (tmpx + 0.474)^2);
        if tmpy < -100, xs(i, j) = 0;
        else xs(i, j) = 10^((tmpz + tmpy)/10); end            
    end
end
