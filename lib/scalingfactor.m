function [sx,sy,sz] = scalingfactor(n,nx,ny,nz)
%%  This is scaling factor for multiscale procedure
%  
%   INPUT:
%       n   - scaling size
%       nx  - scaling size of x-axis
%       ny  - scaling size of y-axis
%       nz  - scaling size of z-axis
%       
%   OUTPUT:
%       sx,sy,sz  - scaling size for each axis
%
%   USAGE:
%       
%
%   AUTHOR:
%       Amar V Nasrulloh
%%
s = zeros(1,n);
for i = 1:n
    s(i) = 1/(2^(n-i));
end
 for i = 1:n
    if nx == 1
        sx = [s(1,n) s(1,n) s(1,n)];
    else
        sx = s;
    end
 end
for i = 1:n
    if ny == 1
        sy = [s(1,n) s(1,n) s(1,n)];
    else
        sy = s;
    end
 end
for i = 1:n
    if nz == 1
        sz = [s(1,n) s(1,n) s(1,n)];
    else
        sz = s;
    end
 end
end