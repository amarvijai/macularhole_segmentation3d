%%  This is cropping function for 3d image
%  
%   INPUT:
%       m3d - 2D image
%       
%   OUTPUT:
%       Img  - 2d resized image
%
%   USAGE:
%       resizing 3d image 
%   AUTHOR:
%       Amar V Nasrulloh,
%
%   VERSION:
%       0.1 - 07/04/2016 First implementation
%
function [Img] = resize2d(m3d,x)

T = maketform('affine',[x(1) 0; 0 x(2); 0 0;]);
R = makeresampler({'linear','linear'},'symmetric');
Img = tformarray(m3d,T,R,[1 2],[1 2], round(size(m3d).*x),[],0);

return;