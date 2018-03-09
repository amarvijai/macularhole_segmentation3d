function [imp] = imperp3d(im,p,d,x,y,z,t)
% im: 3D inary image
% p: point on plane
% d: normal vector of plane
% x, y, z: vectors representing an array of 3D points
% t: distance threshold
% RETURNS: binary image same size as im, indicating all points in (x,y,z)
% that are within t voxels of the plane described by p and d
%% Plane perpendicular to the line
s1 = -0.5; s2 = 0.5;
p1 = [p(1) + s1*d(1), p(2) + s1*d(2), p(3) + s1*d(3)];
p2 = [p(1) + s2*d(1), p(2) + s2*d(2), p(3) + s2*d(3)];
plane = medianPlane(p1,p2);
%% Plane-Point distance
pd = zeros(length(x),1);
for i=1:length(x)
    pd(i) = distancePointPlane([x(i),y(i),z(i)],plane);
end
idx = abs(pd)<t;
imp = zeros(size(im));
imp(sub2ind(size(imp),x(idx),y(idx),z(idx))) = 1;
end