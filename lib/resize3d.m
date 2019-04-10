%%  This is cropping function for 3d image
%  
%   INPUT:
%       im - 3d image
%       
%   OUTPUT:
%       ims  - 3d resized image
%
%   USAGE:
%       
%

function ims = resize3d(im,x)
T = maketform('affine',[x(1) 0 0; 0 x(2) 0; 0 0 x(3); 0 0 0;]);
R = makeresampler({'linear','linear','linear'},'symmetric');
ims = tformarray(im,T,R,[1 2 3],[1 2 3], round(size(im).*x),[],0);
return