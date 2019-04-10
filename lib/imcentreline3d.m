function [iml,x,y,z] = imcentreline3d(im)
%%  This is centerline of the hole
%   INPUT:
%       im     - 3D image segmented after cutting surface and rescaling
%
%   OUTPUT:
%       Centerline position
%      
%   USAGE:
%       Compute a smooth centerline
%
%   AUTHOR:
%       Amar V Nasrulloh, Boguslaw Obara
%
%% projections
c0 = im;

% XZ
c2 = sum(meshgrid(1:size(c0,2),1:size(c0,1),1:size(c0,3)).*c0,2)./ sum(c0,2);
c2 = squeeze(c2);
c2(isnan((c2))) = 0;
c22 = sum(meshgrid(1:size(c2,2),1:size(c2,1)).*c2,2)./ sum(c2,2);
c22 = squeeze(c22);
x = find(~isnan(c22));
z = c22(~isnan(c22));

% XY
c1 = permute(im,[1 3 2]);
c3 = sum(meshgrid(1:size(c1,2),1:size(c1,1),1:size(c1,3)).*c1,2)./ sum(c1,2);
c3 = squeeze(c3);
c3(isnan((c3))) = 0;
c32 = sum(meshgrid(1:size(c3,2),1:size(c3,1)).*c3,2)./ sum(c3,2);
c32 = squeeze(c32);
x = find(~isnan(c32));
y = c32(~isnan(c32));
%% center line image
iml = zeros(size(im));
xc = round(x);
yc = round(y);
zc = round(z);
iml(sub2ind(size(iml),xc,yc,zc)) = 1;
end