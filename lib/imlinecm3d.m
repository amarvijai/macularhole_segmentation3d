function [iml,x,y,z] = imlinecm3d(im)
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

% YZ
c2 = sum(meshgrid(1:size(c0,2),1:size(c0,1),1:size(c0,3)).*c0,2)./ sum(c0,2);
c2 = squeeze(c2);
c2(isnan((c2))) = 0;
c22 = sum(meshgrid(1:size(c2,2),1:size(c2,1)).*c2,2)./ sum(c2,2);
c22 = squeeze(c22);
x = find(~isnan(c22));
z = c22(~isnan(c22));

% ZY
c3 = sum(meshgrid(1:size(c0,2),1:size(c0,1),1:size(c0,3)).*c0,3)./ sum(c0,3);
c3 = squeeze(c3);
c3(isnan((c3))) = 0;
c32 = sum(meshgrid(1:size(c3,2),1:size(c3,1)).*c3,2)./ sum(c3,2);
c32 = squeeze(c32);
x = find(~isnan(c32));
y = c32(~isnan(c32));
%% center line image
iml = zeros(size(im));
for i=1:size(x,1)
    xc = round(x(i));
    yc = round(y(i));
    zc = round(z(i));
    iml(xc,yc,zc) = 1;
end
end