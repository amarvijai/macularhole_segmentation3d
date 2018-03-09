function [imcurv,imneg] = curv3d(imth,radius,c,dx,dy,dz)
%%  This is negative curvature
%   INPUT:
%       imth     - 3D image segmented from 3d levelset
%       radius   - radius of the kernel
%       c        - curvature parameter (default is 1)
%       dx,dy,dz - scale resolution for each axis to microns
%   OUTPUT:
%       imcurv  - 3D image curvature
%       imneg   - 3D negative curvature
%      
%   USAGE:
%       Creating negative curvature of 3D segmentation
%
%   AUTHOR:
%       Amar V Nasrulloh, Phil Jackson, Chris Willcocks
%
%% boundary
se = strel('disk',1);
boundary = xor(imth,imerode(imth,se));
%% curvature - kernel
rx = round(radius/dx); 
ry = round(radius/dy); 
rz = round(radius/dz);  
kernel1 = zeros(2*rx+1,2*ry+1,2*rz+1);
kernel1(rx+1,ry+1,rz+1) = 1;
kernel1 = bwdistsc(kernel1,[dx,dy,dz]);
kernel = double(kernel1<=radius);
%% curvature
imc = 2*(~imth)-c;
imc(boundary) = 0;
imcurv = imfilter(imc,kernel,'same','symmetric','conv');
%% nagative curvature
imneg = (imcurv .* boundary) < 0;
%% remove bottom and top
ind = find(imneg);
[x,y,z] = ind2sub(size(imth),ind);
xc = mean(x); %yc = mean(y); zc = mean(z);
idx = x>xc-std(x) & x<xc+0.3*std(x);
imneg(ind(~idx)) = 0;
end